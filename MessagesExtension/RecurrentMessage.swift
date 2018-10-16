//
//  RecurrentMessage.swift
//  MonkeyLab
//
//  Created by Sergio Lozano García on 10/11/18.
//  Copyright © 2018 Sergio Lozano García. All rights reserved.
//

import Foundation

struct RecurrentMessage : Codable
{
    var message: String
    var timesUsed: Int = 0
    var lastTimeUsed: Date?
    
    init(message: String) {
        self.message = message
    }
}
