//
//  NotificationManager.swift
//  LocalNotificationDemo
//
//  Created by Itsuki on 2024/07/13.
//

import SwiftUI
import CoreLocation

class NotificationManager {
    private let notificationCenter = UNUserNotificationCenter.current()
    private let manager = CLLocationManager()
    
    private let timerActionableIdentifier = "TIMER_ACTION"
    private let rescheduleActionIdentifier = "RESCHEDULE_ACTION"
    private let dismissActionIdentifier = "DISMISS_ACTION"
    
    // Request user permissions
    func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            print("Permission granted: \(granted)")
        }
    }
    
    // Declare custom Actionable Notification Types
    func declareCustomTimerActionable() {
        let rescheduleAction = UNNotificationAction(identifier: rescheduleActionIdentifier,
                                                    title: "Schedule Again",
                                                    options: [])
        let dismissAction = UNNotificationAction(identifier: dismissActionIdentifier,
                                                 title: "Dismiss",
                                                 options: [])
        
        // Define the notification type
        let timerActionableCategory = UNNotificationCategory(
            identifier: timerActionableIdentifier,
            actions: [rescheduleAction, dismissAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )
        // Register the notification type.
        notificationCenter.setNotificationCategories([timerActionableCategory])
    }
    
    
    func handleNotificationReceived(_ response: UNNotificationResponse) async {
        let content = response.notification.request.content
        
        if content.categoryIdentifier == timerActionableIdentifier {
            print("custom timer notification received")
            switch response.actionIdentifier {
            case rescheduleActionIdentifier:
                // remove the reminder timer
                removeAllNotifications()
                // schedule again
                await registerTimeIntervalNotificationWithCustomAction()
                break
                
            case dismissActionIdentifier:
                // remove the reminder timer
                removeAllNotifications()
                break
                
            case UNNotificationDefaultActionIdentifier,
            UNNotificationDismissActionIdentifier:
                break
                
            default:
                break
            }
            
        } else {
            print("other notification: \(content)")
            
        }
        
    }
    
    func willPresentNotification(_ notification: UNNotification) async -> UNNotificationPresentationOptions {
        let content = notification.request.content
        
        if content.categoryIdentifier == timerActionableIdentifier {
            print("custom timer notification received")
            await scheduleReminderTimer()
            
        } else {
            print("other notification: \(content)")
        }
        return [[.badge, .sound, .banner, .list]]

    }
    
    private func scheduleReminderTimer() async {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "1 Seconds pass!"
        content.sound = .default
        content.categoryIdentifier = timerActionableIdentifier

        // reminder notification in 3 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        await registerNotificationRequest(content: content, trigger: trigger)

    }


    func removeAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func registerCalendarNotification() async {
        print("register Calendar Notification")
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "CalendarNotification"
        content.body = "Daily 8:30"
        content.sound = .default
        content.badge = 10
        content.userInfo = ["data": 1]
        
        // condition
        var date = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current)
        date.hour = 8
        date.minute = 46
        // true for recurring event
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        await registerNotificationRequest(content: content, trigger: trigger)

    }
    
    func registerTimeIntervalNotification() async {
        print("register Time Interval Notification")
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "TimeIntervalNotification"
        content.body = "5 Seconds pass!"
        content.sound = .default

        // notification in 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        await registerNotificationRequest(content: content, trigger: trigger)
    }
    
    // custom actionable on Push notification Tapped
    func registerTimeIntervalNotificationWithCustomAction() async {
        print("register Time Interval Notification")
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "TimeIntervalNotification"
        content.body = "1 Seconds pass!"
        content.sound = .default
        content.categoryIdentifier = timerActionableIdentifier

        // notification in 1 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        await registerNotificationRequest(content: content, trigger: trigger)
    }
    
    
    func registerLocationNotification() async {
        let status = manager.authorizationStatus
        if status != .authorizedWhenInUse && status != .authorizedAlways {
            print("not authorized")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "UNLocationNotificationTrigger"
        content.body = "Entering!"
        content.sound = .default
        

        let center = CLLocationCoordinate2D(latitude: 35.6764, longitude: 139.6500)
        let region = CLCircularRegion(center: center, radius: 100000, identifier: "Japan")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        await registerNotificationRequest(content: content, trigger: trigger)

    }
    
    private func registerNotificationRequest(content: UNMutableNotificationContent, trigger: UNNotificationTrigger) async {
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Schedule the request with the system.
        do {
            try await notificationCenter.add(request)
            print("registration succeed for request with identifier \(identifier)")
        } catch(let error) {
            // Handle errors that may occur during add.
            print("error adding request: \(error.localizedDescription)")
        }

    }

}
