//
//  WazzupCollectionViewCell.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/7/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class WazzupCollectionViewCell: UICollectionViewCell {
    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
    
    
    @IBOutlet var views: UILabel!
    @IBAction func bioTap(sender: AnyObject) {
        let ids = friendUi.text
        self.ref.child("user_profile").child("\(self.user!.uid)/uides").setValue(ids)
        
        
        
        
        let userID: String = (ids)!
        ref.child("user_profile").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                if let ndm = value["views"] as? String {
                    if let ngh = Int(ndm){
                        var Ntm = ngh
                        Ntm += 1
                        self.ref.child("user_profile").child("\(userID)/views").setValue("\(Ntm)")
                    }
                }
            }
        })
        
    
    }
  
    @IBOutlet var friendImg: UIImageView!
    
    @IBOutlet var friendName: UILabel!
    
    @IBOutlet var friendUi: UILabel!
    @IBOutlet var friendScore: UILabel!
  
    
    @IBAction func poster(sender: AnyObject) {
        let ids = friendUi.text
        self.ref.child("user_profile").child("\(self.user!.uid)/uides").setValue(ids)
        
        let userID: String = (ids)!
        self.ref.child("user_profile").child("\(self.user!.uid)/uides").setValue(ids)
        
        
    
        ref.child("user_profile").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                if let nm = value["postViews"] as? String {
                    if let nmlt = Int(nm) {
                        var Nzm = nmlt
                        Nzm += 1
                        self.ref.child("user_profile").child("\(userID)/postViews").setValue("\(Nzm)")
                    }
                }
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
        self.friendImg.layer.masksToBounds  = true
        self.friendImg.layer.cornerRadius = self.friendImg.frame.size.width/2.0
    }

}
