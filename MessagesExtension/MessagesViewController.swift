//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Sergio Lozano García on 10/16/18.
//  Copyright © 2018 Sergio Lozano García. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var newMessageTextField: UITextField!
    @IBOutlet weak var savedMessagesTableView: UITableView!
    
    // MARK: - Stored Properties
    
    var savedMessages: [RecurrentMessage] = [RecurrentMessage(message: "Loading...")]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        readSavedMessages()
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
        
        switch presentationStyle {
        case .expanded:
            newMessageTextField.becomeFirstResponder()
        default:
            newMessageTextField.resignFirstResponder()
        }
    }
    
    private func readSavedMessages() {
        guard let encodedMessages = UserDefaults.standard.value(forKey: "saved-messages") as? [Data] else {
            return
        }
        
        let decodedMessages = encodedMessages.map { (encodedMessage) -> RecurrentMessage in
            if let message = try? PropertyListDecoder().decode(RecurrentMessage.self, from: encodedMessage) {
                return message
            } else {
                print("Retrieving empty recurrent message")
                return RecurrentMessage(message: "")
            }
        }
        
        savedMessages = decodedMessages
    }
    
    private func writeSavedMessages() {
        let encodedMessages = savedMessages.map { (message) -> Data in
            guard let encodedMessage = try? PropertyListEncoder().encode(message) else {
                print("Returning empty data")
                return Data()
            }
            
            return encodedMessage
        }
        
        UserDefaults.standard.set(encodedMessages, forKey: "saved-messages")
    }

}

extension MessagesViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        requestPresentationStyle(.expanded)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
          !text.isEmpty else {
            return
        }
        
        let newMessage = RecurrentMessage(message: text)
        print("Finished editing: \(newMessage.message)")
        
        savedMessages.insert(newMessage, at: 0)
        writeSavedMessages()
        savedMessagesTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newMessageTextField.resignFirstResponder()
        newMessageTextField.text = ""
        
        return true
    }
    
}

extension MessagesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let savedMessage = savedMessages[indexPath.row]
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? SavedMessageViewCell else {
            return SavedMessageViewCell()
        }
        
        let savedMessage = savedMessages[indexPath.row]
        cell.messageLabel.text = savedMessage.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
}
