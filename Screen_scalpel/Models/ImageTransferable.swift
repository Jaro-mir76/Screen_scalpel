//
//  ImageTransferable.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 20/03/2025.
//

import Foundation
import SwiftUI

struct ImageTransferable: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .png) { image in
            SentTransferredFile(image.url)
        }
    }
}
