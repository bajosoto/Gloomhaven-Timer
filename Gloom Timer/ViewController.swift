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
    var timeCharSelTotal: Double = 0
    var timeScenarioSetupStart: Double = 0
    var timeScenarioSetupTotal: Double = 0
    var timeCityStart: Double = 0
    var timeCityTotal: Double = 0
    var timeInitiativeStart: Double = 0
    var timeInitiativeTotal: [Double] = [0, 0, 0, 0]
    var timeInitiativeTemp: [Double] = [0, 0, 0, 0]
    var timeInitiativeCombined: Double = 0
    var timeScreenInitiativeStart: Double = 0
    var timeScreenInitiativeEnd: Double = 0
    var timeBreakStart: Double = 0
    var timeBreakTotal: Double = 0
    var breakEnded: Bool = false
    var timeTurnStart: Double = 0
    var timeTurnTotal: [Double] = [0, 0, 0, 0, 0]
    var lastTurnFrom: Int = -1
    
    var currInitiativeOnes: Int = -1
    var currInitiativeTens: Int = -1
    var currInitiativePlayer: Int = -1
    
    var currPlayerSelection: Int = 0
    var players: [Player] = []
    
    var effect: UIVisualEffect!
    
    @IBOutlet weak var currInitiativeLabel: UILabel!
    @IBOutlet weak var globalTimer: UILabel!
    
    @IBOutlet var playerBoard: UIView!
    
    @IBOutlet var scenarioSetupView: UIView!
    @IBOutlet weak var scenarioSetupImg: UIImageView!
    @IBOutlet weak var scenarioSetupLabel: UILabel!
    @IBOutlet weak var scenarioSetupDoneButton: UIButton!
    
    @IBOutlet var cityEventsView: UIView!
    @IBOutlet weak var cityDoneButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityImg: UIImageView!
    
    @IBOutlet var initiativeView: UIView!
    @IBOutlet var initiativePlayerBackgrounds: [UIView]!
    @IBOutlet var initiativeNumberLabels: [UILabel]!
    @IBOutlet var initiativeImages: [UIImageView]!
    @IBOutlet var initiativeNames: [UILabel]!
    @IBOutlet weak var initiativeBtnOutlet: UIButton!
    var initiativeOrder = [0, 1, 2, 3]

    @IBOutlet var turnsView: UIView!
    @IBOutlet weak var turnsIcon: UIView!
    @IBOutlet weak var turnsImg: UIImageView!
    @IBOutlet weak var turnButton1View: UIView!
    @IBOutlet weak var turnButton1Img: UIImageView!
    @IBOutlet weak var turnButton1Text: UILabel!
    @IBOutlet weak var turnButton2Img: UIImageView!
    @IBOutlet weak var turnButton2Text: UILabel!
    @IBOutlet weak var turnButton2View: UIView!
    var currTurn: Int = 0
    var monsterActive: Bool = true
    
    @IBOutlet weak var playerButtonArea1: UIView!
    @IBOutlet weak var playerButtonArea2: UIView!
    @IBOutlet weak var playerButtonArea3: UIView!
    @IBOutlet weak var playerButtonArea4: UIView!
    @IBOutlet var playerButtonAreas: [UIView]!
    
    @IBOutlet var classButtons: [UIButton]!
    @IBOutlet var classButtonViews: [UIView]!
    
    @IBOutlet weak var exitButtonArea: UIView!
    @IBOutlet weak var exitButton: UIButton!
    
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
    @IBOutlet weak var tempInvisiBackButton: UIButton!
    
    @IBOutlet var resultsView: UIView!
    @IBOutlet weak var resultsText: UITextView!
    
    @IBOutlet var PopupView: UIView!
    @IBOutlet var playerSelectionView: UIView!
    
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
    
    override var prefersStatusBarHidden: Bool {
        return true
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
                updateInitiativeLabel()
            case 99:
                currInitiativeOnes = 9
                currInitiativeTens = 9
                updateInitiativeLabel()
            // OK Button
            case 10:
                saveInitiative()
            default: return
        }
        
        
        
    }
    
    func updateInitiativeLabel() {
        let ones = currInitiativeOnes == -1 ? "-" : String(currInitiativeOnes)
        let tens = currInitiativeTens == -1 ? "-" : String(currInitiativeTens)
        currInitiativeLabel.text = "\(tens)\(ones)"
    }
    
    func saveInitiative() {
        if ((currInitiativeOnes != -1) && (currInitiativeTens != -1)) {
            // Assign initiative to player
            players[currInitiativePlayer].player_initiative = currInitiativeTens * 10 + currInitiativeOnes
            // Reset interface
            currInitiativeOnes = -1
            currInitiativeTens = -1
            
            // Store temporal time
            timeInitiativeTemp[currInitiativePlayer] = getTimeNow() - timeInitiativeStart
            print("Player \(currInitiativePlayer + 1) (\(players[currInitiativePlayer].player_class)) initiative is now \(players[currInitiativePlayer].player_initiative)")
            
            // Disable player button
            switch (currInitiativePlayer) {
            case 0:
                playerButton1.isEnabled = false
                playerButton1.superview!.alpha = 0.2
            case 1:
                playerButton2.isEnabled = false
                playerButton2.superview!.alpha = 0.2
            case 2:
                playerButton3.isEnabled = false
                playerButton3.superview!.alpha = 0.2
            case 3:
                playerButton4.isEnabled = false
                playerButton4.superview!.alpha = 0.2
            default:
                print("Why are we here?")
            }
            
            
            // Close window
            animateNumPadViewOut()
            
            
            // Validate if all players have initiative
            var allDone = true
            for i in 0...3 {
                if (players[i].player_initiative == -1){
                    allDone = false
                    break
                }
            }
            if (allDone) {
                // Save initiative times
                for i in 0...3 {
                    timeInitiativeTotal[i] += timeInitiativeTemp[i]
                    print("Player \(i + 1) (\(players[i].player_class)) initiative time is now \(timeInitiativeTotal[i])")
                }
                calcTimeElapsed(since: timeInitiativeStart, store: &timeInitiativeCombined, str: "Cumulative Initiative")
                getInitiativeOrder()
                print("The order is:")
                for i in 0...3 {
                    print("\(i): \(players[initiativeOrder[i]].player_name) (\(players[initiativeOrder[i]].player_initiative))")
                }
                hidePlayerBoard()
            }
        } else {
            
        }
    }
    
    func getInitiativeOrder() {
        for i in 0...3 {
            var lowest = 100
            for j in i...3 {
                let initiative = players[initiativeOrder[j]].player_initiative
                if (initiative < lowest) {
                    let tmp = initiativeOrder[i]
                    initiativeOrder[i] = initiativeOrder[j]
                    initiativeOrder[j] = tmp
                    lowest = players[initiativeOrder[i]].player_initiative
                }
            }
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
    
    @IBAction func tempInvisiBackPressed(_ sender: Any) {
        // Temporary
        var t_out = resultsView.transform
        t_out = t_out.scaledBy(x: 1.3, y: 1.3)

        self.tempInvisiBackButton.isEnabled = false

        UIView.animate(withDuration: 0.2, animations: {
            self.resultsView.transform = t_out
            self.resultsView.alpha = 0
            self.blurFx.effect = nil
        }) { (success:Bool) in
            self.resultsView.removeFromSuperview()
        }
    }
    
    @IBAction func invisBackButton(_ sender: Any) {
//        players[currInitiativePlayer].player_initiative = -1
        print("Player \(currInitiativePlayer + 1) (\(players[currInitiativePlayer].player_class)) initiative is \(players[currInitiativePlayer].player_initiative)")
        animateNumPadViewOut()
    }
    
    @IBAction func playerButtonPress(_ sender: UIButton) {
        animateNumPadViewIn(player: sender.tag)
        currInitiativePlayer = sender.tag - 1
        currInitiativeOnes = -1
        currInitiativeTens = -1
        
//        // Disable player button
//        sender.isEnabled = false
//        sender.superview!.alpha = 0.2
    }
    
    @IBAction func scenarioSetupPressed(_ sender: Any) {
        hideScenarioSetup()
    }
    
    @IBAction func cityPressed(_ sender: Any) {
        hideCityEvents()
    }
    
    @IBAction func initiativeViewDonePressed(_ sender: Any) {
        hideInitiativeView()
    }
    
    @IBAction func turnButtonPressed(_ sender: UIButton) {
        
        if (breakEnded == false){
            breakEnded = true
            calcTimeElapsed(since: timeBreakStart, store: &timeBreakTotal, str: "Break")
        }
        
        if (lastTurnFrom != -1) {
            if( lastTurnFrom == 4){
                calcTimeElapsed(since: timeTurnStart, store: &timeTurnTotal[lastTurnFrom], str: "Monster turn")
            } else {
                calcTimeElapsed(since: timeTurnStart, store: &timeTurnTotal[lastTurnFrom], str: "Player \(lastTurnFrom + 1)")
            }
            
        }
        timeTurnStart = getTimeNow()
        
        switch (sender.tag){
        case 0: // Monster button
            UIView.animate(withDuration: 0.2, animations: {
                self.turnsIcon.alpha = 0
            }) { (_) in
                self.animateTurnButtonViewOut(turn: -1)
                self.turnsImg.image = UIImage(named: "monster")
                self.turnsIcon.backgroundColor = colors["monster"]
                UIView.animate(withDuration: 0.2, animations: {
                    self.turnsIcon.alpha = 1
                }) { (_) in
                    // Store monster as last turn for time keeping
                    self.lastTurnFrom = 4
                }
            }
        case 1: // Player / end round button
            UIView.animate(withDuration: 0.2, animations: {
                self.turnsIcon.alpha = 0
            }) { (_) in
                if (self.currTurn == 4){
                    self.animateTurnButtonViewOut(turn: self.currTurn)
                } else {
                    self.turnsImg.image = self.players[self.initiativeOrder[self.currTurn]].player_icon.image
                    self.turnsIcon.backgroundColor = self.players[self.initiativeOrder[self.currTurn]].player_color
                    UIView.animate(withDuration: 0.2, animations: {
                        self.turnsIcon.alpha = 1
                    }) { (_) in
                        // Store current (e.g. last) turn for time keeping
                        if(self.currTurn < 4) {
                            self.lastTurnFrom = self.initiativeOrder[self.currTurn]
                        }
                        self.animateTurnButtonViewOut(turn: self.currTurn)
                        self.currTurn += 1
                    }
                }
            }
        default:
            // Do nothing. Shouldn't reach this
            break
        }
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        
        resultsText.text = """
        Total time: \t\t\t\t\t\t\t\(getTidyTime(timeIn: getTimeNow() - timeStart))
        
        Character selection: \t\t\t\t\(getTidyTime(timeIn: timeCharSelTotal))
        Scenario setup: \t\t\t\t\t\(getTidyTime(timeIn: timeScenarioSetupTotal))
        City and Road events: \t\t\t\(getTidyTime(timeIn: timeCityTotal))
        PC app handling: \t\t\t\t\t\(getTidyTime(timeIn: timeScreenInitiativeEnd))
        
        Total card selection: \t\t\t\t\(getTidyTime(timeIn: timeInitiativeTotal[0] + timeInitiativeTotal[1] + timeInitiativeTotal[2] + timeInitiativeTotal[3]))
        \(players[0].player_name)'s card selection: \t\t\t\(getTidyTime(timeIn: timeInitiativeTotal[0]))
        \(players[1].player_name)'s card selection: \t\t\t\(getTidyTime(timeIn: timeInitiativeTotal[1]))
        \(players[2].player_name)'s card selection: \t\t\(getTidyTime(timeIn: timeInitiativeTotal[2]))
        \(players[3].player_name)'s card selection: \t\t\t\t\(getTidyTime(timeIn: timeInitiativeTotal[3]))
        
        Break/Discussion/'Oh fuck': \t\(getTidyTime(timeIn: timeBreakTotal))
        
        Total turn time: \t\t\t\t\t\(getTidyTime(timeIn: timeTurnTotal[0] + timeTurnTotal[1] + timeTurnTotal[2] + timeTurnTotal[3] + timeTurnTotal[4]))
        \(players[0].player_name)'s turn time: \t\t\t\t\t\(getTidyTime(timeIn: timeTurnTotal[0]))
        \(players[1].player_name)'s turn time: \t\t\t\t\t\(getTidyTime(timeIn: timeTurnTotal[1]))
        \(players[2].player_name)'s turn time: \t\t\t\t\(getTidyTime(timeIn: timeTurnTotal[2]))
        \(players[3].player_name)'s turn time: \t\t\t\t\t\(getTidyTime(timeIn: timeTurnTotal[3]))
        Monsters turn time: \t\t\t\t\(getTidyTime(timeIn: timeTurnTotal[4]))
        """
        
        // All this is temporary
        var t_in = CGAffineTransform.identity
        t_in = t_in.scaledBy(x: 1.3, y: 1.3)
        
        var t_out = CGAffineTransform.identity
        t_out = t_out.scaledBy(x: 1, y: 1)
        
        self.tempInvisiBackButton.isEnabled = true
        
        self.view.addSubview(resultsView)
        resultsView.center = self.view.center
        resultsView.transform = t_in
        resultsView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.blurFx.effect = self.effect
            self.resultsView.alpha = 1
            self.resultsView.transform = t_out
        }
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
            self.calcTimeElapsed(since: self.timeCharSelStart, store: &self.timeCharSelTotal, str: "Class selection")
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
            self.calcTimeElapsed(since: self.timeScenarioSetupStart, store: &self.timeScenarioSetupTotal, str: "Scenario setup")
            self.scenarioSetupView.removeFromSuperview()
            self.scenarioSetupImg.layer.removeAllAnimations()
            self.showCityEvents()
        })
    }
    
    func showCityEvents() {
        self.view.superview!.addSubview(cityEventsView)
        
        // Store time
        timeCityStart = getTimeNow()
        
        cityLabel.alpha = 0
        cityImg.alpha = 0
        cityDoneButton.alpha = 0
        
        // Show main window
        cityEventsView.center = self.view.center
        cityEventsView.transform = CGAffineTransform.identity
        cityEventsView.alpha = 1
        
//        scenarioSetupImg.rotate360Degrees()
        
        // Animate buttons
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0/5, relativeDuration: 1/3, animations: {
                self.cityLabel.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/3, animations: {
                self.cityImg.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/3, animations: {
                self.cityDoneButton.alpha = 1
            })
        })
    }
    
    func hideCityEvents() {
        // Animate buttons
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0/5, relativeDuration: 1/3, animations: {
                self.cityLabel.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/3, animations: {
                self.cityImg.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/3, animations: {
                self.cityDoneButton.alpha = 0
            })
        }, completion: { _ in
            self.calcTimeElapsed(since: self.timeCityStart, store: &self.timeCityTotal, str: "City/Road events")
            self.cityEventsView.removeFromSuperview()
//            self.cityImg.layer.removeAllAnimations()
            self.showPlayerBoard()
        })
    }
    
    func showInitiativeView() {
        self.view.superview!.addSubview(initiativeView)
        timeScreenInitiativeStart = getTimeNow()
        
        // Pre-translate frames for animation
        for frame in initiativePlayerBackgrounds {
            frame.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -30)
            frame.alpha = 0
        }
        
        for i in 0...3 {
            // Set frame color
            var frame: UIView?
            for frameView in self.initiativePlayerBackgrounds {
                if (frameView.tag) == i {
                    frame = frameView
                }
            }
            frame?.backgroundColor = players[initiativeOrder[i]].player_color
            // Set alpha 0  and translation for animation
            frame!.alpha = 0
            frame!.transform = CGAffineTransform.identity.translatedBy(x: 50, y: 0)
            
            // Set frame text
            var textIndex: UILabel?
            for name in self.initiativeNames {
                if (name.tag) == i {
                    textIndex = name
                }
            }
            textIndex?.text = players[initiativeOrder[i]].player_name
            
            // Set frame initiatives
            var initiativeIndex: UILabel?
            for initiative in self.initiativeNumberLabels {
                if (initiative.tag) == i {
                    initiativeIndex = initiative
                }
            }
            // Append 0 to single digit initiatives
            let initiativeWithZeroes = players[initiativeOrder[i]].player_initiative >= 10 ?
                String(players[initiativeOrder[i]].player_initiative) :
                "0" + String(players[initiativeOrder[i]].player_initiative)
            initiativeIndex?.text = initiativeWithZeroes
            
            // Set frame images
            var imageIndex: UIImageView?
            for image in self.initiativeImages {
                if (image.tag) == i {
                    imageIndex = image
                }
            }
            imageIndex?.image = players[initiativeOrder[i]].player_icon.image
        }

        initiativeBtnOutlet.alpha = 0
        
        // Show main window
        initiativeView.center = self.view.center
        initiativeView.transform = CGAffineTransform.identity
        initiativeView.alpha = 1
        
        // Animate buttons
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            for i in 0...3 {
                var buttView: UIView?
                for view in self.initiativePlayerBackgrounds {
                    if (view.tag) == i {
                        buttView = view
                    }
                }
                UIView.addKeyframe(withRelativeStartTime: Double(i) / 5, relativeDuration: 1/3, animations: {
                    buttView!.transform = CGAffineTransform.identity
                    buttView!.alpha = 1
                })
            }
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/3, animations: {
                self.initiativeBtnOutlet.alpha = 1
            })
        })
    }
    
    func hideInitiativeView() {
        
        // Animate buttons
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            for i in 0...3 {
                var buttView: UIView?
                for view in self.initiativePlayerBackgrounds {
                    if (view.tag) == i {
                        buttView = view
                    }
                }
                UIView.addKeyframe(withRelativeStartTime: Double(i) / 5, relativeDuration: 1/3, animations: {
                    buttView!.transform = CGAffineTransform.identity.translatedBy(x: -50, y: 0)
                    buttView!.alpha = 0
                })
            }
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/3, animations: {
                self.initiativeBtnOutlet.alpha = 0
            })
        }, completion: { _ in
            self.initiativeView.removeFromSuperview()
            self.showTurnsView()
        })
        calcTimeElapsed(since: timeScreenInitiativeStart, store: &timeScreenInitiativeEnd, str: "Screen initiative input")
    }
    
    func showPlayerBoard() {
        playerBoard.isHidden = false
        
        // Store time
        timeInitiativeStart = getTimeNow()
        
        for playerButtonArea in playerButtonAreas {
            playerButtonArea.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
            playerButtonArea.alpha = 0
        }
        
        
        exitButtonArea.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        exitButtonArea.alpha = 0
        
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
            UIView.addKeyframe(withRelativeStartTime: 0.4/0.5, relativeDuration: 0.2/0.5, animations: {
                self.exitButtonArea.transform = CGAffineTransform.identity
                self.exitButtonArea.alpha = 1
            })
        }, completion:{ _ in
            // Do nothing
        })
    }
    
    func hidePlayerBoard() {
        playerButton1.isEnabled = true
        playerButton2.isEnabled = true
        playerButton3.isEnabled = true
        playerButton4.isEnabled = true
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0/0.5, relativeDuration: 0.2/0.5, animations: {
                self.playerButtonArea4.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                self.playerButtonArea4.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1/0.5, relativeDuration: 0.2/0.5, animations: {
                self.playerButtonArea1.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                self.playerButtonArea1.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2/0.5, relativeDuration: 0.2/0.5, animations: {
                self.playerButtonArea3.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                self.playerButtonArea3.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3/0.5, relativeDuration: 0.2/0.5, animations: {
                self.playerButtonArea2.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                self.playerButtonArea2.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4/0.5, relativeDuration: 0.2/0.5, animations: {
                self.exitButtonArea.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                self.exitButtonArea.alpha = 0
            })
        }, completion:{ _ in
            //
            self.showInitiativeView()
            self.playerBoard.isHidden = true
        })
    }
    
    func showTurnsView() {
        self.view.superview!.addSubview(turnsView)
        
        timeBreakStart = getTimeNow()
        
        // Hide buttons
        turnButton1View.alpha = 0
        turnButton2View.alpha = 0
        turnsIcon.alpha = 0
        
        // Show main window
        turnsView.center = self.view.center
        turnsView.transform = CGAffineTransform.identity
        turnsView.alpha = 1
        
        self.turnsImg.image = UIImage(named: "sleep")
        self.turnsIcon.backgroundColor = colors["transparent"]
        UIView.animate(withDuration: 0.4) {
            self.turnsIcon.alpha = 1
        }
        
        // Show initial buttons
        animateTurnButtonViewIn(turn: -1)
        animateTurnButtonViewIn(turn: currTurn)
        
    }
    
    func hideTurnsView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.turnsIcon.alpha = 0
        }) { (_) in
            self.turnsView.removeFromSuperview()
            self.showPlayerBoard()
        }
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
    
    func animateTurnButtonViewIn(turn: Int) {
        
        if (turn == -1) { // Monster turn
            if (monsterActive == true) {
                // No setup needed for monster button (always monster)
                
                // Setup animation
                turnButton1View.alpha = 0
                turnButton1View.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 50)
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.turnButton1View.alpha = 1
                    self.turnButton1View.transform = CGAffineTransform.identity
                },completion: { _ in
                    // Do something
                })
                monsterActive = false
            }
        } else if (turn == 4) { // End turn
            // Setup button
            turnButton2View.backgroundColor = colors["gray"]
            turnButton2Img.image = UIImage(named: "pause")
            turnButton2Text.text = "Next Round"

            // Setup animation
            turnButton2View.alpha = 0
            turnButton2View.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 50)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.turnButton2View.alpha = 1
                self.turnButton2View.transform = CGAffineTransform.identity
            },completion: { _ in
                // Do something
            })
        } else { // Player turn
            // Setup button
            turnButton2View.backgroundColor = players[initiativeOrder[turn]].player_color
            turnButton2Img.image = players[initiativeOrder[turn]].player_icon.image
            turnButton2Text.text = players[initiativeOrder[turn]].player_name
            
            // Setup animation
            turnButton2View.alpha = 0
            turnButton2View.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 50)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.turnButton2View.alpha = 1
                self.turnButton2View.transform = CGAffineTransform.identity
            },completion: { _ in
                // Do something
            })
        }
    }
    
    func animateTurnButtonViewOut(turn: Int) {
        
        if (turn == -1) { // Monster
            UIView.animate(withDuration: 0.2) {
                self.turnButton1View.alpha = 0
                self.turnButton1View.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 50)
            }
            monsterActive = true
        } else if (turn == 4) { // End Turn
            UIView.animate(withDuration: 0.2, animations: {
                self.turnButton2View.alpha = 0
                self.turnButton2View.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 50)
            },completion: { _ in
                self.newRound()
            })
        } else { // Player turn
            UIView.animate(withDuration: 0.2, animations: {
                self.turnButton2View.alpha = 0
                self.turnButton2View.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 50)
            },completion: { _ in
                self.animateTurnButtonViewIn(turn: -1)
                self.animateTurnButtonViewIn(turn: self.currTurn)
            })
        }
        
        // TODO: Check logic to spawn new button(s) 
    }
    
    func newRound() {
        monsterActive = true
        for player in players {
            player.player_initiative = -1
        }
        initiativeOrder = [0, 1, 2, 3]
        currTurn = 0
        breakEnded = false
        lastTurnFrom = -1
        hideTurnsView()
    }
    
    func getTimeNow() -> Double {
        return Date().timeIntervalSinceReferenceDate
    }
    
    func calcTimeElapsed(since: Double, store: inout Double, str: String = "undefined"){
        store += getTimeNow() - since
        print ("\(str) new time is: \(getTidyTime(timeIn: store))" )
    }
    
    func getTidyTime(timeIn: Double) -> String {
        var time = timeIn
        
        // Calculate hours
        let hours = UInt8(time / 3600.0)
        time -= TimeInterval(hours) * 3600.0
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @objc func UpdateTimer() {
        var time: Double = 0
        
        // Calculate total time since timer started in seconds
        time = getTimeNow() - timeStart
        
//        globalTimer.text = getTidyTime(timeIn: time)
    }
}
