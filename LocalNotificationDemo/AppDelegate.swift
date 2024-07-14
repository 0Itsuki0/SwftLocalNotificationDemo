//
//  AppDelegate.swift
//  LocalNotificationDemo
//
//  Created by Itsuki on 2024/07/13.
//


import SwiftUI
import CoreLocation

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let notificationManager = NotificationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().setBadgeCount(0)
        notificationManager.requestNotificationPermission()
        requestLocationPermission()
        notificationManager.declareCustomTimerActionable()
        return true
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func requestLocationPermission() {
        CLLocationManager().requestWhenInUseAuthorization()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        print("will present")
        return await notificationManager.willPresentNotification(notification)

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("did receive")
        await notificationManager.handleNotificationReceived(response)
    }
    
}
