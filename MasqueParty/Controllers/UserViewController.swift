//
//  UserViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/8/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UITextView!
    
    var nearbyUser: NearbyUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBioLayer()
        updateUI()
    }
    
    func configureBioLayer() {
        bio.layer.borderWidth = 1
        bio.layer.borderColor = UIColor.lightGray.cgColor
        bio.layer.cornerRadius = 10
    }
    
    func updateUI() {
        guard let nearbyUser = nearbyUser else {
            return
        }
        if let userProfilePicURL = NSURL(string: nearbyUser.picURL) as URL?,
           let imageData = NSData(contentsOf: userProfilePicURL) {
            self.profilePic.image =  UIImage(data:imageData as Data)
        }
        self.name.text = nearbyUser.name
        self.bio.text = nearbyUser.bio
    }
}



