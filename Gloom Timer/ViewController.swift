//
//  ViewController.swift
//  Gloom Timer
//
//  Created by Sergio Soto on 3/11/19.
//  Copyright © 2019 Sergio Soto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    weak var timer: Timer?
    var timeStart: Double = 0
    var timeCharSelStart: Double = 0
    var timeCharSelEnd: Double = 0
    var timeScenarioSetupStart: Double = 0
    var timeScenarioSetupEnd: Double = 0
    
    var currInitiativeOnes: Int = -1
    var currInitiativeTens: Int = -1
    var currInitiativePlayer: Int = -1
    
    var currPlayerSelection: Int = 0
    var players: [Player] = []
//                    = [Player(player_class: "brute", player_number: 1),
//                   Player(player_class: "doomstalker", player_number: 2),
//                   Player(player_class: "mindthief", player_number: 3),
//                   Player(player_class: "tinkerer", player_number: 4)]
    
    var effect: UIVisualEffect!
    
    @IBOutlet weak var currInitiativeLabel: UILabel!
    @IBOutlet weak var globalTimer: UILabel!
    
    @IBOutlet var playerBoard: UIView!
    
    @IBOutlet weak var scenarioSetupImg: UIImageView!
    @IBOutlet weak var scenarioSetupLabel: UILabel!
    @IBOutlet weak var scenarioSetupDoneButton: UIButton!
    
    @IBOutlet weak var playerButtonArea1: UIView!
    @IBOutlet weak var playerButtonArea2: UIView!
    @IBOutlet weak var playerButtonArea3: UIView!
    @IBOutlet weak var playerButtonArea4: UIView!
    @IBOutlet var playerButtonAreas: [UIView]!
    
    @IBOutlet var classButtons: [UIButton]!
    @IBOutlet var classButtonViews: [UIView]!
    
    @IBOutlet weak var playerButton1: UIButton!
    @IBOutlet weak var playerButton2: UIButton!
    @IBOutlet weak var playerButton3: UIButton!
    @IBOutlet weak var playerButton4: UIButton!
    @IBOutlet var playerButtons: [UIButton]!
    
    @IBOutlet weak var playerNameTextField: UITextField!
    
    @IBOutlet weak var player1ImageView: UIImageView!
    @IBOutlet weak var player2ImageView: UIImageView!
    @IBOutlet weak var player3ImageView: UIImageView!
    @IBOutlet weak var player4ImageView: UIImageView!
    @IBOutlet var playerButtonImages: [UIImageView]!
    
    @IBOutlet weak var invisiBackButton: UIButton!
    
    @IBOutlet var PopupView: UIView!
    @IBOutlet var playerSelectionView: UIView!
    @IBOutlet var scenarioSetupView: UIView!
    
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
        
        // Populate Player Button Areas
        playerButtonAreas = [playerButtonArea1, playerButtonArea2, playerButtonArea3, playerButtonArea4]
        
        // Store blur effect
        effect = blurFx.effect
        blurFx.effect = nil
        
        // Store start time and init timer
        timeStart = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
        // Rotate player 1 and 4 buttons upside down
        player1ImageView.transform = playerButton1.transform.rotated(by: CGFloat(Double.pi))
        player4ImageView.transform = playerButton4.transform.rotated(by: CGFloat(Double.pi))
        
        // Set color of class buttons
        for button in classButtons {
            button.backgroundColor = getColor(name: classes[button.tag])
        }
        
        // Set delegate for text field
        self.playerNameTextField.delegate = self
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show class selection
        showClassSelection()
    }
    
    // End editing when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playerNameTextField.resignFirstResponder()
        return true
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
    
    @IBAction func classSelectionPressed(_ sender: UIButton) {
        players.append(Player(player_class: classes[sender.tag], player_number: currPlayerSelection, player_name: playerNameTextField.text!))
        print("Created player \(currPlayerSelection + 1): \(classes[sender.tag])")
        currPlayerSelection += 1
        
        // Find button view (from button pressed) in order to disable
        var buttView: UIView?
        for classButtonView in self.classButtonViews {
            if (classButtonView.tag) == sender.tag {
                buttView = classButtonView
            }
        }
        // Disable button
        UIView.animate(withDuration: 0.4) {
            buttView!.alpha = 0.3
        }
        sender.isEnabled = false
        
        // Animate Text out
        UIView.animate(withDuration: 0.2) {
            self.playerNameTextField.alpha = 0
        }
        
        if(currPlayerSelection == 4) {
            // Assign image to buttons
            for (i, imageView) in playerButtonImages.enumerated() {
                imageView.image = UIImage(named: players[i].player_class)
            }
            // Assign colors to buttons
            for (i, button) in playerButtons.enumerated() {
                button.backgroundColor = players[i].player_color
            }
            // Go to player board
            hideClassSelection()
        } else {
            // BEGIN BBB Exclusive:
            var nextName: String
            switch (currPlayerSelection) {
                case 1: nextName = "Gaby"
                case 2: nextName = "Sergio"
                case 3: nextName = "Gui"
                default: nextName = "Player \(currPlayerSelection + 1)"
            }
            playerNameTextField.text = nextName
            // END BBB Exclusive
            
            // Non-BBB Version
//            playerNameTextField.text = "Player \(currPlayerSelection + 1)"
            
            // Animate Text In
            UIView.animate(withDuration: 0.2) {
                self.playerNameTextField.alpha = 1
            }
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
    
    @IBAction func scenarioSetupPressed(_ sender: Any) {
        hideScenarioSetup()
    }
    
    func showClassSelection() {
        self.view.superview!.addSubview(playerSelectionView)
        
        // Store time
        timeCharSelStart = getTimeNow()
        
        // Pre-scale buttons for animation
        for classButtonView in classButtonViews {
            classButtonView.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
            classButtonView.alpha = 0
        }
        playerNameTextField.alpha = 0
        
        // Show main window
        playerSelectionView.center = self.view.center
        playerSelectionView.transform = CGAffineTransform.identity
        playerSelectionView.alpha = 1
        
        // Animate buttons
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0/18, relativeDuration: 1/3, animations: {
                self.playerNameTextField.alpha = 1
            })
            for i in 0...16 {
                var buttView: UIView?
                for classButtonView in self.classButtonViews {
                    if (classButtonView.tag) == i {
                        buttView = classButtonView
                    }
                }
                UIView.addKeyframe(withRelativeStartTime: Double(i + 1)/18, relativeDuration: 1/3, animations: {
                    buttView!.transform = CGAffineTransform.identity
                    buttView!.alpha = 1
                })
            }
        })
    }
    
    func hideClassSelection() {
        // Animate buttons
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            for i in 0...16 {
                var buttView: UIView?
                for classButtonView in self.classButtonViews {
                    if (classButtonView.tag) == i {
                        buttView = classButtonView
                    }
                }
                UIView.addKeyframe(withRelativeStartTime: Double(i + 1)/17, relativeDuration: 1/3, animations: {
                    buttView!.transform = CGAffineTransform.identity
                    buttView!.alpha = 0
                })
            }
        }, completion:{ _ in
            self.timeCharSelEnd = self.getTimeNow()
            self.playerSelectionView.removeFromSuperview()
            self.showScenarioSetup()
        })
    }
    
    func showScenarioSetup() {
        self.view.superview!.addSubview(scenarioSetupView)
        
        // Store time
        timeScenarioSetupStart = getTimeNow()
        
        scenarioSetupLabel.alpha = 0
        scenarioSetupImg.alpha = 0
        scenarioSetupDoneButton.alpha = 0
        
        // Show main window
        scenarioSetupView.center = self.view.center
        scenarioSetupView.transform = CGAffineTransform.identity
        scenarioSetupView.alpha = 1
        
        scenarioSetupImg.rotate360Degrees()
        
        // Animate buttons
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0/5, relativeDuration: 1/3, animations: {
                self.scenarioSetupLabel.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/3, animations: {
                self.scenarioSetupImg.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/3, animations: {
                self.scenarioSetupDoneButton.alpha = 1
            })
        })
    }
    
    func hideScenarioSetup() {
        // Animate buttons
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0/5, relativeDuration: 1/3, animations: {
                self.scenarioSetupLabel.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/3, animations: {
                self.scenarioSetupImg.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/3, animations: {
                self.scenarioSetupDoneButton.alpha = 0
            })
        }, completion: { _ in
            self.timeScenarioSetupEnd = self.getTimeNow()
            self.scenarioSetupView.removeFromSuperview()
            self.scenarioSetupImg.layer.removeAllAnimations()
            self.showPlayerBoard()
        })
    }
    
    func showPlayerBoard() {
        playerBoard.isHidden = false
        
        for playerButtonArea in playerButtonAreas {
            playerButtonArea.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
            playerButtonArea.alpha = 0
        }
        
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
    
    func getTimeNow() -> Double {
        return Date().timeIntervalSinceReferenceDate
    }
    
    @objc func UpdateTimer() {
        var time: Double = 0
        
        // Calculate total time since timer started in seconds
        time = getTimeNow() - timeStart
        
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

