//
//  ContinuityCameraView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 21/03/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContinuityCameraView: View {
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    @Environment(\.dismiss) private var dismiss
    @State private var importedImage: NSImage? = nil
    var importImageTypes = NSImage.imageTypes.compactMap {UTType($0)}
    
    var body: some View {
        ZStack {
            Color.gray
            if let importedImage {
                Image(nsImage: importedImage)
                    .resizable()
                    .scaledToFit()
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .labelStyle(.iconOnly)
                            .font(.title2)
                            .frame(height: 25)
                    }
                    .shadow(color: .gray, radius: 10, x: 5, y: 5)
                    
                    Button {
                        screenCaptureEngine.addImportedImage(importedImage)
                        dismiss()
                    } label: {
                        Text("Use image")
                            .labelStyle(.iconOnly)
                            .font(.title2)
                            .frame(height: 25)
                    }
                    .shadow(color: .gray, radius: 10, x: 5, y: 5)
                }
// TODO - offset should be done base on screen size to avoid buttons disappear from screen
            .offset(y: 140)
            }
        }
        .importsItemProviders(importImageTypes) { itemProvider in
            for provider in itemProvider {
                let _ = provider.loadDataRepresentation(for: .jpeg) { data, error in
                    guard let data else { return }
                    guard let importedImage = NSImage(data: data) else { return }
                    self.importedImage = importedImage
                }
            }
            return true
        }
    }
}

#Preview {
    ContinuityCameraView()
        .environmentObject(MainEngine())
}
