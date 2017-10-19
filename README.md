# pushstarter-ios-swift
[![circle-ci](https://img.shields.io/circleci/project/github/feedhenry-templates/pushstarter-ios-swift/master.svg)](https://circleci.com/gh/feedhenry-templates/pushstarter-ios-swift)


> ObjC version of PushStarter iOS app is available [here](https://github.com/feedhenry-templates/pushstarter-ios-app/).

Author: Corinne Krych  
Level: Intermediate  
Technologies: Swift 4, iOS, RHMAP, CocoaPods.  
Summary: A demonstration of how to include basic push functionality with RHMAP.  
Community Project : [Feed Henry](http://feedhenry.org)  
Target Product: RHMAP  
Product Versions: RHMAP 3.7.0+  
Source: https://github.com/feedhenry-templates/pushstarter-ios-swift  
Prerequisites: fh-ios-swift-sdk: 6+, Xcode: 9+, iOS SDK: iOS 9+, CocoaPods 1.3.0+

## What is it?

The `PushStarter` project demonstrates how to include basic push functionality using [fh-ios-swift-sdk](https://github.com/feedhenry/fh-ios-swift-sdk) and Red Hat Mobile Application Platform. The developer should:

1. enable push notifications in the iOS app within RHMAP
2. enter required certificate
3. send test notification via RHMAP studio Push tab.

The iOS app catches the notifications and displays them as a list.

If you do not have access to a RHMAP instance, you can sign up for a free instance at [https://openshift.feedhenry.com/](https://openshift.feedhenry.com/).

## How do I run it?  

### RHMAP Studio

This application and its cloud services are available as a project template in RHMAP as part of the "Push Notification Hello World" template.

### Local Clone (ideal for Open Source Development)

If you wish to contribute to this template, the following information may be helpful; otherwise, RHMAP and its build facilities are the preferred solution.

## Build instructions

1. Clone this project
1. Populate `PushStarter/fhconfig.plist` with your values as explained [here](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/client_sdk/native-ios-swift).
1. Run `pod install`
1. Open `PushStarter.xcworkspace`
1. Run the project
 
## How does it work?

### FH registers for remote push notification

In `PushStarter/AppDelegate.swift` you register for notification as below:

```Swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    FH.pushRegister(deviceToken: deviceToken, success: { res in // [1]
        print("Unified Push registration successful")
    }, error: {failed in                                        // [2]
        print("Unified Push registration Error \(failed.error)")
    })
}
```

Register FH to receive remote push notification with success [1] and failure [2] callbacks.

### FH receives remote push notification

To receive notification, in `PushStarter/AppDelegate.swift`:

```Swift
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    // When a message is received, send Notification, would be handled by registered ViewController
    let notification:Notification = Notification(name:Notification.Name(rawValue: "message_received"), object:nil, userInfo:userInfo)
    NotificationCenter.default.post(notification)
    print("UPS message received: \(userInfo)")
    
    // Send metrics when app is launched due to push notification
    FH.sendMetricsWhenAppAwoken(applicationState: application.applicationState, userInfo: userInfo)
}
```
### iOS9 and non TLS1.2 backend

If your RHMAP is deployed without TLS1.2 support, open `PushStarter/PushStarter-Info.plist` as source and add the exception lines:

```
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
  </dict>
```
