//
//  PreviewView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 28/03/2025.
//

import SwiftUI

struct PreviewView: View {
    @EnvironmentObject private var stateManager: NavigationStateManager

    var body: some View {
        if let image = stateManager.focusedImageUrl {
            AsyncImage(url: image) { image in
                image.resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
            } placeholder: {
                EmptyView()
            }
            .padding(10)
        }
    }
}

#Preview {
    PreviewView()
        .environmentObject(NavigationStateManager())
}
