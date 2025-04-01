//
//  OpenInFinderButton.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 31/03/2025.
//

import SwiftUI

struct OpenInFinderButton: View {
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    var fontSize: Font? = .largeTitle
    var buttonSize: ControlSize? = .regular

    var body: some View {
        Button {
            screenCaptureEngine.openInFinder()
        } label: {
            Label("Show screenshots folder", systemImage: "folder")
                .labelStyle(.iconOnly)
                .font(fontSize)
                .help(Text("Show in Finder"))
        }
        .controlSize(buttonSize!)
        .shadow(color: .gray, radius: 5, x: 5, y: 5)    }
}

#Preview {
    OpenInFinderButton()
        .environmentObject(MainEngine())
}
