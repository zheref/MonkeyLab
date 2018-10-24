//
//  UserNotificationsViewController.swift
//  MonkeyLab
//
//  Created by Sergio Daniel L. García on 10/24/18.
//  Copyright © 2018 Sergio Lozano García. All rights reserved.
//

import UIKit
import UserNotifications

class UserNotificationsViewController: UITableViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var permissionCell: UITableViewCell!
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITABLEDELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        switch selectedCell {
        case permissionCell:
            askForPermissionForNotifications()
        default:
            break
        }
    }
    
    private func askForPermissionForNotifications() {
        // https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications
        
        let authorizationOptions: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay, .criticalAlert, .providesAppNotificationSettings, .provisional]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { [unowned self] (granted, error) in
            var message = ""
            
            if granted {
                message = "User notifications for app have been granted permission :)"
            } else {
                message = "User notifications for app have been denied permission :("
            }
            
            let alertController = UIAlertController(title: "User Notifications", message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
