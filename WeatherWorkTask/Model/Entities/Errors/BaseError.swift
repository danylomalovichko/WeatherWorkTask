//
//  BaseError.swift
//  OfficeHours
//
//  Created by Oleksandr Malovichko on 09.12.2020.
//

import Foundation
import SwiftUI

public enum BaseError: Error {
    case error
    case notImplementedYet
    case somethingWhenWrong(message: String)
    
    private func generalDescription() -> String {
        switch self {
        case .error:
            return "An Unexpected Error Occurred"
        case .notImplementedYet:
            return "Not implemented yet"
        case .somethingWhenWrong(let message):
            return message
        }
    }
}

extension BaseError: LocalizedError {
    public var errorDescription: String? {
        generalDescription()
    }
}

extension BaseError: CustomStringConvertible {
    public var description: String {
        generalDescription()
    }
}
