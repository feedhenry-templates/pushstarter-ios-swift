/*
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import FH

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        FH.pushEnabledForRemoteNotification(application)
        FH.sendMetricsWhenAppLaunched(launchOptions)
        
        if launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] != nil {
            if launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]?.isKindOfClass(NSDictionary) != nil {
                print("Was opened with notification:\(launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey])")
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.pushMessageContent((launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey])! as! [NSObject : AnyObject]), forKey: "message_received")
                defaults.synchronize()
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        FH.pushRegister(deviceToken, andSuccess: { res in
            let notification = NSNotification(name: "sucess_registered", object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
            print("Unified Push registration successful")
        }, andFailure: {failed in
            let notification = NSNotification(name: "error_register", object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
            print("Unified Push registration Error \(failed.error)")
        })
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        let notification:NSNotification = NSNotification(name:"error_register", object:nil, userInfo:nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        print("Unified Push registration Error \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        // When a message is received, send NSNotification, would be handled by registered ViewController
        let notification:NSNotification = NSNotification(name:"message_received", object:nil, userInfo:userInfo)
        NSNotificationCenter.defaultCenter().postNotification(notification)
        print("UPS message received: \(userInfo)")
        
        // Send metrics when app is launched due to push notification
        FH.sendMetricsWhenAppAwoken(application.applicationState, userInfo: userInfo)
    }
    
    func pushMessageContent(userInfo: [NSObject : AnyObject]) -> String {
        var content: String
        if let alert = userInfo["aps"]!["alert"]! as? String {
            content = alert
        }
        else {
            content = (userInfo["aps"]!["alert"] as! Dictionary)["body"]!
        }
        return content
    }
}