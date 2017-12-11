//
//  AppDelegate.swift
//  hellopush
//
//  Created by Anantha Krishnan K G on 11/12/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import BMSCore
import BMSPush
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0;
        return true
    }
    func registerForPush () {
        
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.usSouth)
        let push =  BMSPushClient.sharedInstance
        
        push.initializeWithAppGUID(appGUID: "appGUID", clientSecret:"ClientSecret")
        
    }
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        let push =  BMSPushClient.sharedInstance
        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(String(describing: response))")
                
                print( "status code during device registration : \(String(describing: statusCode))")
                let responseJson = self.convertStringToDictionary(text: response!)! as NSDictionary
                let userId = responseJson.value(forKey: "userId")
                
                self.sendNotifToDisplayResponse(responseValue: "Device Registered Successfully with User ID \(String(describing: userId!))", responseBool: true)
            }
            else{
                print( "Error during device registration \(error) ")
                
                self.sendNotifToDisplayResponse( responseValue: "Error during device registration \n  - status code: \(String(describing: statusCode)) \n Error :\(error) \n", responseBool: false)
            }
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        let message:String = "Error registering for push notifications: \(error.localizedDescription)"
        
        self.showAlert(title: "Registering for notifications", message: message)
        
        
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! String)
        
        self.showAlert(title: "Recieved Push notifications", message: payLoad)
        
    }
    
    func sendNotifToDisplayResponse (responseValue:String, responseBool: Bool){
        
        responseText = responseValue
        isSuccess = responseBool
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "action"), object: self);
    }

    func showAlert (title:String , message:String){
        
        // create the alert
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] else {
                return [:]
            }
            return result
        }
        return [:]
    }
    
    func unRegisterPush () {
        
        // MARK:  RETRIEVING AVAILABLE SUBSCRIPTIONS
        
        let push =  BMSPushClient.sharedInstance
        
        push.retrieveSubscriptionsWithCompletionHandler { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during retrieving subscribed tags : \(String(describing: response?.description))")
                
                print( "status code during retrieving subscribed tags : \(String(describing: statusCode))")
                
                // MARK:  UNSUBSCRIBING TO TAGS
                
                push.unsubscribeFromTags(tagsArray: response!, completionHandler: { (response, statusCode, error) -> Void in
                    
                    if error.isEmpty {
                        
                        print( "Response during unsubscribed tags : \(String(describing: response?.description))")
                        
                        print( "status code during unsubscribed tags : \(String(describing: statusCode))")
                        
                        // MARK:  UNSREGISTER DEVICE
                        push.unregisterDevice(completionHandler: { (response, statusCode, error) -> Void in
                            
                            if error.isEmpty {
                                
                                print( "Response during unregistering device : \(String(describing: response))")
                                
                                print( "status code during unregistering device : \(String(describing: statusCode))")
                                
                                UIApplication.shared.unregisterForRemoteNotifications()
                            }
                            else{
                                print( "Error during unregistering device \(error) ")
                            }
                        })
                    }
                    else {
                        print( "Error during  unsubscribed tags \(error) ")
                    }
                })
            }
            else {
                
                print( "Error during retrieving subscribed tags \(error) ")
            }
            
        }
        
    }


}

