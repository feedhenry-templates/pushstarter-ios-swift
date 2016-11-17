# pushstarter-ios-swift [![Build Status](https://travis-ci.org/feedhenry-templates/pushstarter-ios-swift.png)](https://travis-ci.org/feedhenry-templates/pushstarter-ios-swift)

> ObjC version of PushStarter iOS app is available [here](https://github.com/feedhenry-templates/pushstarter-ios-app/).

> ObjC/Cocoapods of PushStarter iOS app is available [here](https://github.com/feedhenry-templates/pushstarter-ios-app/tree/cocoapods).

Author: Corinne Krych   
Level: Intermediate  
Technologies: Swift 3, iOS, RHMAP, CocoaPods.  
Summary: A demonstration of how to include basic push functionality with RHMAP.Community Project : [Feed Henry](http://feedhenry.org)
Target Product: RHMAP  
Product Versions: RHMAP 3.7.0+   
Source: https://github.com/feedhenry-templates/pushstarter-ios-app  
Prerequisites: fh-ios-swift-sdk : 5+, Xcode : 8+, iOS SDK : iOS8+, CocoaPods 1.1.0+

## What is it?

The ```PushStarter``` project demonstrates how to include basic push functionality using [fh-ios-sdk](https://github.com/feedhenry/fh-ios-sdk) and Red Hat Mobile Application Platform. The developer should:
- enable push notifications in the iOS app within RHMAP, 
- enter required certificate,
- send test notification via RHMAP studio Push tab.
The iOS app catches the notification and displays them as a list.

If you do not have access to a RHMAP instance, you can sign up for a free instance at [https://openshift.feedhenry.com/](https://openshift.feedhenry.com/).

## How do I run it?  

### RHMAP Studio

This application and its cloud services are available as a project template in RHMAP as part of the "Push Notification Hello World" template.

### Local Clone (ideal for Open Source Development)

If you wish to contribute to this template, the following information may be helpful; otherwise, RHMAP and its build facilities are the preferred solution.

## Build instructions

1. Clone this project

2. Populate ```PushStarter/fhconfig.plist``` with your values as explained [here](http://docs.feedhenry.com/v3/dev_tools/sdks/ios.html#ios-configure).

3. Run ```pod install```

4. Open PushStarter.xcworkspace

4. Run the project
 
## How does it work?

### FH registers for remote push notification

In ```PushStarter/AppDelegate.swift``` you register for notification as below:

```Swift
func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
  FH.pushRegister(deviceToken, success: { res in // [1]
    let notification = NSNotification(name: "sucess_registered", object: nil)
    NSNotificationCenter.defaultCenter().postNotification(notification)
    print("Unified Push registration successful")
  }, failure: {failed in                         // [2]
    let notification = NSNotification(name: "error_register", object: nil)
    NSNotificationCenter.defaultCenter().postNotification(notification)
    print("Unified Push registration Error \(failed.error)")
  })
}
```
Register FH to receive remote push notification with success [1] and failure [2] callbacks.

### FH receives remote push notification

To receive notification, in ```PushStarter/AppDelegate.swift```:

```Swift
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
  print("UPS message received: \(userInfo)")
}
```
### iOS9 and non TLS1.2 backend

If your RHMAP is depoyed without TLS1.2 support, open as source  ```PushStarter/PushStarter-Info.plist``` add the exception lines:

```
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
  </dict>
```
