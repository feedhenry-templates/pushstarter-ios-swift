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

let NotificationCellIdentifier: String = "NotificationCell"

class ViewController : UITableViewController {
    var messages: [String] = []
    var isRegistered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.registered), name: "success_registered", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.errorRegistration), name: "error_register", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.messageReceived(_:)), name: "message_received", object: nil)
    }
    
    func registered() {
        print("registered")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let msg = defaults.objectForKey("message_received")
        defaults.removeObjectForKey("message_recieved")
        defaults.synchronize()
        
        if (msg != nil) {
            messages.append(msg as! String)
        }
        
        isRegistered = true
        tableView.reloadData()
    }
    
    func errorRegistration() {
        let alert = UIAlertView()
        alert.title = "Registration Error"
        alert.message = "Please verify the provisionioning profile and the UPS details have been setup correctly."
        alert.show()
    }
    
    func messageReceived(notification: NSNotification) {
        print("received")
        
        let obj:AnyObject? = notification.userInfo!["aps"]!["alert"]
        
        // if alert is a flat string
        if let msg = obj as? String {
            messages.append(msg)
        } else {
            // if the alert is a dictionary we need to extract the value of the body key
            let msg = obj!["body"] as! String
            messages.append(msg)
        }
        
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var bgView: UIView? = nil
        
        if (!isRegistered) {
            let progress = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("ProgressViewController")
            bgView = progress?.view
        } else if (messages.isEmpty) {
            let empty = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("EmptyViewController")
            bgView = empty?.view;
        }
        
        if (bgView != nil) {
            self.tableView.backgroundView = bgView
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0;
        }
        
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // if it's the first message in the stream, let's clear the 'empty' placeholder vier
        if (self.tableView.backgroundView != nil) {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .SingleLine
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NotificationCellIdentifier)!
        cell.textLabel?.text = messages[indexPath.row]
        
        return cell
    }
}
