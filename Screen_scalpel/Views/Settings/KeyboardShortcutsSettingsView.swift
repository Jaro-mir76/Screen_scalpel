//
//  KeyboardShortcutsSettingsView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI
import KeyboardShortcuts

struct KeyboardShortcutsSettingsView: View {
    
    @State var shortcut3: String = ""
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Selection capture", name: .selectionCapture)
            KeyboardShortcuts.Recorder("Window capture", name: .windowCapture)
            KeyboardShortcuts.Recorder("Screen capture", name: .screenCapture)
        }
        .padding()
    }
}

#Preview {
    KeyboardShortcutsSettingsView()
}
