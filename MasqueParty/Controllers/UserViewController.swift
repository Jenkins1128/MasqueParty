//
//  PostViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/8/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    var nearbyUser: NearbyUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        guard let nearbyUser = nearbyUser else {
            return
        }
        print(nearbyUser)
        if let userProfilePicURL = NSURL(string: nearbyUser.picURL) as URL?,
           let imageData = NSData(contentsOf: userProfilePicURL) {
            self.profilePic.image =  UIImage(data:imageData as Data)
        }
        print(nearbyUser.name, nearbyUser.bio)
        self.name.text = nearbyUser.name
        self.bio.text = nearbyUser.bio
        
        
    }
}



