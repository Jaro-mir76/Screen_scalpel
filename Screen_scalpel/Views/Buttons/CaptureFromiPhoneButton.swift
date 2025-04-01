//
//  CaptureFromiPhoneButton.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 31/03/2025.
//

import SwiftUI

struct CaptureFromiPhoneButton: View {
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    @Environment(\.openWindow) var openWindow
    var fontSize: Font? = .largeTitle
    var buttonSize: ControlSize? = .regular
    
    var body: some View {
        Button {
            openWindow(id: WindowsIdentifiers.importFromIPhone)
        } label: {
            Label("Import from iPhone", systemImage: "camera.viewfinder")
                .labelStyle(.iconOnly)
                .font(fontSize)
                .help(Text("Capture entire screen"))
        }
        .controlSize(buttonSize!)
        .shadow(color: .gray, radius: 5, x: 5, y: 5)    }
}

#Preview {
    CaptureFromiPhoneButton()
        .environmentObject(MainEngine())
}
