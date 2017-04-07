//
//  BusinessCell.swift
//  Yelp
//
//  Created by LING HAO on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var ratingImage: UIImageView!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    var business : Business! {
        didSet {
            if let image = self.business.imageURL {
                thumbImage.setImageWith(image)
            }
            nameLabel.text = self.business.name
            distanceLabel.text = self.business.distance
            if let image = self.business.ratingImageURL {
                ratingImage.setImageWith(image)
            }
            if let reviewCount = self.business.reviewCount {
                reviewLabel.text = reviewCount.stringValue + " reviews"
            }
            addressLabel.text = self.business.address
            categoryLabel.text = self.business.categories
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
