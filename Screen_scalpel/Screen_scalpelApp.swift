//
//  Screen_scalpelApp.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct ScreenSniperApp: App {
    
    @StateObject var stateManager = NavigationStateManager()
    @AppStorage("menuBarExtraIsVisible") var menuBarExtraIsVisible: Bool = false
    @StateObject var screenCaptureEngine = MainEngine()
    
    var body: some Scene {
        
        Window("Screen Scalpel", id: "mainWindow") {
            ContentView()
        }
        .environmentObject(stateManager)
        .environmentObject(screenCaptureEngine)
        
        MenuBarExtra("Screen Scalpel", systemImage: "dot.scope", isInserted: $menuBarExtraIsVisible) {
            MenuBarExtraView(screenCaptureModel: screenCaptureEngine)
        }
        .environmentObject(stateManager)
        .menuBarExtraStyle(.window)
        
        Settings{
            SettingsView()
        }
        .environmentObject(stateManager)
        .environmentObject(screenCaptureEngine)
    }
}
