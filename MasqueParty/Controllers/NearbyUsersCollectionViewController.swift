//
//  NearbyCollectionViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 9/1/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import Firebase


class NearbyUsersCollectionViewController: UICollectionViewController {

    var firebaseManager = FirebaseManager()
    var locationManager = LocationManager()
    var nearbyUsers : [NearbyUser] = []
//    var databaseRef = Database.database().reference()
//     var usersDict = NSDictionary()
//      var usersDoct = NSDictionary()
//     var manager: CLLocationManager!
//
//    lazy var userAreas = [""]
//
//    lazy var userNamesArray = [String]()
//     lazy var userImagesArray = [String]()
//     lazy var userScores = [String]()
//    lazy var userViews = [String]()
//     lazy var userIDS = [String]()
//    let theuser = K.FStore.currentUser
    
//    var ref = Database.database().reference()
   

    @IBOutlet var nearbyLoading: UIActivityIndicatorView!
    
    
    @IBAction func signoutPressed(_ sender: UIBarButtonItem) {
        if #available(iOS 13.0, *) {
            firebaseManager.signOut()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //nearbyLoading.startAnimating()
        
        //ask for user location once
        
        //check if location services is on
            //get postalCity using CoreLocation and update current user's postalCity in firestore
            
            //get once, query where postalCity, not current uid, limit 20
            
            //populate nearbyUsers array
            
            //reload collection view data
        //else set nav title to Enable location services...
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        collectionView.register(UINib(nibName: K.CellInfo.nearbyCellNibName, bundle: nil), forCellWithReuseIdentifier: K.CellInfo.nearbyCellIdentifier)
        
//        if !locationManager.checkIfLocationEnabled() {
//            navigationController
//            return
//        }
       

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
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellInfo.nearbyCellIdentifier, for: indexPath as IndexPath) as! NearbyCollectionViewCell
        if let userProfilePicURL = NSURL(string: nearbyUsers[indexPath.row].userProfilePicURL) as URL?,
           let imageData = NSData(contentsOf: userProfilePicURL) {
            cell.nearbyImage.image = UIImage(data:imageData as Data)
            cell.uid = nearbyUsers[indexPath.row].uid
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



extension NearbyUsersCollectionViewController : LocationManagerDelegate {
    func setLabelText(_ text: String) {
        navigationController?.title = text
    }
    
    
}
