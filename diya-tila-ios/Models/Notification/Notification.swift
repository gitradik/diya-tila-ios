//
//  Notification.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let duration: TimeInterval
}
