//
//  NotificationInfo.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

struct NotificationInfo: Identifiable {
    let id = UUID()
    let notification: Notification
    let endTime: Date

    init(notification: Notification) {
        self.notification = notification
        self.endTime = Date().addingTimeInterval(notification.duration)
    }

    var isExpired: Bool {
        return endTime <= Date()
    }
}
