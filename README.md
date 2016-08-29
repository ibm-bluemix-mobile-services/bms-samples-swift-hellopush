# iOS helloPush Sample Application for Bluemix Mobile Services
---
This iOS helloPush sample contains an Swift project that you can use to learn more about the IBM Push Notification Service.

### Requirements

* iOS 8.0+
* Xcode 7.3, 8.0 beta 4, 8.0 beta 5
* Swift 2.2 - 3.0

Use the following steps to configure the helloPush sample for Swift:

1. [Download the helloPush sample](#download-the-hellopush-sample)
2. [Configure the mobile backend for your helloPush application](#configure-the-mobile-backend-for-your-hellopush-application)
3. [Configure the front end in the helloPush sample](#configure-the-front-end-in-the-hellopush-sample)
4. [Run the iOS app](#run-the-ios-app)
5. [Send Analytics data to push monitoring dashboard](#send-data-to-push-monitoring-dashboard-using-analytics-sdk)


### Before you begin
Before you start, make sure you have the following:

- A [Bluemix](http://bluemix.net) account.
- APNs enabled push certificate (.p12 file) and the certificate password for your sandbox environment. For information about how to obtain a p.12 certificate, see the [configuring credentials for a notification provider](https://www.ng.bluemix.net/docs/services/mobilepush/index.html#push_provider) section in the Push documentation.

### Download the helloPush sample
Clone the sample from Github with the following command:

```
   git clone https://github.com/ibm-bluemix-mobile-services/bms-samples-swift-hellopush.git
```

### Configure the mobile backend for your helloPush application

Before you can run the helloPush application, you must set up an app on Bluemix.  The following procedure shows you how to create a MobileFirst Services Starter application. A Node.js runtime environment is created so that you can provide server-side functions, such as resource URIs and static files. The Cloudant®NoSQL DB, IBM Push Notifications, and Mobile Client Access services are then added to the app.

Create a mobile backend in the  Bluemix dashboard:

1.	In the **Boilerplates** section of the Bluemix catalog, click **MobileFirst Services Starter**.
2.	Enter a name and host for your mobile backend and click **Create**.
3.	Click **Finish**.

Configure Push Notification service:

1.	In the IBM Push Notifications Dashboard, go to the **Configuration** tab to configure your Push Notification Service.  
2.  In the Apple Push Certificate section, select the Sandbox environment
3.  Upload a valid APNs enabled push certificate (.p12 file), then enter the password associated with the certificate.

### Configure the front end in the helloPush sample

Navigate to the `helloPush_swift` folder for `Swift2.3 or Older Version of Swift` and to `helloPush_Swift3` folder for `Swift3` and do the following,

#### Cocoa Pods:

1. If the CocoapPods client is not installed, install it using the following command: `sudo gem install Cocoapods`
2. If the CocoaPods repository is not configured, configure it using the following command: `pod setup`
3. Run the `pod install` command to download and install the required dependencies.
4. Open the Xcode workspace: `open TestPush.xcworkspace` (swift 2.3 ) or `helloPush_Swift3.xcworkspace` (Swift3). From now on, open the xcworkspace file since it contains all the dependencies and configuration.
5. Open the `AppDelegate.swift` and add the corresponding **APPROUTE** ,
**APPGUID** and **APPREGION** in the application `didFinishLaunchingWithOptions` method:


#### Carthage :

To install BMSPush using Carthage, add it to your Cartfile:

```
   github "ibm-bluemix-mobile-services/bms-clientsdk-swift-push"
```
>**Note**: Carthage currently is not supported for BMSPush in Xcode 8 beta. Please use Cocoapods instead.

Then run the `carthage update` command. Once the build is finished, drag `BMSPush.framework`, `BMSCore.framework` and `BMSAnalyticsAPI.framework` into your Xcode project.

#### Setup initialization
```
let myBMSClient = BMSClient.sharedInstance

//Swift3

myBMSClient.initializeWithBluemixAppRoute(bluemixAppRoute: "https://example.mybluemix.net", bluemixAppGUID: "1234", bluemixRegion: "Location where your app Hosted")

//Swift 2.3 or Older

myBMSClient.initializeWithBluemixAppRoute("bluemixAppRoute", bluemixAppGUID: "APPGUID", bluemixRegion:"Location where your app Hosted")

myBMSClient.defaultRequestTimeout = 10.0 // Timput in seconds

```

After registering APNs, pass the device token to the Bluemix push registration API.

```
func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){

   let push =  BMSPushClient.sharedInstance
   push.initializeWithAppGUID(appGUID: "your pushAppGUID")
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
   push.initializeWithAppGUID("pushAppGUID")
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

### Run the iOS app
For push notifications to work successfully, you must run the helloPush sample on a physical iOS device. You will also need a valid APNs enabled bundle id, provisioning profile, and development certificate.

When you run the application, you will see a single view application with a "Register for Push" button. When you click this button the application will attempt to register the device and application to the Push Notification Service. The app uses an alert to display the registration status (successful or failed).

When a push notification is received and the application is in the foreground, an alert is displayed showing the notification's content. The application uses the **ApplicationRoute** and **ApplicationID** specified in the AppDelegate to connect to the IBM Push Notification Service on Bluemix. The registration status and other information is displayed  in the Xcode Console


>**Note:** This application runs on the latest version of XCode (7.0). The application has been updated to set Enable Bitcode to No in the build-settings as a workaround for the these settings introduced in iOS 9. For more info please see the following blog entry:

[Connect Your iOS 9 App to Bluemix](https://developer.ibm.com/bluemix/2015/09/16/connect-your-ios-9-app-to-bluemix/)

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
