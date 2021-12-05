//
//  RoundedImageView.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/18/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2.0
        clipsToBounds = true
    }
}
