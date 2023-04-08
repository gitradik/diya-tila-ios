//
//  NotificationStore.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

class NotificationStore: ObservableObject {
    static let shared = NotificationStore()

    @Published private var notificationInfos: [NotificationInfo] = []

    func showNotification(title: String, message: String, duration: TimeInterval) {
        let notification = Notification(title: title, message: message, duration: duration)
        let notificationInfo = NotificationInfo(notification: notification)
        notificationInfos.append(notificationInfo)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.notificationInfos.removeAll(where: { $0.id == notificationInfo.id })
            }
        }
    }

    var notifications: [Notification] {
        return notificationInfos.map { $0.notification }
    }
}
