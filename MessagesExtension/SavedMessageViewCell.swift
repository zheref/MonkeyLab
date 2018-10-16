//
//  SavedMessageViewCell.swift
//  MonkeyLab
//
//  Created by Sergio Lozano García on 10/16/18.
//  Copyright © 2018 Sergio Lozano García. All rights reserved.
//

import UIKit

class SavedMessageViewCell: UITableViewCell {
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bubbleView.layer.masksToBounds = false
        bubbleView.layer.cornerRadius = bubbleView.bounds.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
