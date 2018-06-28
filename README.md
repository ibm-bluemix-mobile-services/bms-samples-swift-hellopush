# iOS helloPush Sample Application for IBM Cloud Push Notifications Service 
---
This iOS helloPush sample contains an Swift project that you can use to learn more about the IBM Cloud Push Notification Service.

## Contents

- [Prerequisites](#prerequisites)
- [Create an instance of Bluemix Push Notifications Service](#create-an-instance-of-bluemix-push-notifications-service)
- [Download and setup the sample](#download-and-setup-the-sample)
- [Setup cocoapods or carthage](#setup-cocoapods-or-carthage)
  - [Cocoa Pods](#cocoa-pods)
- [Modify the options code in the sample](#modify-the-options-code-in-the-sample)
- [Run the sample app](#run-the-sample-app)
- [Samples and videos](#samples-and-videos)


### Prerequisites

* iOS 8.0+
* Xcode 9.3 (9E145)
* Swift 4.1

Before you start, make sure you have the following:

- A [IBM Cloud](http://bluemix.net) account.
- APNs enabled push certificate (.p12 file) and the certificate password . For information about how to obtain a p.12 certificate, see the [configuring credentials for a notification provider](https://www.ng.bluemix.net/docs/services/mobilepush/index.html#push_provider) section in the Push documentation.

### Create an instance of IBM Cloud Push Notifications Service
- Create an instance of IBM Cloud Push Notifications Service and [configure](https://console.ng.bluemix.net/docs/services/mobilepush/t_push_provider_ios.html) it .

### Download and setup the sample
- Clone the sample from Github with the following command:

    ```
      git clone https://github.com/ibm-bluemix-mobile-services/bms-samples-swift-hellopush.git
    ```

#### Setup cocoapods or carthage

Navigate to the `HelloPush` folder and do the following,

##### Cocoa Pods

1. If the CocoapPods client is not installed, install it using the following command: `sudo gem install Cocoapods`
2. If the CocoaPods repository is not configured, configure it using the following command: `pod setup`
3. Run the `pod install` command to download and install the required dependencies.
4. Open the Xcode workspace: `HelloPush.xcworkspace` . From now on, open the xcworkspace file since it contains all the dependencies and configuration.
5. Open the `BMSPushRegister.swift` and add the IBM Cloud push notification service credentials

```
let cloudRegion = BMSClient.Region.usSouth
let pushAppGUID = "27ee87ce-ed4c-4167-XXXX-XXXXXXX"
let pushClientSecret = "813a430f-XXXXX-XXXXXX-b8e0-XXXXXXXXX"
let userId = "ananth"
let customeDeviceId = "DavidmobiledeviceId"
let pushVariables = ["username":"David","accountNumber":"3564758697057869"]

```


### Modify the options code in the sample

Check the `getPushOptions()` method in `BMSPushRegister.swift` and add the options you need.


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
