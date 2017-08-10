# iOS helloPush Sample Application for Bluemix Mobile Services
---
This iOS helloPush sample contains an Swift project that you can use to learn more about the IBM Push Notification Service.

## Contents

- [Prerequisites](#prerequisites)
- [Create an instance of Bluemix Push Notifications Service](#create-an-instance-of-bluemix-push-notifications-service)
- [Download and setup the sample](#download-and-setup-the-sample)
- [Setup cocoapods or carthage](#setup-cocoapods-or-carthage)
  - [Cocoa Pods](#cocoa-pods)
  - [Carthage](#carthage)
- [Modify the initialization code in the sample](#modify-the-initialization-code-in-the-sample)
- [Register http End point](#register-httpend-point)
- [Run the sample app](#run-the-sample-app)
- [Samples and videos](#samples-and-videos)


### Prerequisites

* iOS 8.0+
* Xcode 7.3, 8.+
* Swift 2.2 - 3.+

Before you start, make sure you have the following:

- A [Bluemix](http://bluemix.net) account.
- APNs enabled push certificate (.p12 file) and the certificate password . For information about how to obtain a p.12 certificate, see the [configuring credentials for a notification provider](https://www.ng.bluemix.net/docs/services/mobilepush/index.html#push_provider) section in the Push documentation.

### Create an instance of Bluemix Push Notifications Service
- Create an instance of  Bluemix Push Notifications Service and [configure](https://console.ng.bluemix.net/docs/services/mobilepush/t_push_provider_ios.html) it .

### Download and setup the sample
- Clone the sample from Github with the following command:

    ```
      git clone https://github.com/ibm-bluemix-mobile-services/bms-samples-swift-hellopush.git
    ```

#### Setup cocoapods or carthage

Navigate to the `helloPush_swift` folder for `Swift2.3 or Older Version of Swift` and to `helloPush_Swift3` folder for `Swift3` and do the following,

##### Cocoa Pods

1. If the CocoapPods client is not installed, install it using the following command: `sudo gem install Cocoapods`
2. If the CocoaPods repository is not configured, configure it using the following command: `pod setup`
3. Run the `pod install` command to download and install the required dependencies.
4. Open the Xcode workspace: `open TestPush.xcworkspace` (swift 2.3 ) or `helloPush_Swift3.xcworkspace` (Swift3). From now on, open the xcworkspace file since it contains all the dependencies and configuration.
5. Open the `AppDelegate.swift` and add the corresponding **APPREGION** in the application `didFinishLaunchingWithOptions` method:


##### Carthage

To install BMSPush using Carthage, add it to your Cartfile:

  ```
     github "ibm-bluemix-mobile-services/bms-clientsdk-swift-push"
  ```
>**Note**: Carthage currently is not supported for BMSPush in Xcode 8 beta. Please use Cocoapods instead.

Then run the `carthage update` command. Once the build is finished, drag `BMSPush.framework`, `BMSCore.framework` and `BMSAnalyticsAPI.framework` into your Xcode project.

### Modify the initialization code in the sample

```
let myBMSClient = BMSClient.sharedInstance

//Swift3

myBMSClient.initialize(bluemixRegion: "Location where your app Hosted")

//Swift 2.3 or Older

myBMSClient.initialize(bluemixRegion: "Location where your app Hosted")


```

After registering with APNs, pass the device token to the Bluemix push registration API. Follow docs in [BMSPush SDK](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-push)

```
func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){

   let push =  BMSPushClient.sharedInstance
   push.initializeWithAppGUID(appGUID: "your Push App GUID", clientSecret: "your Push App client secret")
   push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
    if error.isEmpty {
      print( "Response during device registration : \(response)")
      print( "status code during device registration : \(statusCode)")
    } else{
      print( "Error during device registration \(error) ")
      Print( "Error during device registration \n  - status code: \(statusCode) \n Error :\(error) \n")
    }  
 }


 //Swift2.3 and Older

 func application (application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){

   let push =  BMSPushClient.sharedInstance
   push.initializeWithAppGUID(appGUID: "your Push App GUID", clientSecret: "your Push App client secret")
   push.registerWithDeviceToken(deviceToken) { (response, statusCode, error) -> Void in
        if error.isEmpty {
            print( "Response during device registration : \(response)")
            print( "status code during device registration : \(statusCode)")
        }else{
            print( "Error during device registration \(error) ")
            Print( "Error during device registration \n  - status code: \(statusCode) \n Error :\(error) \n")
        }
    }
}
```

### Run the sample app
For push notifications to work successfully, you must run the helloPush sample on a physical iOS device. You will also need a valid APNs enabled bundle id, provisioning profile, and development certificate.

When you run the application, you will see a single view application with a "Register for Push" Switch. When you click this switch the application will attempt to register the device and application to the Push Notification Service. The app uses an text view to display the registration status (successful or failed).

Now, switch over to the Bluemix Push Notifications service and open the service dashboard.  Navigate to 'Send Notifications' and send a notification.  You could either send a broadcast notification or a notification targeted to iOS platform so that a notification is sent to the helloPush Swift application.  When a push notification is received and the application is in the foreground, an alert is displayed showing the notification's content.

>**Note:** This application runs on the latest version of XCode (7.0). The application has been updated to set Enable Bitcode to No in the build-settings as a workaround for the these settings introduced in iOS 9. For more info please see the following blog entry:

[Connect Your iOS 9 App to Bluemix](https://developer.ibm.com/bluemix/2015/09/16/connect-your-ios-9-app-to-bluemix/)


### Samples and videos

* Please visit for samples - [Github Sample](https://github.com/ibm-bluemix-mobile-services/bms-samples-swift-hellopush)

* Video Tutorials Available here - [Bluemix Push Notifications](https://www.youtube.com/channel/UCRr2Wou-z91fD6QOYtZiHGA)

=======================
Copyright 2016 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
