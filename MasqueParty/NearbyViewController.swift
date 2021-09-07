//
//  NearbyViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/31/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation


private let reuseIdentifier = "NearbyCollectionViewCell"
class NearbyViewController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate{

    @IBOutlet var NearbyLoading: UIActivityIndicatorView!
    
    @IBOutlet var collectionView: UICollectionView!
    

    var isSearchOn = false
    var searchResults = [String]()
    
    var icon:  NearbyCollectionViewCell!
    var manager: CLLocationManager!
    
    var usersDict = NSDictionary()
    var usersDoct = NSDictionary()
 
    var userAreas = [""]
    
    var userNmesArray = [String]()
    var userImgesArray = [String]()
    var userScres = [String]()
    var userViws = [String]()
    var userID = [String]()
    let thuser = FIRAuth.auth()?.currentUser
    
    var ref = FIRDatabase.database().reference()
    
  
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.NearbyLoading.startAnimating()
      
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy - kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        let currname = thuser!.displayName
        
        self.databaseRef.child("user_profile").observeEventType(.Value, withBlock :{
            (snapshot)  in
            self.usersDict = (snapshot.value as? NSDictionary)!
            
            for(_,details) in self.usersDict{
                let name = details.objectForKey("name") as! String
                
                
                var city : String!
                city = details.objectForKey("postalCity") as? String
                
                self.userAreas[0] = "\(city)"
                
                let prof = details.objectForKey("uids") as! String
                if let nom = details.objectForKey("points") as? String {
                    if let nim = details.objectForKey("views") as? String {
                        if name != currname {
                            
                            print("Im not in nearby, hoo ra")
                            if city == self.userAreas.first {
                                print("we got users in the area")
                                
                                
                                
                                
                                let img = details.objectForKey("profile_pic_small") as! String
                                
                                
                                
                                self.userImgesArray.append(img)
                                self.userNmesArray.append(name)
                                self.userScres.append(nom)
                                self.userViws.append(nim)
                                self.userID.append("\(prof)")
                                self.collectionView?.reloadData()
                                self.NearbyLoading.stopAnimating()
                            }else{
                                self.NearbyLoading.stopAnimating()
                                print("people not in area")
                            }
                        }
                    }
                }
            }
            
        })

        
        
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        
        
        tapRecognizer.addTarget(self, action: #selector(FriendViewController.collectionViewBackgroundTapped))
        
        
        self.collectionView.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in the section
        // Return the number of items in a section (number of photos in an album)
        
            return userNmesArray.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let icon  = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NearbyCollectionViewCell
        
        
        let imageUrl = NSURL(string:userImgesArray[indexPath.row])
        
        let imageData = NSData(contentsOfURL: imageUrl!)
        
               icon.userImoge.image = UIImage(data:imageData!)
            icon.userNome.text = userNmesArray[indexPath.row]
            icon.scare.text = userScres[indexPath.row]
            icon.viaws.text = userViws[indexPath.row]
            icon.uides.text = userID[indexPath.row]
        
        return icon
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        
        let userLocation:CLLocation = locations[0] as CLLocation!
        
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                print(error)
            } else {
                if let p = placemarks?[0] {
                    
                    
                    let theCity =  p.subAdministrativeArea!
                    
                    self.ref.child("user_profile").child("\(self.thuser!.uid)/postalCity").setValue(theCity)
                    
                }
            }
            
            
        })
        
        
    }

}
 
