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
import FeedHenry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FH.pushEnabledForRemoteNotification(application: application)
        FH.sendMetricsWhenAppLaunched(launchOptions: launchOptions)

        // Display all push messages (even the message used to open the app)
        if let options = launchOptions {
            if let option = options[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: Any] {
                print("Was opened with notification:\(option)")
                let defaults: UserDefaults = UserDefaults.standard;
                // Send a message received signal to display the notification in the table.
                defaults.set(self.pushMessageContent(option), forKey: "message_received")
                defaults.synchronize()

            }
        }

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FH.pushRegister(deviceToken: deviceToken, success: { res in
            let notification = NSNotification(name: NSNotification.Name(rawValue: "success_registered"), object: nil)
            NotificationCenter.default.post(notification as Notification)
            print("Unified Push registration successful")
        }, error: {failed in
            let notification = NSNotification(name: NSNotification.Name(rawValue: "error_register"), object: nil)
            NotificationCenter.default.post(notification as Notification)
            print("Unified Push registration Error \(failed.error)")
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let notification:Notification = Notification(name:Notification.Name(rawValue: "error_register"), object:nil, userInfo:nil)
        NotificationCenter.default.post(notification)
        print("Unified Push registration Error \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // When a message is received, send NSNotification, would be handled by registered ViewController
        let notification:Notification = Notification(name:Notification.Name(rawValue: "message_received"), object:nil, userInfo:userInfo)
        NotificationCenter.default.post(notification)
        print("UPS message received: \(userInfo)")
        
        // Send metrics when app is launched due to push notification
        FH.sendMetricsWhenAppAwoken(applicationState: application.applicationState, userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // When a message is received, send Notification, would be handled by registered ViewController
        let notification:Notification = Notification(name: Notification.Name(rawValue: "message_received"), object:nil, userInfo:userInfo)
        NotificationCenter.default.post(notification)
        print("UPS message received: \(userInfo)")

        // Send metrics when app is launched due to push notification
        FH.sendMetricsWhenAppAwoken(applicationState: application.applicationState, userInfo: userInfo)

        // No additioanl data to fetch
        fetchCompletionHandler(UIBackgroundFetchResult.noData)
    }

    func pushMessageContent(_ userInfo: [AnyHashable: Any]) -> String {
        var content: String = ""
        if let aps = userInfo["aps"] as? [String: Any] {
            if let alert = aps["alert"] as? String {
                content = alert
            } else {
                if let alert = aps["alert"] as? [String: Any] {
                    let msg = alert["body"]
                    content = msg as! String
                }
            }
        }

        return content
    }
}
