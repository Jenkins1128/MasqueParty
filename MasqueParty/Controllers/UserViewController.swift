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
    @IBOutlet weak var userLoadingSpinner: UIActivityIndicatorView!
    
    var firebaseManager = FirebaseManager()
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseManager.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let uid = uid else {
            return
        }
        firebaseManager.readUserData(uid)
        startLoadingSpinner()
    }
    
    func startLoadingSpinner() {
        showLoadingSpinner()
        userLoadingSpinner.startAnimating()
    }
    
    func stopLoadingSpinner() {
        userLoadingSpinner.stopAnimating()
        showLoadingSpinner(false)
    }
    
    func showLoadingSpinner(_ show: Bool = true){
        userLoadingSpinner.isHidden = !show
    }
    
}

// MARK: - FirebaseDelegate

extension UserViewController : FirebaseDelegate {
    func updateUserProfileUI(_ userData: [String : Any]?) {
        guard let userData = userData else {
            return
        }
        print("profile updated")
        DispatchQueue.main.async {
            self.stopLoadingSpinner()
            if let userProfilePicURL = NSURL(string: userData["profile_pic_small"] as! String) as URL?,
               let imageData = NSData(contentsOf: userProfilePicURL) {
                self.profilePic.image =  UIImage(data:imageData as Data)
               
            }
            self.name.text = userData["name"] as? String ?? ""
            self.bio.text = userData["bio"] as? String ?? ""
        }
        
    }
}



