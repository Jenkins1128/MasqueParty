//
//  HomeViewController.swift
//  MasqueParty
//     var appID = "57d7908be51c4b742a00000c"
//var sdk = VungleSDK.sharedSDK()
// start vungle publisher library
//sdk.startWithAppId(appID)
//  Created by Isaiah Jenkins on 8/4/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//For the In app purchase, it's going to be .99 for 100 pts., 2.50 for 500pts, 5.00 for 1000pts
//For Guest user, if current user == nil then set current uid to masqueguest uid :) for each page that you need
import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UITextField!
    @IBOutlet weak var profileLoadingSpinner: UIActivityIndicatorView!
    
    var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseManager.delegate = self
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firebaseManager.readUserData()
        startLoadingSpinner()
    }
    
    func startLoadingSpinner() {
        showLoadingSpinner()
        profileLoadingSpinner.startAnimating()
    }
    
    func stopLoadingSpinner() {
        profileLoadingSpinner.stopAnimating()
        showLoadingSpinner(false)
    }
    
    func showLoadingSpinner(_ show: Bool = true){
        profileLoadingSpinner.isHidden = !show
    }
    
    @IBAction func saveBio(_ sender: UIButton) {
        let bioText = bio.text ?? ""
        guard bioText.count > 0 else {
            return
        }
        firebaseManager.setDataForCurrentUser("bio", bioText)
    }
    
    @IBAction func signoutPressed(_ sender: UIBarButtonItem) {
        if #available(iOS 13.0, *) {
            firebaseManager.signOut()
        }
    }
}

// MARK: - FirebaseDelegate

extension ProfileViewController : FirebaseDelegate {
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
            let fullName = userData["name"] as? String ?? ""
            let bioString = userData["bio"] as? String ?? ""
            self.name.text = fullName
            if bioString.count > 0 {
                self.bio.text = bioString
            }
        }
    }
}
