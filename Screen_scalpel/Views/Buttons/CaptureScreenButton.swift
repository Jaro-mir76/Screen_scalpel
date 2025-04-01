//
//  CaptureScreenButton.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 31/03/2025.
//

import SwiftUI

struct CaptureScreenButton: View {
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    var fontSize: Font? = .largeTitle
    var buttonSize: ControlSize? = .regular
    
    var body: some View {
        Button {
            screenCaptureEngine.takeScreenshot(of: .screen)
        } label: {
            Label("Capture entire screen", systemImage: "inset.filled.rectangle")
                .labelStyle(.iconOnly)
                .font(fontSize)
                .help(Text("Capture entire screen"))
        }
        .controlSize(buttonSize!)
        .shadow(color: .gray, radius: 5, x: 5, y: 5)    }
}

#Preview {
    CaptureScreenButton()
        .environmentObject(MainEngine())
}
