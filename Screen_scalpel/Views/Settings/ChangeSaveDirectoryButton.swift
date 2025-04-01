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
                        checkWritePermision(screenshotsDirectory)
                    }
                case .cancel:
                    checkWritePermision(screenshotsDirectory)
                case .abort: break
                default: break
            }
        }
    }
    
    func checkWritePermision(_ directoryUrl: URL) {
        if !FileManager.default.isWritableFile(atPath: directoryUrl.path()) {
            navigationState.customError = .noWritePermission
            showAlert = true
        }
    }
}

#Preview {
    ChangeSaveDirectoryButton()
        .environmentObject(NavigationStateManager())
}
