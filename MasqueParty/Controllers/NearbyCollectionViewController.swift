//
//  NearbyCollectionViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 9/1/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit

import Firebase
import CoreLocation

private let reuseIdentifier = "NearbyCollectionViewCell"


class NearbyCollectionViewController: UICollectionViewController, CLLocationManagerDelegate {

    
//    var databaseRef = Database.database().reference()
     var usersDict = NSDictionary()
      var usersDoct = NSDictionary()
     var manager: CLLocationManager!
   
    lazy var userAreas = [""]
    
    lazy var userNamesArray = [String]()
     lazy var userImagesArray = [String]()
     lazy var userScores = [String]()
    lazy var userViews = [String]()
     lazy var userIDS = [String]()
    let theuser = Auth.auth().currentUser
    
//    var ref = Database.database().reference()
   

    @IBOutlet var nearbyLoading: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
       
        
         self.nearbyLoading.startAnimating()
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 480, height: 44))
        label.numberOfLines = 2
        self.navigationItem.titleView = label
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textAlignment = .left
        label.textColor = UIColor.blue
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                label.text = "Enable Location Services"
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
               
      
            @unknown default:
                print("No access")
            }
        } else {
            print("Location services are not enabled")
            label.text = "Enable Location Services"
            if self.theuser?.email != nil {
//                self.ref.child("user_profile").child("\(self.theuser!.uid)/postalCity").removeValue()
                
            }else{
//                self.ref.child("user_profile").child("\("jtHIiFvY1LZgae6YquGgnAt9pfh2")/\(guestCoda[0])").setValue("")
            }

        }
      
        
        if self.theuser?.email != nil {
//            self.databaseRef.child("user_profile").observeSingleEvent(of: .value, with :{
//            (snapshot)  in
//            self.usersDict = (snapshot.value as? NSDictionary)!
//                        for(_,details) in self.usersDict{
//                            let numberFormatter = NumberFormatter()
//                            numberFormatter.numberStyle = NumberFormatter.Style.decimal
//
//                let usersDuct = snapshot.value as! NSDictionary
//
//
//                            let userDetzils = usersDuct.object(forKey: self.theuser!.uid)
//
//                var city : String!
//                            city = (userDetzils! as AnyObject).object(forKey: "postalCity") as? String
//
//                            self.userAreas[0] = "\(String(describing: city!))"
//                            let cita = (details as AnyObject).object(forKey: "postalCity") as? String
//
//                            if let name = (details as AnyObject).object(forKey: "name") as? String {
//
//                                if let prif = (details as AnyObject).object(forKey: "uids") as? String {
//
//                                    let appendNO = (userDetzils! as AnyObject).object(forKey: "appendNo") as? String
//                if city != nil || city != "" {
//                    if let nxm = (details as AnyObject).object(forKey: "points") as? String {
//                        if let nym = (details as AnyObject).object(forKey: "views") as? String {
//                        if prif != (self.theuser!.uid){
//                            if prif != "jtHIiFvY1LZgae6YquGgnAt9pfh2" {
//                            print("Im not in nearby, hoo ra")
//
//
//
//                            if cita == self.userAreas.first {
//
//                                //Here above is where you can set the OR to
//                                print("we got users in the area")
//
//
//
//
//                                if let img = (details as AnyObject).object(forKey: "profile_pic_small") as? String {
//                                    if let nmScore = Int(nxm) {
//                                        if let nmView = Int(nym) {
//
//                                            if let nqmScores = numberFormatter.string(from: NSNumber(value: nmScore)) {
//                                                if let nzmViews = numberFormatter.string(from: NSNumber(value: nmView)) {
//
//
//                                if appendNO != "1" && city != "" && city != nil{
//                                print(name)
//                                print(img)
//                                print(nqmScores)
//                                self.userImagesArray.append(img)
//                                self.userNamesArray.append(name)
//                                self.userScores.append("\(nqmScores)")
//                                self.userViews.append("\(nzmViews)")
//                                self.userIDS.append("\(prif)")
//                            self.databaseRef.child("user_profile").child("\(self.theuser!.uid)/appendNo").setValue("1")
//                                    label.text = "\(String(describing: city!))" + " (\(numberFormatter.string(from: NSNumber(value: self.userNamesArray.count))!))"
//                                self.collectionView?.reloadData()
//                                self.nearbyLoading.stopAnimating()
//
//                                }else{
//                                    self.nearbyLoading.stopAnimating()
//                                    label.text = "Enable Location Services"
//                                }
//                                }
//
//                            }else{
//                                self.nearbyLoading.stopAnimating()
//                                if city != nil && city != ""{
//                                    label.text = "\(String(describing: city))" + "\n (\(numberFormatter.string(from: NSNumber(value: self.userNamesArray.count))!))"
//                                }
//                                }
//                            }
//                                }
//                            }
//                            }
//                            }else{
//                                label.text = "Enable Location Services"
//                            }
//                        }
//                    }
//                        }
//                    }
//
//                }
//                }
//
//
//            }
//
//        })
            
            self.nearbyLoading.startAnimating()
            label.text = "Looking for people in your location..."
            
        
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: 375, height: 54)
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
 


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.userNamesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! NearbyCollectionViewCell
        
            if let imageUrl = NSURL(string:userImagesArray[indexPath.row]){
            
                if let imageData = NSData(contentsOf: imageUrl as URL){
            
                    cell.nearbyImage.image = UIImage(data:imageData as Data)
            cell.nearbyUser.text = userNamesArray[indexPath.row]
            cell.score.text = userScores[indexPath.row]
            cell.views.text = userViews[indexPath.row]
            cell.uids.text = userIDS[indexPath.row]
                }
            }
        
            return cell
    }
   

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
