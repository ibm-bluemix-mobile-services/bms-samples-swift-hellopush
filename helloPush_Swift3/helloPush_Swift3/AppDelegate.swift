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
        /*
        // MARK:    RETRIEVING AVAILABLE TAGS
        
        push.retrieveAvailableTagsWithCompletionHandler(completionHandler: { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                
                print( "Response during retrieve tags : \(String(describing: response))")
                
                print( "status code during retrieve tags : \(String(describing: statusCode))")
                
                self.sendNotifToDisplayResponse(responseValue: "Response during retrieve tags: \(String(describing: response?.description))")
                
                // MARK:    SUBSCRIBING TO AVAILABLE TAGS
                push.subscribeToTags(tagsArray: response!, completionHandler: { (response, statusCode, error) -> Void in
                    
                    if error.isEmpty {
                        
                        print( "Response during Subscribing to tags : \(String(describing: response?.description))")
                        
                        print( "status code during Subscribing tags : \(String(describing: statusCode))")
                        
                        self.sendNotifToDisplayResponse(responseValue: "Response during Subscribing tags: \(String(describing: response?.description))")
                        
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
            
            
        })*/
    }
    
    //Called if unable to register for APNS.
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

