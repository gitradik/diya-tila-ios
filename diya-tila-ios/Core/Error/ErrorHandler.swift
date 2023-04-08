//
//  ErrorHandler.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 07.04.2023.
//

import SwiftUI
import UserNotifications

// Abstract error handler
class ErrorHandler {
    static func handleAPIError(_ error: APIError) {
        print(error)
    }
}
