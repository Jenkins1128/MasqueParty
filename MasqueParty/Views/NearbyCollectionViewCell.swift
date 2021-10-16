//
//  NearbyCollectionViewCell.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 9/1/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit

class NearbyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nearbyImage: UIImageView!
    var uid: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        nearbyImage.layer.masksToBounds = true
        nearbyImage.layer.cornerRadius = self.nearbyImage.frame.size.width/2.0
    }
}
