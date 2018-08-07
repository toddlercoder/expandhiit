//
//  DemoCollectionViewCell.swift
//  TestCollectionView
//
//  Created by Alex K. on 12/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class DemoCollectionViewCell: BasePageCollectionCell {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var customTitle: UILabel!
    @IBOutlet var instructor: UILabel!
    
    var workout: Workout!
    
    @IBOutlet weak var backCardView: UIView!
    @IBOutlet weak var numChallengeLabel: UILabel!
    @IBOutlet weak var numCompletedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
    }
    
    // viewdidload for count updates
}
