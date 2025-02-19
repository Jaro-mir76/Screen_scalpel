//
//  SettingsView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "rectangle.topthird.inset")
                }
            KeyboardShortcutsSettingsView()
                .tabItem {
                    Label("Keyboard", systemImage: "keyboard")
                }
        }
        .frame(width: 800, height: 200)
    }
}

#Preview {
    SettingsView()
}
