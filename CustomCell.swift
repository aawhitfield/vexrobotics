//
//  CustomCell.swift
//  VEX Robotics
//
//  Created by Aaron Whitfield on 12/20/14.
//  Copyright (c) 2014 Aaron Whitfield. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var abilityIcon: UIImageView!
    @IBOutlet weak var overallScoreLabel: UILabel!
    @IBOutlet var heart: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
