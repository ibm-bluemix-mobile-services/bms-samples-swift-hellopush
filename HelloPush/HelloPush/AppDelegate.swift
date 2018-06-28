//
//  AppDelegate.swift
//  HelloPush
//
//  Created by Anantha Krishnan K G on 28/06/18.
//  Copyright © 2018 Ananth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let pushViewController = PushViewController()
        
        window?.rootViewController = UINavigationController(rootViewController: pushViewController)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushViewController.registerPushToken(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        PushViewController.didReciveNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler)
    }


}

