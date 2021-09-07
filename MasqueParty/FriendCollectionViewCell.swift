//
//  FriendCollectionViewCell.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/29/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FriendCollectionViewCell: UICollectionViewCell {
    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
    @IBOutlet var uids: UILabel!
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var views: UILabel!

    @IBOutlet var score: UILabel!
  
    @IBAction func bioTap(sender: AnyObject) {
        
        let ids = uids.text
        self.ref.child("user_profile").child("\(self.user!.uid)/uides").setValue(ids)
        
        
       
        
        let userID: String = (ids)!
        ref.child("user_profile").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
            
                let ndm = value["views"] as? String
            
                var Ntm = Int(ndm!)!
                Ntm += 1
                self.ref.child("user_profile").child("\(userID)/views").setValue("\(Ntm)")
            }
            
        })
        
        
        
        
        
        
        

    }
     override func layoutSubviews()
    {
        super.layoutSubviews()
        self.makeItRound()
    }
    func makeItRound()
    {
        self.userImage.layer.masksToBounds  = true
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2.0
    }
}



