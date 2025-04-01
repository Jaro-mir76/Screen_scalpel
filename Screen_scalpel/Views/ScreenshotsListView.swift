//
//  ScreenshotsListView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 31/03/2025.
//

import SwiftUI

struct ScreenshotsListView: View {
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    @EnvironmentObject private var stateManager: NavigationStateManager
    @Environment(\.dismissWindow) var dismissWindow
    @FocusState private var focusedImageUrl: URL?
    
    var body: some View {
        ForEach(screenCaptureEngine.urls, id: \.self ) { url in
            if screenCaptureEngine.images[url] != nil {
                Image(nsImage: screenCaptureEngine.images[url]!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 75)
                    .focusable()
                    .focused($focusedImageUrl, equals: url)
                    .shadow(color: .gray, radius: 5)
                    .padding(5)
                    .onMoveCommand(perform: {direction in
                        switch direction {
                        case .up:
                            return
                        case .down:
                            return
                        case .left:
                            moveFocusLeft(url: url)
                            return
                        case .right:
                            moveFocusRight(url: url)
                            return
                        default:
                            print ("some new direction/feature not covered yet in the app")
                        }
                    })
                    .onDrag {
                        NSItemProvider(contentsOf: url)!
                    }
                    .onCopyCommand(perform: {
                        [NSItemProvider(contentsOf: url)!]
                    })
                    .contextMenu(menuItems: {
                        Button("Copy") {
                            screenCaptureEngine.createClipboardFrom(url)
                        }
                        Button("Delete") {
                            screenCaptureEngine.urls.remove(at: screenCaptureEngine.urls.firstIndex(of: url)!)
                            screenCaptureEngine.images[url] = nil
                            if !screenCaptureEngine.deleteScreenshotFile(url) {
// TODO implement error management
                                print ("Something went wrong, couldn't delete the screenshot file")
                            }
                        }
                    })
            }
        }
        .onDeleteCommand {
            if focusedImageUrl != nil, focusedImageUrl == stateManager.focusedImageUrl {
                screenCaptureEngine.urls.remove(at: screenCaptureEngine.urls.firstIndex(of: focusedImageUrl!)!)
                screenCaptureEngine.images[focusedImageUrl!] = nil
                stateManager.focusedImageUrl = nil
                if stateManager.previewVisible {
                    stateManager.previewVisible.toggle()
                    dismissWindow(id: WindowsIdentifiers.previewWindow)
                }
                if !screenCaptureEngine.deleteScreenshotFile(focusedImageUrl!) {
// TODO implement error management
                    print ("Something went wrong, couldn't delete the screenshot file")
                }
            }
        }
        .onChange(of: focusedImageUrl) { oldValue, newValue in
            stateManager.focusedImageUrl = focusedImageUrl
        }
    }
    
    func moveFocusLeft(url: URL) {
        if let indexOfFocused = screenCaptureEngine.urls.firstIndex(where: {$0 == url}), indexOfFocused > 0 {
            focusedImageUrl = screenCaptureEngine.urls[indexOfFocused - 1 ]
        } else if let indexOfFocused = screenCaptureEngine.urls.firstIndex(where: {$0 == url}), indexOfFocused == 0 {
            focusedImageUrl = screenCaptureEngine.urls.last
        }
    }
    
    func moveFocusRight(url: URL) {
        if let indexOfFocused = screenCaptureEngine.urls.firstIndex(where: {$0 == url}), screenCaptureEngine.urls.count > indexOfFocused + 1 {
            focusedImageUrl = screenCaptureEngine.urls[indexOfFocused + 1]
        } else if let indexOfFocused = screenCaptureEngine.urls.firstIndex(where: {$0 == url}), screenCaptureEngine.urls.count == indexOfFocused + 1 {
            focusedImageUrl = screenCaptureEngine.urls.first
        }
    }
}

#Preview {
    ScreenshotsListView()
        .environmentObject(MainEngine())
        .environmentObject(NavigationStateManager())
}
