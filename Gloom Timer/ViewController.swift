//
//  ViewController.swift
//  Gloom Timer
//
//  Created by Sergio Soto on 3/11/19.
//  Copyright © 2019 Sergio Soto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    
    var currInitiativeOnes: Int = -1
    var currInitiativeTens: Int = -1
    var currInitiativePlayer: Int = -1
    
    var players = [Player(player_class: "brute", player_number: 1),
                   Player(player_class: "doom", player_number: 2),
                   Player(player_class: "mind", player_number: 3),
                   Player(player_class: "tink", player_number: 4)]
    
    var effect: UIVisualEffect!
    
    let colors: [String: UIColor] = ["tink": UIColor(red: 90/255, green: 69/255, blue: 50/255, alpha: 1.0),
                                    "brute": UIColor(red: 30/255, green: 60/255, blue: 100/255, alpha: 1.0),
                                    "mind": UIColor(red: 68/255, green: 88/255, blue: 126/255, alpha: 1.0),
                                    "doom": UIColor(red: 45/255, green: 105/255, blue: 123/255, alpha: 1.0)]
    
    @IBOutlet weak var currInitiativeLabel: UILabel!
    @IBOutlet weak var globalTimer: UILabel!
    
    @IBOutlet weak var tinkererButton: UIButton!
    @IBOutlet weak var bruteButton: UIButton!
    @IBOutlet weak var mindthiefButton: UIButton!
    @IBOutlet weak var doomButton: UIButton!
    
    @IBOutlet weak var player4ImageView: UIImageView!
    @IBOutlet weak var player1ImageView: UIImageView!
    @IBOutlet weak var player3ImageView: UIImageView!
    @IBOutlet weak var player2ImageView: UIImageView!
    
    
    @IBOutlet var PopupView: UIView!
    @IBOutlet weak var blurFx: UIVisualEffectView!
    
    @IBOutlet weak var np1: UIButton!
    @IBOutlet weak var np2: UIButton!
    @IBOutlet weak var np3: UIButton!
    @IBOutlet weak var np4: UIButton!
    @IBOutlet weak var np5: UIButton!
    @IBOutlet weak var np6: UIButton!
    @IBOutlet weak var np7: UIButton!
    @IBOutlet weak var np8: UIButton!
    @IBOutlet weak var np9: UIButton!
    @IBOutlet weak var np0: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Store blur effect
        effect = blurFx.effect
        blurFx.effect = nil
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        player4ImageView.transform = tinkererButton.transform.rotated(by: CGFloat(Double.pi))
        player1ImageView.transform = bruteButton.transform.rotated(by: CGFloat(Double.pi))
    }

    @IBAction func numPadButtonPress(_ sender: UIButton) {
        switch sender.tag {
            case 1: fallthrough
            case 2: fallthrough
            case 3: fallthrough
            case 4: fallthrough
            case 5: fallthrough
            case 6: fallthrough
            case 7: fallthrough
            case 8: fallthrough
            case 9: fallthrough
            case 0:
                if (currInitiativeOnes != -1) {
                    currInitiativeTens = currInitiativeOnes
                }
                currInitiativeOnes = sender.tag
            case 99:
                currInitiativeOnes = 9
                currInitiativeTens = 9
            default: return
        }
        
        let ones = currInitiativeOnes == -1 ? "-" : String(currInitiativeOnes)
        let tens = currInitiativeTens == -1 ? "-" : String(currInitiativeTens)
        currInitiativeLabel.text = "\(tens)\(ones)"
        
        if ((currInitiativeOnes != -1) && (currInitiativeTens != -1)) {
            // Close window
            animateNumPadViewOut()
            // Assign initiative to player
            players[currInitiativePlayer].player_initiative = currInitiativeTens * 10 + currInitiativeOnes
            // Reset interface
            currInitiativeOnes = -1
            currInitiativeTens = -1
            print("Player \(currInitiativePlayer + 1) (\(players[currInitiativePlayer].player_class)) initiative is \(players[currInitiativePlayer].player_initiative)")
        }
    }
    
    @IBAction func playerButtonPress(_ sender: UIButton) {
        animateNumPadViewIn(player: sender.tag)
        currInitiativePlayer = sender.tag - 1
    }
    
    func animateNumPadViewIn(player: Int) {
        var t_in = CGAffineTransform.identity
        t_in = t_in.scaledBy(x: 1.3, y: 1.3)
        
        var t_out = CGAffineTransform.identity
        t_out = t_out.scaledBy(x: 1, y: 1)

        if (player == 1 || player == 4) {
            t_in = t_in.rotated(by: CGFloat(Double.pi))
            t_out = t_out.rotated(by: CGFloat(Double.pi))
        }
        
        var charClass: String
        switch player {
        case 1:
            charClass = "brute"
        case 2:
            charClass = "doom"
        case 3:
            charClass = "mind"
        case 4:
            charClass = "tink"
        default:
            charClass = "mind"
        }
        
        np1.backgroundColor = colors[charClass]
        np2.backgroundColor = colors[charClass]
        np3.backgroundColor = colors[charClass]
        np4.backgroundColor = colors[charClass]
        np5.backgroundColor = colors[charClass]
        np6.backgroundColor = colors[charClass]
        np7.backgroundColor = colors[charClass]
        np8.backgroundColor = colors[charClass]
        np9.backgroundColor = colors[charClass]
        np0.backgroundColor = colors[charClass]
        
        self.view.addSubview(PopupView)
        PopupView.center = self.view.center
        PopupView.transform = t_in
        PopupView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.blurFx.effect = self.effect
            self.PopupView.alpha = 1
            self.PopupView.transform = t_out
        }
    }
    
    func animateNumPadViewOut() {
        var t_out = PopupView.transform
        t_out = t_out.scaledBy(x: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.PopupView.transform = t_out
            self.PopupView.alpha = 0
            self.blurFx.effect = nil
        }) { (success:Bool) in
            self.currInitiativeLabel.text = "--"
            self.PopupView.removeFromSuperview()
        }
    }
    
    @objc func UpdateTimer() {
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate hours
        let hours = UInt8(time / 3600.0)
        time -= (TimeInterval(hours) * 60)
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        globalTimer.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

