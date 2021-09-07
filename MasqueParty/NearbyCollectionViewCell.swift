//
//  NearbyCollectionViewCell.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 9/1/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
var globalusers = [""]
class NearbyCollectionViewCell: UICollectionViewCell {
  
    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
    
    
    @IBOutlet var nearbyImage: UIImageView!
    @IBOutlet var nearbyUser: UILabel!
    @IBOutlet var views: UILabel!
    @IBOutlet var score: UILabel!
    @IBOutlet var uids: UILabel!

    
    
    @IBAction func bioTap(sender: AnyObject) {
        let ids = uids.text
         if self.user?.email != nil {
        
        self.ref.child("user_profile").child("\(self.user!.uid)/uides").setValue(ids)
    
        
        let userID: String = (ids)!
            ref.child("user_profile").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                if let nm = value["views"] as? String {
                    if let ny = Int(nm) {
                        var Nzm = ny
                        Nzm += 1
                        self.ref.child("user_profile").child("\(userID)/views").setValue("\(Nzm)")
                    }
                }
                
            }
        })
         }else{
            let userID: String = (ids)!
            globalusers[0] = "\(userID)"
        }
        
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.makeItRound()
    }
    func makeItRound()
    {
        self.nearbyImage.layer.masksToBounds  = true
        self.nearbyImage.layer.cornerRadius = self.nearbyImage.frame.size.width/2.0
    }

}
