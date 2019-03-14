//
//  Player.swift
//  Gloom Timer
//
//  Created by Sergio Soto on 3/13/19.
//  Copyright © 2019 Sergio Soto. All rights reserved.
//

import Foundation
import UIKit

let colors: [String: UIColor] = ["tinkerer": UIColor(red: 90/255, green: 69/255, blue: 50/255, alpha: 1.0),
                                 "brute": UIColor(red: 30/255, green: 60/255, blue: 100/255, alpha: 1.0),
                                 "mindthief": UIColor(red: 68/255, green: 88/255, blue: 126/255, alpha: 1.0),
                                 "doomstalker": UIColor(red: 45/255, green: 105/255, blue: 123/255, alpha: 1.0),
                                 "unassigned": UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)]

class Player {
    var player_class : String
    var player_number : Int
    var player_initiative : Int = -1
    var player_icon : UIImageView
    var player_color : UIColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
    
    init (player_class : String, player_number : Int) {
        self.player_class = player_class
        self.player_number = player_number
        self.player_icon = UIImageView()
        self.player_icon.image = UIImage(named: player_class)
        self.player_color = colors[player_class]!
    }
}
