//
//  TimerViewController.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/2/18.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit
import os.log



class TimerViewController: UIViewController {
    // MARK - PROPERTIES
    var ticking: Bool!
    weak var timer: Timer!
    var totalTime = 10          // second to tick down from
    
    // SEGUE
    var workout : Workout?
    var round : Round!
    
    // TIMER STATE
    var numRounds = 1
    var currentSet = 0
    var currentRound = 1
    var totalSetCount = 8
    var working = false
    var colorState = UIColor.TColor.work
    
    // AUDIO
    var audio = SoundService()
    
    // OUTLETs
    @IBOutlet weak var setCount: UILabel!
    @IBOutlet weak var roundCount: UILabel!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResumeButton: UIButton!
    @IBOutlet weak var giveupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CHECK IF THIS IS JUST FOR THIS LAYOUT
        UIApplication.shared.isIdleTimerDisabled = true
        startResumeButton.layer.cornerRadius = 8
        giveupButton.layer.cornerRadius = 8
        initializeTimer()
        audio.initializeAudio(name: SoundFile.CountDown, ofType: "wav")
        //workout?.printWorkout()
        setupTimer(title: (workout?.title)!)
        
    }
    
    // MARK - TIMER SETUP
    func initializeTimer() {
        ticking = false
        // Do any additional setup after loading the view.
        round = workout?.rounds
        numRounds = (workout?.numRounds)!
        currentRound = 1
        currentSet = 0
        totalSetCount = round.numSets
        working = false
        totalTime = 10
        
    }
    
    func setupTimer(title: String) {
        setupRound(current: currentRound)
        setupSet(current: currentSet)
        setupTitle(title: title, color: colorState)
        setupTime(sec: totalTime)
    }
    
    // ROUND label
    private func setupRound(current: Int) {
        roundCount.text = "Round \(String(describing: current)) of \(String(describing: numRounds))"
    }
    // SET label
    private func setupSet(current: Int) {
        if current > 0 {
            setCount.text = "\(String(describing: current)) of \(String(describing: totalSetCount))"
        } else {
            setCount.text = ""
        }
    }
    
    private func setupTitle(title: String, color: UIColor) {
        workoutLabel.text = title

        workoutLabel.textColor = color
    }
    
    private func setupTime(sec: Int) {
        timerLabel.text = String(describing: sec)
    }
    
    // MARK - TIMER STATUS
    func transitionToWork() {
        audio.initializeAudio(name: SoundFile.Exercise, ofType: "mp3")
        audio.player.play()
        
        currentSet += 1
        incrementAttempt()
        working = true
        totalTime = round.setSec
        colorState = UIColor.TColor.work
        setupTimer(title: getSetName(index: currentSet).uppercased())
    }
    
    // Only after the first 10 seconds PREP, the attempt is incremented!
    private func incrementAttempt() {
        if currentSet == 1 && currentRound == 1 {
            WorkoutService.increment(for: (workout?.key!)!, isChallenge: true)
        }
    }
   
    private func getSetName(index: Int) -> String {
        return round.exercises[index-1].name
    }
    
    func transitionToRest() {
        var title = "Rest"
        colorState = UIColor.TColor.shortRest
        working = false
        
        if currentSet < totalSetCount {
            totalTime = round.restSec
            audio.initializeAudio(name: SoundFile.Exercise, ofType: "mp3")
            
        } else {
            if currentRound == numRounds {
                WorkoutService.increment(for: (workout?.key!)!, isChallenge: false)
                initializeTimer()
                title = (workout?.title)!
                colorState = UIColor.TColor.work
                audio.initializeAudio(name: SoundFile.Completed, ofType: "mp3")
                setButton(isRun: ticking, start: "Start", stop: "Stop")
            } else {
                currentRound += 1
                audio.initializeAudio(name: SoundFile.Round, ofType: "mp3")
                totalTime = (workout?.restSec)!
                currentSet = 0
                title = "Rest between Rounds"
            }
            
        }
        
        setupTimer(title: title)
        audio.player.play()
        //setSoundToBeep()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - IBActions
    @IBAction func giveupTriggered(_ sender: UIButton) {
        // TO DO: PROMPT FOR CONFIRMATION !!
        cancel(sender)
    }
    
    @IBAction func cancel(_ sender: Any) {
        endTimer()
        audio.player.stop()
        
        let isPresentingInAddTimerMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTimerMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TimerView is not inside a navigation controller.")
        }
    }
    
    @IBAction func buttonTriggered(_ sender: UIButton) {
        ticking = !ticking
        setButton(isRun: ticking, start: "Resume", stop: "Pause")
    }
    
    @IBAction func forfeitTriggered(_ sender: UIButton) {
        let alert = UIAlertController(title: "Wait?", message: "Are you sure to give up now?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: cancel))
        self.present(alert, animated: true)
        
        if ticking {
            buttonTriggered(sender)
        }
        
    }
    
    // MARK : Privates
    func setButton(isRun: Bool, start: String, stop: String) {
        let title = isRun ? stop : start
        // TO DO: if title is START, increment challenge !!!!!!
        
        startResumeButton.setTitle(title, for: .normal)
        
        isRun ? startTimer() : endTimer()
        
    }
    
    // MARK: Privates
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
    
        if totalTime > 0 {
            if totalTime == 3 {
                audio.initializeAudio(name: SoundFile.CountDown, ofType: "wav")
                audio.player.play()
                // ANIMATION TO CHANGE THE COLOR
            } else if totalTime == 1 || totalTime == 2 {
                audio.player.play()
            }
            totalTime -= 1
        } else {
            // CHANGE HERE & change button too
            working ? transitionToRest() : transitionToWork()
        }
    }
    
    func endTimer() {
        if (timer != nil) {
            timer.invalidate()
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let sFormat = totalSeconds > 9 ? "%02d" : "%01d"
        
        return String(format: sFormat, totalSeconds)
    }

}
