//
//  MainEngine.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI
import KeyboardShortcuts
import UniformTypeIdentifiers

@MainActor
class MainEngine: ObservableObject {
    @Published var images = [NSImage]()
    @AppStorage(AppStorageKeys.defaultScreenshotsDirectoryURL) var defaultScreenshotsDirectoryURL: URL = URL.picturesDirectory
    
    init() {
        KeyboardShortcuts.onKeyUp(for: .screenCapture) { [self] in
            self.takeScreenshot(of: .screen)
        }
        KeyboardShortcuts.onKeyUp(for: .windowCapture) { [self] in
            self.takeScreenshot(of: .window)
        }
        KeyboardShortcuts.onKeyUp(for: .selectionCapture) { [self] in
            self.takeScreenshot(of: .selection)
        }
    }
    
    enum ScreenShotTypes {
        case screen
        case window
        case selection
        
        var processArguments: [String] {
            switch self {
            case .screen: return ["-S"]
            case .window: return ["-w"]
            case .selection: return ["-s"]
            }
        }
    }
    
    func takeScreenshot(of type: ScreenShotTypes) {
        
        let toolURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        let taskArguments: [String] = type.processArguments + [prepareImageFileName()]
        
//  some code below taken from apple developer forum: https://developer.apple.com/forums/thread/690310
        
        try! launch(tool: toolURL, arguments: taskArguments) { (status, outputData) in
            let output = String(data: outputData, encoding: .utf8) ?? ""
            print("done, status: \(status), output: \(output)")
        }
    }
    
    /// Runs the specified tool as a child process, supplying `stdin` and capturing `stdout`.
    ///
    /// - important: Must be run on the main queue.
    ///
    /// - Parameters:
    ///   - tool: The tool to run.
    ///   - arguments: The command-line arguments to pass to that tool; defaults to the empty array.
    ///   - input: Data to pass to the tool’s `stdin`; defaults to empty.
    ///   - completionHandler: Called on the main queue when the tool has terminated.

    func launch(tool: URL, arguments: [String] = [], input: Data = Data(), completionHandler: @escaping CompletionHandler) {
        // This precondition is important; read the comment near the `run()` call to
        // understand why.
        dispatchPrecondition(condition: .onQueue(.main))

        let group = DispatchGroup()
        let inputPipe = Pipe()
        let outputPipe = Pipe()

        var errorQ: Error? = nil
        var output = Data()

        let proc = Process()
        proc.executableURL = tool
        proc.arguments = arguments
        proc.standardInput = inputPipe
        proc.standardOutput = outputPipe
        proc.standardError = outputPipe     // I've added this line to get output from std errror
        group.enter()
        proc.terminationHandler = { _ in
            // This bounce to the main queue is important; read the comment near the
            // `run()` call to understand why.
            DispatchQueue.main.async {
                group.leave()
            }
        }

        // This runs the supplied block when all three events have completed (task
        // termination and the end of both I/O channels).
        //
        // - important: If the process was never launched, requesting its
        // termination status raises an Objective-C exception (ouch!).  So, we only
        // read `terminationStatus` if `errorQ` is `nil`.

        group.notify(queue: .main) {
            if let error = errorQ {
                completionHandler(.failure(error), output)
            } else {
                completionHandler(.success(proc.terminationStatus), output)
            }
        }
        
        do {
            func posixErr(_ error: Int32) -> Error { NSError(domain: NSPOSIXErrorDomain, code: Int(error), userInfo: nil) }

            // If you write to a pipe whose remote end has closed, the OS raises a
            // `SIGPIPE` signal whose default disposition is to terminate your
            // process.  Helpful!  `F_SETNOSIGPIPE` disables that feature, causing
            // the write to fail with `EPIPE` instead.
            
            let fcntlResult = fcntl(inputPipe.fileHandleForWriting.fileDescriptor, F_SETNOSIGPIPE, 1)
            guard fcntlResult >= 0 else { throw posixErr(errno) }

            // Actually run the process.
            
            try proc.run()
            
            // At this point the termination handler could run and leave the group
            // before we have a chance to enter the group for each of the I/O
            // handlers.  I avoid this problem by having the termination handler
            // dispatch to the main thread.  We are running on the main thread, so
            // the termination handler can’t run until we return, at which point we
            // have already entered the group for each of the I/O handlers.
            //
            // An alternative design would be to enter the group at the top of this
            // block and then leave it in the error hander.  I decided on this
            // design because it has the added benefit of all my code running on the
            // main queue and thus I can access shared mutable state, like `errorQ`,
            // without worrying about thread safety.
            
            // Enter the group and then set up a Dispatch I/O channel to write our
            // data to the child’s `stdin`.  When that’s done, record any error and
            // leave the group.
            //
            // Note that we ignore the residual value passed to the
            // `write(offset:data:queue:ioHandler:)` completion handler.  Earlier
            // versions of this code passed it along to our completion handler but
            // the reality is that it’s not very useful. The pipe buffer is big
            // enough that it usually soaks up all our data, so the residual is a
            // very poor indication of how much data was actually read by the
            // client.

            group.enter()
            let writeIO = DispatchIO(type: .stream, fileDescriptor: inputPipe.fileHandleForWriting.fileDescriptor, queue: .main) { _ in
                // `FileHandle` will automatically close the underlying file
                // descriptor when you release the last reference to it.  By holidng
                // on to `inputPipe` until here, we ensure that doesn’t happen. And
                // as we have to hold a reference anyway, we might as well close it
                // explicitly.
                //
                // We apply the same logic to `readIO` below.
                try! inputPipe.fileHandleForWriting.close()
            }
            let inputDD = input.withUnsafeBytes { DispatchData(bytes: $0) }
            writeIO.write(offset: 0, data: inputDD, queue: .main) { isDone, _, error in
                if isDone || error != 0 {
                    writeIO.close()
                    if errorQ == nil && error != 0 { errorQ = posixErr(error) }
                    group.leave()
                }
            }

            // Enter the group and then set up a Dispatch I/O channel to read data
            // from the child’s `stdin`.  When that’s done, record any error and
            // leave the group.

            group.enter()
            let readIO = DispatchIO(type: .stream, fileDescriptor: outputPipe.fileHandleForReading.fileDescriptor, queue: .main) { _ in
                try! outputPipe.fileHandleForReading.close()
            }
            readIO.read(offset: 0, length: .max, queue: .main) { isDone, chunkQ, error in
                output.append(contentsOf: chunkQ ?? .empty)
                if isDone || error != 0 {
                    readIO.close()
                    if errorQ == nil && error != 0 { errorQ = posixErr(error) }
                    group.leave()
                }
            }
        } catch {
            // If either the `fcntl` or the `run()` call threw, we set the error
            // and manually call the termination handler.  Note that we’ve only
            // entered the group once at this point, so the single leave done by the
            // termination handler is enough to run the notify block and call the
            // client’s completion handler.
            errorQ = error
            proc.terminationHandler!(proc)
        }
    }

    /// Called when the tool has terminated.
    ///
    /// This must be run on the main queue.
    ///
    /// - Parameters:
    ///   - result: Either the tool’s termination status or, if something went
    ///   wrong, an error indicating what that was.
    ///   - output: Data captured from the tool’s `stdout`.

    typealias CompletionHandler = (_ result: Result<Int32, Error>, _ output: Data) -> Void
    
    func prepareImageFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm-ss-SSS"
        let fileName: String = "screenshot_" + dateFormatter.string(from: Date())
        let fileURL = defaultScreenshotsDirectoryURL.appendingPathComponent(fileName, conformingTo: .png)
        return fileURL.relativePath
    }
    
    private func getDefaultPictureURL() throws -> URL {
        let pictureFolderURL: URL = try FileManager.default.url(for: .picturesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return pictureFolderURL
    }
    
    func addImagetoImagesAndPastboard() {
        
    }
    
    func openInFinder() {
        NSWorkspace.shared.open(URL(filePath: defaultScreenshotsDirectoryURL.path(), directoryHint: .isDirectory))
    }
    
    private func getImageFromPastboard() {
        guard NSPasteboard.general.canReadItem(withDataConformingToTypes: NSImage.imageTypes) else { return }
        guard let image = NSImage(pasteboard: NSPasteboard.general) else {return}
        self.images.append(image)
    }
}
