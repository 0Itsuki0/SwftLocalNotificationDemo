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

    func removePendingNotifications() {
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
