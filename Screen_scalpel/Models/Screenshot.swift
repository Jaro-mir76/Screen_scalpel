//
//  Screenshot.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 07/04/2025.
//

import Foundation
import AppKit

struct Screenshot: Equatable {
    var url: URL
    var thumbnail: NSImage
    var creationDate: Date
}
