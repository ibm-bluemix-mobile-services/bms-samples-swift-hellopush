//
//  BMSPushRegister.swift
//  HelloPush
//
//  Created by Anantha Krishnan K G on 28/06/18.
//  Copyright © 2018 Ananth. All rights reserved.
//

import Foundation
import UIKit
import BMSCore
import BMSPush


 // Add IBM Cloud Push notification service credentials
let myBMSClient = BMSClient.sharedInstance
let push =  BMSPushClient.sharedInstance
let cloudRegion = BMSClient.Region.usSouth
let pushAppGUID = "push service appguid"
let pushClientSecret = "push service client secret"
let userId = "ananth"
let customeDeviceId = "12345"
let pushVariables = ["username":"ananth","accountNumber":"3564758697057869"]

var tagsArray:[String] = []

extension PushViewController : BMSPushObserver {
      
    func getPushOptions() -> BMSPushClientOptions{
        let actionOne = BMSPushNotificationAction(identifierName: "FIRST", buttonTitle: "Accept", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let actionTwo = BMSPushNotificationAction(identifierName: "SECOND", buttonTitle: "Reject", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let actionThree = BMSPushNotificationAction(identifierName: "Third", buttonTitle: "Delete", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let actionFour = BMSPushNotificationAction(identifierName: "Fourth", buttonTitle: "View", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let actionFive = BMSPushNotificationAction(identifierName: "Fifth", buttonTitle: "Later", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let category = BMSPushNotificationActionCategory(identifierName: "category", buttonActions: [actionOne, actionTwo])
        let categorySecond = BMSPushNotificationActionCategory(identifierName: "category1", buttonActions: [actionOne, actionTwo])
        let categoryThird = BMSPushNotificationActionCategory(identifierName: "category2", buttonActions: [actionOne, actionTwo,actionThree,actionFour,actionFive])
        
        let notifOptions = BMSPushClientOptions()
        notifOptions.setDeviceId(deviceId: customeDeviceId)
        
        notifOptions.setPushVariables(pushVariables: pushVariables)
        notifOptions.setInteractiveNotificationCategories(categoryName: [category,categorySecond,categoryThird])
        
        return notifOptions
    }
    
     func initializePush() {
        
        let alert = UIAlertController(title: "Let Us Send You Push Notifications?", message: "We'll only notify you of content that's interesting and relevant to YOU.",preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Yes, Please", style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async(execute: {
                self.registerBMSPush()
            })
        })
        let cancel = UIAlertAction(title: "No, Thanks", style: .destructive, handler: { (action) -> Void in
            DispatchQueue.main.async(execute: {
                self.pushSwitch.setOn(false, animated: true)
                self.pushLabel.text = "Enable Push Notifications"
                let alert = BMSPushModal(title: "Initialization Error!", message:"user permission Error")
                alert.show(animated: true)
                self.enableButtons(enableButton: false)
            })
        })
        alert.addAction(cancel)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func registerBMSPush()  {
        
        // Initialize BMSCore SDK
        myBMSClient.initialize(bluemixRegion: cloudRegion)
        //Initialize BMSPush SDK
        
        let pushNotificationOptions = getPushOptions()
        push.initializeWithAppGUID(appGUID: pushAppGUID, clientSecret: pushClientSecret , options: pushNotificationOptions)
        push.delegate = self
    }
    
    static func registerPushToken(deviceToken: Data) {
        
        if userId.isEmpty  {
            push.registerWithDeviceToken(deviceToken: deviceToken) { (response, status, error) in
                DispatchQueue.main.async(execute: {
                    if error.isEmpty {
                        let alert = BMSPushModal(title: "Register Success!", message:response!)
                        alert.show(animated: true)
                        NotificationCenter.default.post(name: .postRegisterCallback, object: nil, userInfo: ["enable":true])
                        
                    } else {
                        let alert = BMSPushModal(title: "Register Error!", message:error)
                        alert.show(animated: true)
                        NotificationCenter.default.post(name: .postRegisterCallback, object: nil, userInfo: ["enable":false])
                    }
                })
            }
        } else {
            push.registerWithDeviceToken(deviceToken: deviceToken, WithUserId: userId) { (response, status, error) in
                DispatchQueue.main.async(execute: {
                    if error.isEmpty {
                        let alert = BMSPushModal(title: "Register Success!", message:response!)
                        alert.show(animated: true)
                        NotificationCenter.default.post(name: .postRegisterCallback, object: nil, userInfo: ["enable":true])
                    } else {
                        let alert = BMSPushModal(title: "Register Error!", message:error)
                        alert.show(animated: true)
                        NotificationCenter.default.post(name: .postRegisterCallback, object: nil, userInfo: ["enable":false])
                    }
                })
            }
            
        }
    }
    
    static func didReciveNotification(userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        push.didReciveBMSPushNotification(userInfo: userInfo) { (response, error) in
            
            DispatchQueue.main.async(execute: {})
            completionHandler(.noData)
        }
        
    }
    
    func unRegisterPush() {
        push.unregisterDevice { (response, status, error) in
            
            DispatchQueue.main.async(execute: {
                if error.isEmpty {
                    self.enableButtons(enableButton: false)
                    self.callAlert(title: "Unregister Success!", message:response!)
                } else {
                    self.enableButtons(enableButton: true)
                    self.callAlert(title: "Unregister Error!", message:error)
                }
            })
        }
        
    }
    
    @objc func getTags() {
        
        push.retrieveAvailableTagsWithCompletionHandler { (arrayList, status, error) in
            if error.isEmpty {
                if (arrayList?.count)! > 0 {
                    tagsArray = arrayList as! [String]
                    let tags = arrayList?.componentsJoined(by: ", ")
                    self.callAlert(title: "Retrive Tags Success!", message:tags!)
                } else {
                    self.callAlert(title: "Retrive Tags Error!", message:"Create New tags in IBM Cloud Push service dashabord before calling this API")
                }
            } else {
                self.callAlert(title: "Retrive Tags Error!", message:error)
            }
            
        }
    }
    
    @objc func getSubscription() {
        
        push.retrieveSubscriptionsWithCompletionHandler { (subscriptionArray, status, error) in
            
            if error.isEmpty {
                if (subscriptionArray?.count)! > 0 {
                    let tags = subscriptionArray?.componentsJoined(by: ", ")
                    self.callAlert(title: "Retrive Subscription Success!", message:tags!)
                } else {
                    self.callAlert(title: "Retrive Subscription Error!", message:"Subscribe Atleast one tag before calling this API")
                }
            } else {
                self.callAlert(title: "Retrive Subscription Error!", message:error)
            }
        }
    }
    
     @objc func subscribeTag() {
        
        if tagsArray.count > 0 {
            push.subscribeToTags(tagsArray: tagsArray as NSArray) { (response, status, error) in
                
                if error.isEmpty {
                    let subscriptionsArray =   response?.value(forKey: "subscriptions") as! [[String:Any]]
                    let subscriptionExistsArray =  response?.value(forKey: "subscriptionExists") as! [[String:Any]]
                    var listsArray = subscriptionsArray
                    if subscriptionsArray.isEmpty {
                        listsArray = subscriptionExistsArray
                    }
                   
                    var tagNames = "Subscribed tags Are: \n "
                    for listArray in listsArray as! [[String: String]]{
                        tagNames.append(listArray["tagName"]!)
                        tagNames.append(", ")
                       
                    }
                    //let listArray = listsArray[0] as! NSDictionary
                    self.callAlert(title: "Subscribe to Tag Success!", message: tagNames)
                } else {
                    self.callAlert(title: "Subscribe to Tag Error!", message:error)
                }
            }
        } else {
            self.callAlert(title: "UnSubscribe from Tag Error!", message:"Empty tags Array. Call the get tags first")
        }
        
    }
        
     @objc func unSubscribeTag() {
        
        if tagsArray.count > 0 {
            push.unsubscribeFromTags(tagsArray: tagsArray as NSArray) { (response, status, error) in
                if error.isEmpty {
                    self.callAlert(title: "UnSubscribe from Tag Success!", message:"Successfully removed subscriptions")
                    tagsArray = []
                    
                } else {
                    self.callAlert(title: "UnSubscribe from Tag Error!", message:error)
                }
            }
        } else {
            self.callAlert(title: "UnSubscribe from Tag Error!", message: "Empty tag array. Call the get tags first!")
        }
        
    }
    
    public func onChangePermission(status: Bool) {
        if !status {
            DispatchQueue.main.async(execute: {
                let alert = BMSPushModal(title: "Initialization Error!", message:"Initilisation error")
                alert.show(animated: true)
                self.enableButtons(enableButton: false)
            })
        }
    }
    
    private func callAlert(title:String, message:String){
        DispatchQueue.main.async(execute: {
            let alert = BMSPushModal(title: title, message:message)
            alert.show(animated: true)
        })
    }
    
    
    public func enableButtons(enableButton: Bool) {
        let buttonList = [tagButton, subscribeButton, unSubscribeButton, getSubscriptionButton]
        var color = "008dcd"
        var shouldEnable = true
        if !enableButton {
            color = "8a8a92"
            shouldEnable = false
            self.pushLabel.text = "Enbale Push Notifications"
        } else {
            self.pushLabel.text = "Disable Push Notifications"
        }
        pushSwitch.setOn(enableButton, animated: true)
        
        for button in buttonList {
            button.backgroundColor = UIColor().colorFromHex(hexColor: color)
            button.isEnabled = shouldEnable
        }
    }
    
}


