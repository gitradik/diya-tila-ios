//
//  NotificationView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 08.04.2023.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var notificationStore = NotificationStore.shared
    
    var body: some View {
        VStack {
            VStack(spacing: 2) {
                ForEach(notificationStore.notifications) { notification in
                    VStack {
                        Text(notification.title)
                            .font(.headline)
                        Text(notification.message)
                            .font(.subheadline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.slide)
                }
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            Spacer()
        }.padding(.horizontal)
    }
}


