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
        
        self.name.text = nearbyUser.name
        self.bio.text = nearbyUser.bio
        
        let userProfilePicURLString = nearbyUser.picURL
        
        guard let userProfilePicURL = URL(string: userProfilePicURLString) else {
            return
        }
        
        do {
            let imageData = try Data(contentsOf: userProfilePicURL)
            
            self.profilePic.image =  UIImage(data:imageData as Data)
        } catch {
            print("Unable to load data: \(error)")
        }
    }
}



