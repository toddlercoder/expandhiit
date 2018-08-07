//
//  RestCell.swift
//  ExpandHIIT
//
//  Created by Melody Song on 7/2/18.
//  Copyright © 2018 Alex K. All rights reserved.
//

import UIKit

class RestCell: UITableViewCell {

    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var restSecLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
    
    func setSecLabel(num: Int) {
        restSecLabel.text = "\(String(describing: num)) sec"
    }

}
