//
//  AppDelegate.swift
//  LocalNotificationDemo
//
//  Created by Itsuki on 2024/07/13.
//


import SwiftUI
import CoreLocation

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().setBadgeCount(0)
        requestNotificationPerfmission()
        requestLocationPermission()
        return true
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Request user permissions
    func requestNotificationPerfmission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                print("Permission granted: \(granted)")
            }
    }
    
    func requestLocationPermission() {
        CLLocationManager().requestWhenInUseAuthorization()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//        return [[.badge, .sound, .banner, .list]]
        return [[]]

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(response.notification.request.content)
        // title, body, userInfo(data)
    }
    
}
