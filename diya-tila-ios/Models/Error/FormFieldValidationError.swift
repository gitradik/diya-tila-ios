//
//  FormFieldValidationError.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

enum FormFieldValidationError: ERRWithMessage {
    case emptyField
    case invalidFormat
    case maxLengthExceeded(Int)
    case minLengthNotMet(Int)
    case customError(String)

    var errorMessage: String {
        switch self {
        case .emptyField:
            return "Field cannot be empty."
        case .invalidFormat:
            return "Field has invalid format."
        case .maxLengthExceeded(let maxLength):
            return "Field cannot exceed \(maxLength) characters."
        case .minLengthNotMet(let minLength):
            return "Field must be at least \(minLength) characters."
        case .customError(let error):
            return error
        }
    }
}
