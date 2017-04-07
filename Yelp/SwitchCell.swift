//
//  SwitchCell.swift
//  Yelp
//
//  Created by LING HAO on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate: class {
    @objc optional func switchCell(switchCell: SwitchCell, didClickSwitch switchOn: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet var switchLabel: UILabel!
    @IBOutlet var switchSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    var label: String = "" {
        didSet {
            switchLabel.text = label
        }
    }
    
    var onSwitch: Bool = true {
        didSet {
            switchSwitch.isOn = onSwitch
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

    @IBAction func clickSwitch(_ sender: UISwitch) {
        delegate?.switchCell?(switchCell: self, didClickSwitch: sender.isOn)
    }
}
