//
//  ImportImagesButton.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 31/03/2025.
//

import SwiftUI

struct ImportImagesButton: View {
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    var fontSize: Font? = .title2
    var buttonSize: ControlSize? = .regular
    
    var body: some View {
        Button {
            screenCaptureEngine.importScreenshotsFromFolder()
        } label: {
            Label("Import screenshots from current folder", systemImage: "square.and.arrow.down")
                .labelStyle(.iconOnly)
                .font(fontSize)
//                .frame(width: 20, height: 25)
                .help(Text("Import screenshots from current folder"))
        }
        .controlSize(buttonSize!)
        .shadow(color: .gray, radius: 5, x: 5, y: 5)    }
}

#Preview {
    ImportImagesButton()
        .environmentObject(MainEngine())
}
