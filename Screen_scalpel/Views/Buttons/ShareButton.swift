//
//  ShareButton.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 01/04/2025.
//

import SwiftUI

struct ShareButton: View {
    @EnvironmentObject private var stateManager: NavigationStateManager

    var body: some View {
        if let image4Sharing = stateManager.focusedImageUrl {
            let imageTeransferable = ImageTransferable(url: image4Sharing)
            let imageName = image4Sharing.lastPathComponent
            
            ShareLink(item: imageTeransferable, preview: SharePreview(imageName, image: imageTeransferable))
                .disabled(stateManager.focusedImageUrl != nil ? false : true)
        } else {
            ShareLink(item: "")
                .disabled(true)
        }
    }
}

#Preview {
    ShareButton()
        .environmentObject(NavigationStateManager())
        .padding(10)
}
