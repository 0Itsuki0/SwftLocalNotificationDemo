//
//  ContentView.swift
//  LocalNotificationDemo
//
//  Created by Itsuki on 2024/07/13.
//

import SwiftUI

struct ContentView: View {
    private let notificationManager = NotificationManager()
    
    var body: some View {
        VStack(spacing: 40) {
            RoundedBorderButton(action: {
                Task {
                    await notificationManager.registerCalendarNotification()
                }
            }, label: {
                Text("UNCalendarNotificationTrigger\nOn Daily 8:30")
            })
            
            RoundedBorderButton(action: {
                Task {
                    await notificationManager.registerTimeIntervalNotification()
                }
            }, label: {
                Text("UNTimeIntervalNotificationTrigger\nIn 5 seconds!")
            })
            
            RoundedBorderButton(action: {
                Task {
                    await notificationManager.registerLocationNotification()
                }
            }, label: {
                Text("UNLocationNotificationTrigger\nEntering!")
            })
            
            
            RoundedBorderButton(action: {
                notificationManager.removePendingNotifications()
            }, label: {
                Text("Cancel All")
            })
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.2))
    }
}


private struct RoundedBorderButton<Label>: View where Label: View  {
    var action: () -> Void
    @ViewBuilder var label: Label
    var maxWidth: CGFloat? = nil
    
    var body: some View {
        Button {
            action()
        } label: {
            label
        }
        .foregroundStyle(.white)
        .font(.system(size: 16))
        .lineSpacing(10)
        .multilineTextAlignment(.center)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(.black))

    }

}

extension RoundedBorderButton {
    init(action: @escaping () -> Void, label: Label, maxWidth: CGFloat? = nil) {
        self.action = action
        self.label = label
        self.maxWidth = maxWidth
    }
}

#Preview {
    ContentView()
}
