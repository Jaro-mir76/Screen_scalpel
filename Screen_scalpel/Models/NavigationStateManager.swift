//
//  NavigationStateManager.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
class NavigationStateManager: ObservableObject {
    
    @Published var customError: CustomError? = nil
    @Published var previewVisible: Bool = false
    @Published var focusedImageUrl: URL?
//    @AppStorage(AppStorageKeys.defaultScreenshotsDirectoryURL) var screenshotsDirectory: URL = URL.picturesDirectory
//    @AppStorage(AppStorageKeys.menuBarExtraIsVisible) var menuBarExtraIsVisible: Bool = false
    
}
