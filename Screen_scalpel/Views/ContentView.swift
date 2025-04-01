//
//  ContentView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    @EnvironmentObject private var stateManager: NavigationStateManager
    @FocusState private var focusedImageUrl: URL?
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView{
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 200))]) {
                        ScreenshotsListView()
                    }
                    .padding(5)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                CaptureSelectionButton(fontSize: .title, buttonSize: .large)
                                CaptureWindowButton(fontSize: .title, buttonSize: .large)
                                CaptureScreenButton(fontSize: .title, buttonSize: .large)
                                CaptureFromiPhoneButton(fontSize: .title, buttonSize: .large)
                            }
                        }

                        ToolbarItem(placement: .primaryAction) {
                            HStack {
                                OpenInFinderButton(fontSize: .title2, buttonSize: .regular)
                                ShowPreviewButton(fontSize: .title2, buttonSize: .regular)
                                ImportImagesButton(fontSize: .title2, buttonSize: .regular)
                                ShareButton()
                            }
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.top, 5)
            .padding(.horizontal, 5)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MainEngine())
        .environmentObject(NavigationStateManager())
        .frame(width: 800, height: 400)
}
