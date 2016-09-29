/*
 *     Copyright 2016 IBM Corp.
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 */

import UIKit
import BMSCore
import BMSPush
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        let myBMSClient = BMSClient.sharedInstance
         myBMSClient.initialize(bluemixRegion: "APP REGION")
        return true
    }

    func registerForPush () {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            { (granted, error) in
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }        
    }
    
    func unRegisterPush () {
        
        // MARK:  RETRIEVING AVAILABLE SUBSCRIPTIONS
        
        let push =  BMSPushClient.sharedInstance
        
        push.retrieveSubscriptionsWithCompletionHandler { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during retrieving subscribed tags : \(response?.description)")
                
                print( "status code during retrieving subscribed tags : \(statusCode)")
                
                self.sendNotifToDisplayResponse(responseValue: "Response during retrieving subscribed tags: \(response?.description)")
                
                // MARK:  UNSUBSCRIBING TO TAGS
                
                push.unsubscribeFromTags(tagsArray: response!, completionHandler: { (response, statusCode, error) -> Void in
                    
                    if error.isEmpty {
                        
                        print( "Response during unsubscribed tags : \(response?.description)")
                        
                        print( "status code during unsubscribed tags : \(statusCode)")
                        
                        self.sendNotifToDisplayResponse(responseValue: "Response during unsubscribed tags: \(response?.description)")
                        
                        // MARK:  UNSREGISTER DEVICE
                        push.unregisterDevice(completionHandler: { (response, statusCode, error) -> Void in
                            
                            if error.isEmpty {
                                
                                print( "Response during unregistering device : \(response)")
                                
                                print( "status code during unregistering device : \(statusCode)")
                                
                                self.sendNotifToDisplayResponse(responseValue: "Response during unregistering device: \(response)")
                                
                                UIApplication.shared.unregisterForRemoteNotifications()
                            }
                            else{
                                print( "Error during unregistering device \(error) ")
                                
                                self.sendNotifToDisplayResponse( responseValue: "Error during unregistering device \n  - status code: \(statusCode) \n Error :\(error) \n")
                            }
                        })
                    }
                    else {
                        print( "Error during  unsubscribed tags \(error) ")
                        
                        self.sendNotifToDisplayResponse( responseValue: "Error during unsubscribed tags \n  - status code: \(statusCode) \n Error :\(error) \n")
                    }
                })
            }
            else {
                
                print( "Error during retrieving subscribed tags \(error) ")
                
                self.sendNotifToDisplayResponse( responseValue: "Error during retrieving subscribed tags \n  - status code: \(statusCode) \n Error :\(error) \n")
            }
            
        }
        
    }
    
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        var token:String = deviceToken.description
        token = token.replacingOccurrences(of: "<", with: "")
        token = token.replacingOccurrences(of: ">", with: "")
        token = token.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: NSCharacterSet.symbols)
        
        let push =  BMSPushClient.sharedInstance
        push.initializeWithAppGUID(appGUID: "", clientSecret: "")
        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during device registration : \(response)")
                
                print( "status code during device registration : \(statusCode)")
                
                self.sendNotifToDisplayResponse(responseValue: "Response during device registration json: \(response)")
                
                // MARK:    RETRIEVING AVAILABLE TAGS
                
                push.retrieveAvailableTagsWithCompletionHandler(completionHandler: { (response, statusCode, error) -> Void in
                    
                    if error.isEmpty {
                        
                        print( "Response during retrieve tags : \(response)")
                        
                        print( "status code during retrieve tags : \(statusCode)")
                        
                        self.sendNotifToDisplayResponse(responseValue: "Response during retrieve tags: \(response?.description)")
                        
                        // MARK:    SUBSCRIBING TO AVAILABLE TAGS
                        push.subscribeToTags(tagsArray: response!, completionHandler: { (response, statusCode, error) -> Void in
                            
                            if error.isEmpty {
                                
                                print( "Response during Subscribing to tags : \(response?.description)")
                                
                                print( "status code during Subscribing tags : \(statusCode)")
                                
                                self.sendNotifToDisplayResponse(responseValue: "Response during Subscribing tags: \(response?.description)")
                                
                                // MARK:  RETRIEVING AVAILABLE SUBSCRIPTIONS
                                push.retrieveSubscriptionsWithCompletionHandler(completionHandler: { (response, statusCode, error) -> Void in
                                    
                                    if error.isEmpty {
                                        
                                        print( "Response during retrieving subscribed tags : \(response?.description)")
                                        
                                        print( "status code during retrieving subscribed tags : \(statusCode)")
                                        
                                        self.sendNotifToDisplayResponse(responseValue: "Response during retrieving subscribed tags: \(response?.description)")
                                    }
                                    else {
                                        
                                        print( "Error during retrieving subscribed tags \(error) ")
                                        
                                        self.sendNotifToDisplayResponse( responseValue: "Error during retrieving subscribed tags \n  - status code: \(statusCode) \n Error :\(error) \n")
                                    }
                                    
                                })
                                
                            }
                            else {
                                
                                print( "Error during subscribing tags \(error) ")
                                
                                self.sendNotifToDisplayResponse( responseValue: "Error during subscribing tags \n  - status code: \(statusCode) \n Error :\(error) \n")
                            }
                            
                        })
                    }
                    else {
                        print( "Error during retrieve tags \(error) ")
                        
                        self.sendNotifToDisplayResponse( responseValue: "Error during retrieve tags \n  - status code: \(statusCode) \n Error :\(error) \n")
                    }
                    
                    
                })
            }
            else{
                print( "Error during device registration \(error) ")
                
                self.sendNotifToDisplayResponse( responseValue: "Error during device registration \n  - status code: \(statusCode) \n Error :\(error) \n")
            }
        }
    }
    
    //Called if unable to register for APNS.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        let message:NSString = "Error registering for push notifications: \(error.localizedDescription)"
        
        self.showAlert(title: "Registering for notifications", message: message)
        
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! NSString)
        
        self.showAlert(title: "Recieved Push notifications", message: payLoad)
        
    }
    
    func sendNotifToDisplayResponse (responseValue:String){
        
        responseText = responseValue
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "action"), object: self);
    }
    
    
    func showAlert (title:NSString , message:NSString){
        
        // create the alert
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }

}

