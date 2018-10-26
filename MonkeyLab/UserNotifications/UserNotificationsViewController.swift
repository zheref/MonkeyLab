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
    @IBOutlet weak var provisionalPermissionCell: UITableViewCell!
    
    @IBOutlet weak var alertAuthorizationCell: UITableViewCell!
    @IBOutlet weak var soundAuthorizationCell: UITableViewCell!
    @IBOutlet weak var badgeAuthorizationCell: UITableViewCell!
    @IBOutlet weak var carPlayAuthorizationCell: UITableViewCell!
    @IBOutlet weak var criticalAlertAuthorizationCell: UITableViewCell!
    @IBOutlet weak var inAppSettingsAuthorizationCell: UITableViewCell!
    @IBOutlet weak var provisionalAuthorizationCell: UITableViewCell!
    
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUIForCurrentPermissionStatus()
        
        super.viewDidAppear(animated)
    }
    
    // MARK: - UITABLEDELEGATE
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        switch selectedCell {
        case permissionCell:
            askForPermissionForNotifications()
        case provisionalPermissionCell:
            askForProvisionalPermission()
        default:
            break
        }
    }
    
    private func updateUIForCurrentPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [unowned self] (settings) in
            DispatchQueue.main.async {
                self.alertAuthorizationCell.detailTextLabel?.text = self.translateSetting(setting: settings.alertSetting)
                self.soundAuthorizationCell.detailTextLabel?.text = self.translateSetting(setting: settings.soundSetting)
                self.badgeAuthorizationCell.detailTextLabel?.text = self.translateSetting(setting: settings.badgeSetting)
                self.carPlayAuthorizationCell.detailTextLabel?.text = self.translateSetting(setting: settings.carPlaySetting)
                self.criticalAlertAuthorizationCell.detailTextLabel?.text = self.translateSetting(setting: settings.criticalAlertSetting)
                self.inAppSettingsAuthorizationCell.detailTextLabel?.text = String(settings.providesAppNotificationSettings)
                self.provisionalAuthorizationCell.detailTextLabel?.text = "??"
            }
        }
    }
    
    private func translateSetting(setting: UNNotificationSetting) -> String {
        switch setting {
        case .disabled:
            return "Disabled"
        case .enabled:
            return "Enabled"
        case .notSupported:
            return "Not Supported"
        default:
            return "WTF!"
        }
    }
    
    private func askForPermissionForNotifications() {
        // https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications
        
        let authorizationOptions: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay, .criticalAlert, .providesAppNotificationSettings]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { [unowned self] (granted, error) in
            DispatchQueue.main.async {
                var message = ""
                
                if granted {
                    message = "User notifications for app have been granted permission :)"
                } else {
                    message = "User notifications for app have been denied permission :("
                }
                
                let alertController = UIAlertController(title: "User Notifications", message: message, preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] _ in
                    self.updateUIForCurrentPermissionStatus()
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func askForProvisionalPermission() {
        // https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications
        
        let authorizationOptions: UNAuthorizationOptions = [.provisional]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { [unowned self] (granted, error) in
            DispatchQueue.main.async {
                var message = ""
                
                if granted {
                    message = "User notifications now has provisional permissions (quiet notifications)"
                }
                
                let alertController = UIAlertController(title: "User Notifications", message: message, preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] _ in
                    self.updateUIForCurrentPermissionStatus()
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

}
