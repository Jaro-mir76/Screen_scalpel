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
        ForEach(screenCaptureEngine.screenshots, id: \.url) {screenshot in
            Image(nsImage: screenshot.thumbnail)
                .resizable()
//                    .scaleEffect(focusedImageUrl == screenshot.url ? 1.2 : 1)
                .scaledToFit()
                .frame(maxHeight: 75)
                .focusable()
                .focused($focusedImageUrl, equals: screenshot.url)
                .shadow(color: .gray, radius: 5)
                .padding(5)
                .onMoveCommand(perform: {direction in
                    switch direction {
                    case .up:
// TODO - but first have to find a way to control number of columns
                        return
                    case .down:
// TODO - but first have to find a way to control number of columns
                        return
                    case .left:
                        moveFocusLeft(url: screenshot.url)
                        return
                    case .right:
                        moveFocusRight(url: screenshot.url)
                        return
                    default:
                        print ("some new direction/feature not covered yet in the app")
                    }
                })
                .onDrag {
                    NSItemProvider(contentsOf: screenshot.url)!
                }
                .onCopyCommand(perform: {
                    [NSItemProvider(contentsOf: screenshot.url)!]
                })
                .contextMenu(menuItems: {
                    Button("Copy") {
                        screenCaptureEngine.createClipboardFrom(screenshot.url)
                    }
                    Button("Delete") {
                        screenCaptureEngine.screenshots.remove(at: screenCaptureEngine.screenshots.firstIndex(of: screenshot)!)
                        if !screenCaptureEngine.deleteScreenshotFile(screenshot.url) {
// TODO implement error management
                            print ("Something went wrong, couldn't delete the screenshot file")
                        }
                    }
                })
        }
        .onDeleteCommand {
            if focusedImageUrl != nil, focusedImageUrl == stateManager.focusedImageUrl {
                //                screenCaptureEngine.urls.remove(at: screenCaptureEngine.urls.firstIndex(of: focusedImageUrl!)!)
                screenCaptureEngine.screenshots.remove(at: screenCaptureEngine.screenshots.firstIndex(where: {$0.url == focusedImageUrl!})!)
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
        if let indexOfFocused = screenCaptureEngine.screenshots.firstIndex(where: {$0.url == url}), indexOfFocused > 0 {
            focusedImageUrl = screenCaptureEngine.screenshots[indexOfFocused - 1].url
        } else if let indexOfFocused = screenCaptureEngine.screenshots.firstIndex(where: {$0.url == url}), indexOfFocused == 0 {
            focusedImageUrl = screenCaptureEngine.screenshots.last?.url
        }
    }
    
    func moveFocusRight(url: URL) {
        if let indexOfFocused = screenCaptureEngine.screenshots.firstIndex(where: {$0.url == url}), screenCaptureEngine.screenshots.count > indexOfFocused + 1 {
            focusedImageUrl = screenCaptureEngine.screenshots[indexOfFocused + 1].url
        } else if let indexOfFocused = screenCaptureEngine.screenshots.firstIndex(where: {$0.url == url}), screenCaptureEngine.screenshots.count == indexOfFocused + 1 {
            focusedImageUrl = screenCaptureEngine.screenshots.first?.url
        }
    }
}

#Preview {
    ScreenshotsListView()
        .environmentObject(MainEngine())
        .environmentObject(NavigationStateManager())
}
