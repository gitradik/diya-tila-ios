//
//  APIError.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 07.04.2023.
//

import SwiftUI

enum APIError: ERRWithMessage {
    case invalidURL(String?)
    case invalidResponse(String?)
    case requestFailed(String?)
    case decodingFailed(String?)
    
    var errorMessage: String {
        switch self {
        case .invalidURL(var message):
            return createMessage("Invalid URL", message)
        case .invalidResponse(let message):
            return createMessage("Invalid Response", message)
        case .requestFailed(let message):
            return createMessage("Request Failed", message)
        case .decodingFailed(let message):
            return createMessage("Decoding Failed", message)
        }
    }
    
    private func createMessage(_ errorName: String, _ message: String?) -> String {
        guard let msg = message else {
            return "\"\(errorName)\""
        }
        return "\"\(errorName)\" \(msg)"
    }
}
