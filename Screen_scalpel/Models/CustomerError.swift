//
//  CustomerError.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import Foundation

enum CustomerError: Error, LocalizedError{
    case noWritePermission
    
    var failureReason: String? {
        switch self {
        case .noWritePermission:
            return "You don't have write permission to the specified folder!"
        }
    }
    
    var howToFixAdvice: String? {
        switch self {
        case .noWritePermission:
            return "Make sure you have write persmission or choose different folder!"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .noWritePermission:
            return "You don't have write permission to the specified folder!"
        }
    }
}
