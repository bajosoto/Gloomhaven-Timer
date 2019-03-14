//
//  Player.swift
//  Gloom Timer
//
//  Created by Sergio Soto on 3/13/19.
//  Copyright © 2019 Sergio Soto. All rights reserved.
//

import Foundation
import UIKit

class Player {
    var player_class : String
    var player_number : Int
    var player_initiative : Int = -1
    var player_icon : UIImageView
    
    init (player_class : String, player_number : Int) {
        self.player_class = player_class
        self.player_number = player_number
        self.player_icon = UIImageView()
        self.player_icon.image = UIImage(named: player_class)
    }
}
