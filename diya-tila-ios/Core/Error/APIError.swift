//
//  APIError.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 07.04.2023.
//

import SwiftUI

enum APIError: Error {
    case invalidURL(String?)
    case invalidResponse(String?)
    case requestFailed(String?)
    case decodingFailed(String?)
    
    var errorMessage: String {
        switch self {
        case .invalidURL(var message):
            return getDefaultMessage("Invalid URL", message)
        case .invalidResponse(let message):
            return getDefaultMessage("Invalid Response", message)
        case .requestFailed(let message):
            return getDefaultMessage("Request Failed", message)
        case .decodingFailed(let message):
            return getDefaultMessage("Decoding Failed", message)
        }
    }
    
    private func getDefaultMessage(_ errorName: String, _ message: String?) -> String {
        guard let msg = message else {
            return "\"\(errorName)\""
        }
        return "\"\(errorName)\" \(msg)"
    }
}
