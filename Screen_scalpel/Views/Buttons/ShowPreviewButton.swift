//
//  ShowPreviewButton.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 31/03/2025.
//

import SwiftUI

struct ShowPreviewButton: View {
    @EnvironmentObject private var stateManager: NavigationStateManager
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    var fontSize: Font? = .title2
    var buttonSize: ControlSize? = .regular

    var body: some View {
        Button {
            if stateManager.previewVisible {
                stateManager.previewVisible.toggle()
                dismissWindow(id: WindowsIdentifiers.previewWindow)
                
            } else {
                stateManager.previewVisible.toggle()
                openWindow(id: WindowsIdentifiers.previewWindow)
            }
        } label: {
            Label("Show preview", systemImage: "eye")
                .labelStyle(.iconOnly)
                .font(fontSize)
                .help(Text("Show preview"))
        }
        .controlSize(buttonSize!)
        .disabled(stateManager.focusedImageUrl != nil ? false: true)
        .keyboardShortcut(.space, modifiers: [])
        .shadow(color: .gray, radius: 5, x: 5, y: 5)    }
}

#Preview {
    ShowPreviewButton()
        .environmentObject(NavigationStateManager())
}
