//
//  TableViewCell.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/2/18.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit


class ChallengeCell: UITableViewCell {

    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var repeatLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        challengeButton.layer.cornerRadius = 8
        
    }
    
    @IBAction func acceptedChallenge(_ sender: UIButton) {
        print("I accept your challenge")
        //let timerLauncher = TimerLauncher()
        //timerLauncher.showTimerPlayer()
    }
    
    func setRepeat(num: Int) {
        repeatLabel.text = "Repeat \(String(describing: num))x total"
    }


    
    func deliverExerciseInfo(exercise: Exercise) {
        
    }
}
