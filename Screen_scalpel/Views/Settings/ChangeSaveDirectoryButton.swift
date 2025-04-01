//
//  ChangeSaveDirectoryButton.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ChangeSaveDirectoryButton: View {
    
    @EnvironmentObject var navigationState: NavigationStateManager
    @State private var showAlert: Bool = false
    @AppStorage(AppStorageKeys.defaultScreenshotsDirectoryURL) var screenshotsDirectory: URL = URL.picturesDirectory
    
    var body: some View {
        Button("Change") {
            setNewDirectory()
        }
        .alert(isPresented: $showAlert, error: navigationState.customError) { _ in
            Button("OK", role: .cancel) {
            }
        } message: { error in
            Text(navigationState.customError?.howToFixAdvice ?? "Unknown error")
        }
    }

    func setNewDirectory() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [.directory]
        
        openPanel.begin { response in
            switch response {
                case .OK:
                    if let url = openPanel.url {
                        screenshotsDirectory = url
                        if !checkWritePermision(screenshotsDirectory) {
                            navigationState.customError = .noWritePermission
                            showAlert = true
                        }
                    }
                case .cancel:
                    if !checkWritePermision(screenshotsDirectory) {
                        navigationState.customError = .noWritePermission
                        showAlert = true
                    }
                case .abort: break
                default: break
            }
        }
    }
    
    func checkWritePermision(_ directoryUrl: URL) -> Bool {
//         Not sure why but after latest OS update this isn't working properly any more, or I don't know how to use it
//        if !FileManager.default.isWritableFile(atPath: directoryUrl.path()) {
//            navigationState.customError = .noWritePermission
//            showAlert = true
//        }
        let tmpFileUrl = prepareTmpFileName(inDirectory: directoryUrl)
        let tmpData = Data()
        do {
            try tmpData.write(to: tmpFileUrl, options: .atomic)
            try FileManager.default.removeItem(atPath: tmpFileUrl.relativePath)
        } catch {
            return false
        }
        return true
    }
    
    func prepareTmpFileName(inDirectory directoryUrl: URL) -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm-ss-SSS"
        let fileName: String = "screen_scalpel_tmp_file_" + dateFormatter.string(from: Date())
        let fileURL = directoryUrl.appendingPathComponent(fileName)
        return fileURL
    }
}

#Preview {
    ChangeSaveDirectoryButton()
        .environmentObject(NavigationStateManager())
}
