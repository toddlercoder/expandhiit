//
//  WorkoutTableViewCell.swift
//  ExpandHIIT
//
//  Created by Melody Song on 6/29/18.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    @IBOutlet var exerciseNumLabel: UILabel!
    @IBOutlet var secNumLabel: UILabel!
    @IBOutlet var exerciseNameLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    typealias workoutInfo = (exercise: String, sec: Int)
    //var toSet : workoutInfo?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // SET UP card-like look
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }*/
    
    func setSecLabel(num: Int) {
        secNumLabel.text = "\(String(describing: num)) sec"
    }

    func setOutlets(workout: workoutInfo, index: Int) {
        //print(workout)
    }
}
