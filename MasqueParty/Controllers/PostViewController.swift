//
//  PostViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/8/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class PostViewController: UIViewController {
//    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
    
 
    
    @IBOutlet var IMGO: UIImageView!
    

    @IBOutlet var postLabel: UILabel!
   
    @IBOutlet var pViews: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
         //self.date.text = "HII"
        self.postLabel.isHidden = true
//   ref.child("user_profile").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//           // let nrm = snapshot.value!["appendNa"] as? String
//            if let value = snapshot.value as? [String: Any] {
//                let nrm = value["appendNa"] as? String ?? ""
//                if nrm == "" || nrm == "1" {
//                    self.ref.child("user_profile").child("\(self.user!.uid)/appendNa").setValue("0")
//                }
//            }
//
//        })
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
//                self.ref.child("user_profile").child("\(self.user!.uid)/postalCity").removeValue()
            }else{
//                self.ref.child("user_profile").child("\("jtHIiFvY1LZgae6YquGgnAt9pfh2")/\(guestCoda[0])").setValue("")
            }
        }
       
        // Do any additional setup after loading the view.
    
//        _ = self.ref.child("user_profile").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//
//            let nothin = snapshot.value
//            if nothin != nil{
//                let usersDict = snapshot.value as! NSDictionary
//                let numberFormatter = NumberFormatter()
//                numberFormatter.numberStyle = NumberFormatter.Style.decimal
//
//                let userDetails = usersDict.object(forKey: self.user!.uid)
//                if let THEUSER = (userDetails as AnyObject).object(forKey: "uides") as? String {
//                    let details = usersDict.object(forKey: THEUSER)
//                    if let name =  (details! as AnyObject).object(forKey: "name") as? String {
//                        self.navigationItem.title = "\(name)"
//                    }
//                    if let d = (details! as AnyObject).object(forKey: "postViews") as? String {
//                    if let haha = Int(d){
//                        if let da = numberFormatter.string(from: NSNumber(value: haha)) {
//
//                            if let checkPostValue = (details! as AnyObject).object(forKey: "THEPOST") as? String {
//                    if checkPostValue != "" {
//
//                        if let checkImageValue = (details! as AnyObject).object(forKey: "picposted") as? String {
//                        if let imageUrl = NSURL(string:checkImageValue){
//                            if let imageData = NSData(contentsOf: imageUrl as URL){
//                                self.IMGO.image = UIImage(data:imageData as Data)
//
//
//                                if let nowDate = (details! as AnyObject).object(forKey: "theDate") as? String {
//                                    self.pViews.text = "\(da) \n post views\n\n\(nowDate)"
//                print("NOW DATE", nowDate)
//                                    self.postLabel.text = "  \(checkPostValue)"
//                }
//                        self.postLabel.isHidden = false
//
//                }else{
//                    self.postLabel.text = "no new post :("
//
//                }
//                        }
//                }
//                    }else{
//                        self.postLabel.text = "no new post :("
//                    }
//                    }
//                        }
//                }
//                }
//                }
//
//                //add post here
//
//            }
//            })
        self.navigationItem.title = "Loading..."
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
