//
//  KeyboardShortcuts+Global.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let screenCapture = Self("screenCapture", default: .init(.five, modifiers: [.option, .command]))
    static let windowCapture = Self("windowCapture", default: .init(.four, modifiers: [.option, .command]))
    static let selectionCapture = Self("selectionCapture", default: .init(.three, modifiers: [.option, .command]))
}
