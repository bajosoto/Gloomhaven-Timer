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
                   Player(player_class: "doomstalker", player_number: 2),
                   Player(player_class: "mindthief", player_number: 3),
                   Player(player_class: "tinkerer", player_number: 4)]
    
    var effect: UIVisualEffect!
    
    @IBOutlet weak var currInitiativeLabel: UILabel!
    @IBOutlet weak var globalTimer: UILabel!
    
    @IBOutlet var playerBoard: UIView!
    
    @IBOutlet weak var playerButtonArea1: UIView!
    @IBOutlet weak var playerButtonArea2: UIView!
    @IBOutlet weak var playerButtonArea3: UIView!
    @IBOutlet weak var playerButtonArea4: UIView!
    
    @IBOutlet weak var playerButton1: UIButton!
    @IBOutlet weak var playerButton2: UIButton!
    @IBOutlet weak var playerButton3: UIButton!
    @IBOutlet weak var playerButton4: UIButton!
    @IBOutlet var playerButtons: [UIButton]!
    
    @IBOutlet weak var player1ImageView: UIImageView!
    @IBOutlet weak var player2ImageView: UIImageView!
    @IBOutlet weak var player3ImageView: UIImageView!
    @IBOutlet weak var player4ImageView: UIImageView!
    @IBOutlet var playerButtonImages: [UIImageView]!
    
    @IBOutlet weak var invisiBackButton: UIButton!
    
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
    @IBOutlet var npButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Populate player buttons
        playerButtons = [playerButton1,
                         playerButton2,
                         playerButton3,
                         playerButton4]
        
        // Populate player button images
        playerButtonImages = [player1ImageView,
                            player2ImageView,
                            player3ImageView,
                            player4ImageView]
        
        // Populate numpad buttons
        npButtons = [np1, np2, np3, np4, np5, np6, np7, np8, np9, np0]
        
        // Store blur effect
        effect = blurFx.effect
        blurFx.effect = nil
        
        // Store start time and init timer
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
        // Assign image to buttons
        for (i, imageView) in playerButtonImages.enumerated() {
            imageView.image = UIImage(named: players[i].player_class)
        }
        
        // Assign colors to buttons
        for (i, button) in playerButtons.enumerated() {
            button.backgroundColor = players[i].player_color
        }
        
        // Rotate player 1 and 4 buttons upside down
        player1ImageView.transform = playerButton1.transform.rotated(by: CGFloat(Double.pi))
        player4ImageView.transform = playerButton4.transform.rotated(by: CGFloat(Double.pi))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show player board
        showPlayerBoard()
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
    
    @IBAction func invisBackButton(_ sender: Any) {
        players[currInitiativePlayer].player_initiative = -1
        print("Player \(currInitiativePlayer + 1) (\(players[currInitiativePlayer].player_class)) initiative is \(players[currInitiativePlayer].player_initiative)")
        animateNumPadViewOut()
    }
    
    @IBAction func playerButtonPress(_ sender: UIButton) {
        animateNumPadViewIn(player: sender.tag)
        currInitiativePlayer = sender.tag - 1
        currInitiativeOnes = -1
        currInitiativeTens = -1
    }
    
    func showPlayerBoard() {
        playerBoard.isHidden = false
        playerButtonArea1.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        playerButtonArea2.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        playerButtonArea3.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        playerButtonArea4.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        playerButtonArea1.alpha = 0
        playerButtonArea2.alpha = 0
        playerButtonArea3.alpha = 0
        playerButtonArea4.alpha = 0
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0/0.5, relativeDuration: 0.2/0.5, animations: {
                self.playerButtonArea4.transform = CGAffineTransform.identity
                self.playerButtonArea4.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1/0.5, relativeDuration: 0.2/0.5, animations: {
                self.playerButtonArea1.transform = CGAffineTransform.identity
                self.playerButtonArea1.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2/0.5, relativeDuration: 0.2/0.5, animations: {
                self.playerButtonArea3.transform = CGAffineTransform.identity
                self.playerButtonArea3.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3/0.5, relativeDuration: 0.2/0.5, animations: {
                self.playerButtonArea2.transform = CGAffineTransform.identity
                self.playerButtonArea2.alpha = 1
            })
        }, completion:{ _ in
            // Do nothing
        })
//        UIView.animate(withDuration: 0.1) {
//            self.playerButtonArea1.transform = CGAffineTransform.identity
//            self.playerButtonArea1.alpha = 1
//        }
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
        
        self.invisiBackButton.isEnabled = true
        
        // Recolor numpad buttons according to class
        for np in npButtons {
            np.backgroundColor = players[player - 1].player_color
        }
        
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
        
        self.invisiBackButton.isEnabled = false
        
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

