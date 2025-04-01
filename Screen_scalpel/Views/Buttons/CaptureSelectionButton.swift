//
//  CaptureScreenButton.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 31/03/2025.
//

import SwiftUI

struct CaptureSelectionButton: View {
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    var fontSize: Font? = .largeTitle
    var buttonSize: ControlSize? = .regular

    var body: some View {
        Button {
            screenCaptureEngine.takeScreenshot(of: .selection)
        } label: { Label("Capture selected screen part", systemImage: "crop")
                .labelStyle(.iconOnly)
                .font(fontSize)
                .help(Text("Capture selected screen part"))
        }
        .controlSize(buttonSize!)
        .shadow(color: .gray, radius: 5, x: 5, y: 5)
    }
}

#Preview {
    CaptureSelectionButton()
        .environmentObject(MainEngine())
}
