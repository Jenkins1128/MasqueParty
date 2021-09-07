//
//  FriendViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/29/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FBSDKCoreKit
import FirebaseAuth
import CoreLocation

private let reuseIdentifier = "FriendCollectionViewCell"
class FriendViewController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {


    @IBOutlet var LoadingSpinner: UIActivityIndicatorView!
  
    @IBOutlet var collectionView: UICollectionView!

    @IBOutlet var searchBar: UISearchBar!
    
 
     var isSearchOn = false
    lazy var searchResults = [String]()
    
    var icon:  FriendCollectionViewCell!

   
    lazy var usersDict = NSDictionary()
   lazy var usersDoct = NSDictionary()
   lazy var usersDqct = NSDictionary()
    lazy var userNamesArray = [String]()
   lazy var userImagesArray = [String]()
    lazy var userScores = [String]()
    lazy var userViews = [String]()
    lazy var userIDS = [String]()
    
     lazy var userNomesArray = [String]()
     lazy var userImogesArray = [String]()
     lazy var userSceres = [String]()
    lazy var userViaws = [String]()
    
    lazy var searchIDS = [""]
    var databaseRef = Database.database().reference()
    var user = Auth.auth().currentUser
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
                self.databaseRef.child("user_profile").child("\(self.user!.uid)/postalCity").removeValue()
                
            }else{
                self.databaseRef.child("user_profile").child("\("jtHIiFvY1LZgae6YquGgnAt9pfh2")/\(guestCoda[0])").setValue("")            }

        }

        self.LoadingSpinner.startAnimating()
        let fbRequest = GraphRequest(graphPath:"/me/friends", parameters: [ "fields": "name" ]);
        fbRequest.start(completionHandler: { (connection, result, error) in
            
            if error == nil {
                
                if let userNameArray : NSArray = result as? NSArray
                {
                    let i:Int = 0
                    for i in i ..< userNameArray.count
                    {
                        let fbfriends =  ((userNameArray[i] as AnyObject).value(forKey: "name"))
           
                        
                        
                        self.databaseRef.child("user_profile").observeSingleEvent(of: DataEventType.value, with :{
                            (snapshot)  in
                            
                            self.usersDict = (snapshot.value as? NSDictionary)!
                            
                            
                            for(_,details) in self.usersDict{
                                let numberFormatter = NumberFormatter()
                                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                                let userDetxils = self.usersDict.object(forKey: self.user!.uid)
                                let appendNA = (userDetxils! as AnyObject).object(forKey: "appendNa") as? String
                                let name = (details as AnyObject).object(forKey: "name") as? String
                                let prpf = (details as AnyObject).object(forKey: "uids") as? String
                                if name == (fbfriends as! String)  {
                                
                                    if name != self.user?.displayName {
                                
                                        if let nwm = (details as AnyObject).object(forKey: "points") as? String {
                                            if let nsm = (details as AnyObject).object(forKey: "views") as? String {
                                        
                                     
                                       
                                        
                                                let img = (details as AnyObject).object(forKey: "profile_pic_small") as! String
                                            
                                            //Get rid of append and figure out a replace function. then get bio tap working and attack the view function to it. Get info to display that user's bio. then do that for nearby. THEN WE CAN MOVE ON TO IN APP PURCHASES :) !!! THEN MAKE FINAL EDITS AND WE ARE DONE. YESSS!!
                                            
                                                let nrmScores = numberFormatter.string(from: NSNumber(value: Int(nwm)!))
                                                let nvmViews = numberFormatter.string(from: NSNumber(value: Int(nsm)!))
                                        if appendNA != "1" {
                                            self.userImagesArray.append(img)
                                            self.userNamesArray.append(name!)
                                            self.userScores.append(nrmScores!)
                                            self.userViews.append(nvmViews!)
                                            self.userIDS.append("\(prpf!)")
                                         self.databaseRef.child("user_profile").child("\(self.user!.uid)/appendNa").setValue("1")
                                            self.navigationItem.title = "Friends" + " (\(numberFormatter.string(from: NSNumber(value: self.userNamesArray.count))!))"
                                            
                                            self.collectionView?.reloadData()
                                            self.LoadingSpinner.stopAnimating()
                                        }
                                    }

                                    }
                                    }
                                }
                            }
                        })
                        
                    }
                        self.LoadingSpinner.stopAnimating()
                        self.navigationItem.title = "Invite Your Friends"
                    
                    
                } else {
                   
                    print("Error Getting Friends \(String(describing: error))");
                    
                }
            };
            self.LoadingSpinner.stopAnimating()
            self.navigationItem.title = "Feature not available."
            
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
        if isSearchOn == true && !searchResults.isEmpty {
            return searchIDS.count
        } else {
            return userNamesArray.count
        }
        
       
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let icon  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FriendCollectionViewCell


        let imageUrl = NSURL(string:userImagesArray[indexPath.row])
        
        let imageData = NSData(contentsOf: imageUrl! as URL)
        
        
        if isSearchOn == true && !searchResults.isEmpty {
            
            self.databaseRef.child("user_profile").child("\(user!.uid)/search").setValue(searchIDS[0])
            
            _ = self.databaseRef.child("user_profile").observe(DataEventType.value, with: { (snapshot) in
               
                let nothin = snapshot.value
                if nothin != nil{
                    
                   
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                    let usorsDict = snapshot.value as! NSDictionary
                    let userDatails = usorsDict.object(forKey: self.user!.uid)
                    let THEUSOR = (userDatails as AnyObject).object(forKey: "search") as? String
                    
           
                    let datails = usorsDict.object(forKey: THEUSOR!)
                    
                    
                    let imgo = (datails! as AnyObject).object(forKey: "profile_pic_small") as! String
                    let nome = (datails! as AnyObject).object(forKey: "name") as? String
                    let nomScares = ((datails! as AnyObject).object(forKey: "points") as? String)!
                    let nimViaws = ((datails! as AnyObject).object(forKey: "views") as? String)!
                    let praf = (datails! as AnyObject).object(forKey: "uids") as? String
                    
                    
                    let numScores = numberFormatter.string(from: NSNumber(value: Int(nomScares)!))
                    let numViews = numberFormatter.string(from: NSNumber(value: Int(nimViaws)!))
                  
                
                    let imagoUrl = NSURL(string:imgo)
                    
                    let imageDota = NSData(contentsOf: imagoUrl! as URL)
                    
            
                    icon.userImage.image = UIImage(data:imageDota! as Data)
                    icon.userName.text = nome!
                    icon.score.text = numScores!
                    icon.views.text = numViews!
                    icon.uids.text = "\(praf!)"
                    
             
                    
                }else{
                   
                 
                                   }
            })
        }else{
            icon.userImage.image = UIImage(data:imageData! as Data)
        icon.userName.text = userNamesArray[indexPath.row]
        icon.score.text = userScores[indexPath.row]
        icon.views.text = userViews[indexPath.row]
        icon.uids.text = userIDS[indexPath.row]
        }
        
        
        // Configure the cell
        
      
        
        return icon
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil // Clear out the Search Bar's text field
        searchBar.showsCancelButton = false // Hide the Search Bar's Cancel button
        searchBar.resignFirstResponder()  // Dismiss the keyboard
        isSearchOn = false // Turn off search function
        self.collectionView.reloadData()
        // Refresh the collection view
    }
    
    // this function is fired when the user start entering text in the Search Bar's text field
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true  // Show the Search Bar's Cancel button
        if !searchText.isEmpty {
            isSearchOn = true  // Turn on searching function
            self.filterContentForSearchText() // Search the collection view's dataSource
            self.collectionView.reloadData()
        }
    }
    
    func filterContentForSearchText() {
        // Remove all elements from the searchResults array
        searchResults.removeAll(keepingCapacity: false)
        
        // Loop throught the collection view's dataSource object
    
        for USERS in userNamesArray {
        
            let stringToLookFor = USERS as NSString
            let sourceString = searchBar.text! as NSString
            
            if stringToLookFor.localizedCaseInsensitiveContains(sourceString as String) {
                // Match found, so add it to the searchResults array variable
                searchResults.append(USERS)
                
                self.databaseRef.child("user_profile").observeSingleEvent(of: .value, with :{
                    (snapshot)  in
                    
                    self.usersDqct = (snapshot.value as? NSDictionary)!
                    
                    
                    for(_,details) in self.usersDqct{
                       
                        let name = (details as AnyObject).object(forKey: "name") as? String
                        
                        if name == USERS  {
                    
                            let pref = (details as AnyObject).object(forKey: "uids") as! String
                            
                            self.searchIDS[0] = "\(pref)"
                            
                        }
                    }
                    })
                
            }
        }
    }

    @objc func collectionViewBackgroundTapped() {
        // Dismiss the keyboard that's shown on the device's screen
        searchBar.resignFirstResponder()
    }
    
    /***********************
     This function allow the default tap gesture added to the collection view cell,
     an the collection view's background to to work simultaneously
     **************************/
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Perform default tap gesture
        return true
    }



}
