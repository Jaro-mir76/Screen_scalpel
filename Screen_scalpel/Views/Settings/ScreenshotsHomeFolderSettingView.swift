//
//  ScreenshotsHomeFolderSettingView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI

struct ScreenshotsHomeFolderSettingView: View {
    
    @AppStorage(AppStorageKeys.defaultScreenshotsDirectoryURL) var screenshotsDirectory: URL = URL.picturesDirectory
    @EnvironmentObject private var screenCaptureModel: MainEngine
//    @EnvironmentObject var stateManager: NavigationStateManager
    
    var body: some View {
        VStack(alignment: .trailing) {
            @State var URLstring: String = screenshotsDirectory.relativePath
            TextField("Screenshots folder: ", text: $URLstring)
                .disabled(true)
                
            HStack {
                Button("Show in Finder") {
//                    screenCaptureModel.openInFinder()
                    NSWorkspace.shared.open(URL(filePath: screenshotsDirectory.path(), directoryHint: .isDirectory))
                }
                ChangeSaveDirectoryButton()
            }
        }
    }
}

#Preview {
    ScreenshotsHomeFolderSettingView()
        .environmentObject(MainEngine())
//        .environmentObject(NavigationStateManager())
        .padding()
        
}
