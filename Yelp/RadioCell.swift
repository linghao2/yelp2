//
//  RadioCell.swift
//  Yelp
//
//  Created by LING HAO on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class RadioCell: UITableViewCell {

    @IBOutlet var radioLabel: UILabel!
    @IBOutlet var radioImageView: UIImageView!
    
    var label: String = "" {
        didSet {
            radioLabel.text = label
        }
    }
    
    var type: RadioType = RadioType.RadioCollapsed {
        didSet {
            var name: String!
            switch type {
            case .RadioCollapsed:
                name = "downArrow"
            case .RadioSelected:
                name = "checkMark"
            case .RadioUnselected:
                name = "uncheckMark"
            }
            radioImageView.image = UIImage.init(named: name)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
