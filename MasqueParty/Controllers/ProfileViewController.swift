//
//  ProfileViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/4/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var saveBioButton: UIButton!
    @IBOutlet weak var profileScrollView: UIScrollView!
    
    private var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureRefreshControl()
        configureBioLayer()
        firebaseManager.readUserData()
        startRefreshing()
    }
    
    func configureDelegates() {
        firebaseManager.delegate = self
    }
    
    func configureRefreshControl() {
        profileScrollView.refreshControl = UIRefreshControl()
        profileScrollView.refreshControl?.addTarget(self, action: #selector(refreshProfile), for: .valueChanged)
        profileScrollView.refreshControl?.tintColor = .lightGray
    }
    
    @objc func refreshProfile() {
        firebaseManager.readUserData()
    }
    
    func configureBioLayer() {
        bio.layer.borderWidth = 1
        bio.layer.borderColor = UIColor.lightGray.cgColor
        bio.layer.cornerRadius = 10
    }
    
    func startRefreshing() {
        profileScrollView.refreshControl?.beginRefreshing()
    }
    
    func endRefreshing() {
        profileScrollView.refreshControl?.endRefreshing()
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
    func promptMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func updateUserProfileUI(_ userData: [String : Any]?) {
        guard let userData = userData else {
            return
        }
        DispatchQueue.main.async {
            if let userProfilePicURL = NSURL(string: userData["profile_pic_small"] as! String) as URL?,
               let imageData = NSData(contentsOf: userProfilePicURL) {
                self.profilePic.image =  UIImage(data:imageData as Data)
                
            }
            let fullName = userData["name"] as? String ?? ""
            let bioString = userData["bio"] as? String ?? ""
            self.name.text = fullName
            self.navigationItem.title = fullName
            if bioString.count > 0 {
                self.bio.text = bioString
            }
            self.endRefreshing()
        }
    }
}
