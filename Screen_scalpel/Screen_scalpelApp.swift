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
    @StateObject var screenCaptureEngine = MainEngine()
    @AppStorage("menuBarExtraIsVisible") var menuBarExtraIsVisible: Bool = true
    @Environment(\.openWindow) var openWindow
    
    var body: some Scene {
        
        Window("Screen Scalpel", id: "mainWindow") {
            ContentView()
        }
        .commands(content: {
            #if os(macOS)
            ImportFromDevicesCommands()
            #endif
        })
        .environmentObject(stateManager)
        .environmentObject(screenCaptureEngine)
        
        WindowGroup(id: WindowsIdentifiers.importFromIPhone) {
            ContinuityCameraView()
        }
        .environmentObject(screenCaptureEngine)
        .commands {
            #if os(macOS)
            ImportFromDevicesCommands()
            #endif
        }
        
        MenuBarExtra("Screen Scalpel", systemImage: "crop", isInserted: $menuBarExtraIsVisible) {
            MenuBarExtraView()
        }
        .environmentObject(screenCaptureEngine)
        .environmentObject(stateManager)
        .menuBarExtraStyle(.window)
        
        UtilityWindow("Preview", id: WindowsIdentifiers.previewWindow) {
            PreviewView()
        }
        .environmentObject(stateManager)
        
        Settings{
            SettingsView()
        }
        .environmentObject(stateManager)
        .environmentObject(screenCaptureEngine)
    }
}
