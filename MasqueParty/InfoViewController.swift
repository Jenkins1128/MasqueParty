//
//  InfoViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class InfoViewController: UIViewController, CLLocationManagerDelegate {
    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
    //this above will be the id that you put in your current users database to display the info
    @IBOutlet var labelFrom: UILabel!
    
    @IBOutlet var labelMovies: UILabel!
    @IBOutlet var labelPerson: UILabel!
    @IBOutlet var labelAge: UILabel!
    @IBOutlet var labelPol: UILabel!
    @IBOutlet var labelReach: UILabel!
    
    @IBOutlet var labelMotto: UILabel!
    @IBOutlet var labelMusic: UILabel!
    @IBOutlet var labelAnimal: UILabel!
    @IBOutlet var labelHappy: UILabel!
    @IBOutlet var labelWord: UILabel!
    @IBOutlet var labelYears: UILabel!
    @IBOutlet var labelImprove: UILabel!
    @IBOutlet var labelStren: UILabel!
    @IBOutlet var labelColor: UILabel!
    @IBOutlet var labelFood: UILabel!
    @IBOutlet var labelRel: UILabel!
    @IBOutlet var labelGoals: UILabel!
    @IBOutlet var labelType: UILabel!
    @IBOutlet var labelInterests: UILabel!
    
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var labelAttitude: UILabel!
    @IBOutlet var labelDislikes: UILabel!

lazy var numci = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
          
            @unknown default:
                print("No access")
            }
        } else {
            print("Location services are not enabled")
               if self.user?.email != nil {
            self.ref.child("user_profile").child("\(self.user!.uid)/postalCity").removeValue()
               }else{
               self.ref.child("user_profile").child("\("jtHIiFvY1LZgae6YquGgnAt9pfh2")/\(guestCoda[0])").setValue("")
            }
        }

        if self.user?.email != nil {
            let userIDO: String = (Auth.auth().currentUser?.uid)!
            ref.child("user_profile").child(userIDO).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
            
                let THEUSER = value["uides"] as? String
                let nhm = value["points"] as! String
            
                if THEUSER != userIDO {
                
                    self.numci[0] = "\(nhm)"
                
                }
            }
        })
            ref.child("user_profile").child(userIDO).observeSingleEvent(of: .value, with: {
            (snapshot) in
        if let value = snapshot.value as? [String: Any] {
        let THEUSER = value["uides"] as? String
          if THEUSER != userIDO {
            if let numcz = self.numci.first {
                if var input:Int = Int(numcz) {
                    
                    input += 2
                    self.ref.child("user_profile").child("\(self.user!.uid)/points").setValue("\(input)")
                    
                }else{
                    print("Shit")
                }
            }else{
                print("Fuck")
            }
            }
            }
        
        })
        

            ref.child("user_profile").child(userIDO).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                let ntm = value["appendNo"] as? String
            
                if ntm == nil || ntm == "" || ntm == "1" {
                    self.ref.child("user_profile").child("\(self.user!.uid)/appendNo").setValue("0")
                
                }
            }
            
        })
            ref.child("user_profile").child(userIDO).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                let nrm = value["appendNa"] as? String
            
                if nrm == nil || nrm == "" || nrm == "1" {
                    self.ref.child("user_profile").child("\(self.user!.uid)/appendNa").setValue("0")
                }
            }
            
        })

            _ = self.ref.child("user_profile").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            let nothin = snapshot.value
            if nothin != nil{
             let usersDict = snapshot.value as! NSDictionary
                
                
                let userDetails = usersDict.object(forKey: self.user!.uid)
                if let THEUSER = (userDetails as AnyObject).object(forKey: "uides") as? String {
               
                
                
                    let details = usersDict.object(forKey: THEUSER)
                    self.labelAge.text = (details as AnyObject).object(forKey: "age") as? String
                    self.labelFrom.text = (details as AnyObject).object(forKey: "from") as? String
                    self.labelPerson.text = (details as AnyObject).object(forKey: "personality") as? String
                    self.labelInterests.text = (details as AnyObject).object(forKey: "interests") as? String
                    self.labelDislikes.text = (details as AnyObject).object(forKey: "dislikes") as? String
                    self.labelAttitude.text = (details as AnyObject).object(forKey: "attitude") as? String
                    self.labelMotto.text = (details as AnyObject).object(forKey: "motto") as? String
                    self.labelStatus.text = (details as AnyObject).object(forKey: "status") as? String
                    self.labelType.text = (details as AnyObject).object(forKey: "type") as? String
                    self.labelGoals.text = (details as AnyObject).object(forKey: "goals") as? String
                    self.labelReach.text = (details as AnyObject).object(forKey: "reachgoals") as? String
                    self.labelMusic.text = (details as AnyObject).object(forKey: "music") as? String
                    self.labelMovies.text = (details as AnyObject).object(forKey: "movies") as? String
                    self.labelPol.text = (details as AnyObject).object(forKey: "achievement") as? String
                    self.labelRel.text = (details as AnyObject).object(forKey: "ethnicity") as? String
                    self.labelFood.text = (details as AnyObject).object(forKey: "foods") as? String
                    self.labelColor.text = (details as AnyObject).object(forKey: "zodiac") as? String
                    self.labelStren.text = (details as AnyObject).object(forKey: "strengths") as? String
                    self.labelImprove.text = (details as AnyObject).object(forKey: "improve") as? String
                    self.labelYears.text = (details as AnyObject).object(forKey: "years") as? String
                    self.labelWord.text = (details as AnyObject).object(forKey: "oneword") as? String
                    self.labelHappy.text = (details as AnyObject).object(forKey: "happy") as? String
                    self.labelAnimal.text = (details as AnyObject).object(forKey: "animal") as? String
                
                }
            }else{
                
            }
        })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
