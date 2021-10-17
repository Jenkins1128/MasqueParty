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

class NearbyUsersViewController: UIViewController {

    var firebaseManager = FirebaseManager()
    var locationManager = LocationManager()
    var nearbyUsers : [NearbyUser] = []
   
    @IBOutlet var nearbyLoading: UIActivityIndicatorView!
    @IBOutlet weak var nearbyUsersCollectionView: UICollectionView!
    
    
    @IBAction func signoutPressed(_ sender: UIBarButtonItem) {
        if #available(iOS 13.0, *) {
            firebaseManager.signOut()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        locationManager.requestPermission()
       
        setTitle("Searching nearby...")
        startLoadingSpinner()
        
        //check if location services is on
        if locationManager.checkIfLocationEnabled() {
            //get postalCity using CoreLocation
            locationManager.requestLocation()
            
            
        }else{
            //else set nav title to Enable location services...
            setTitle("Enable location services...")
        }
            
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseManager.delegate = self
        locationManager.manager.delegate = self
        
        nearbyUsersCollectionView.register(UINib(nibName: K.CellInfo.nearbyCellNibName, bundle: nil), forCellWithReuseIdentifier: K.CellInfo.nearbyCellIdentifier)

    }
    
    func startLoadingSpinner() {
        showLoadingSpinner()
        nearbyLoading.startAnimating()
    }
    
    func stopLoadingSpinner() {
        nearbyLoading.stopAnimating()
        showLoadingSpinner(false)
    }
    
    func showLoadingSpinner(_ show: Bool = true){
        nearbyLoading.isHidden = !show
    }
    
    func setTitle(_ title: String){
        navigationItem.title = title
    }
}

// MARK: - UICollectionViewDataSource

extension NearbyUsersViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return nearbyUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellInfo.nearbyCellIdentifier, for: indexPath as IndexPath) as! NearbyCollectionViewCell
        if let userProfilePicURL = NSURL(string: nearbyUsers[indexPath.row].userProfilePicURL) as URL?,
           let imageData = NSData(contentsOf: userProfilePicURL) {
            cell.nearbyImage.image = UIImage(data:imageData as Data)
            cell.uid = nearbyUsers[indexPath.row].uid
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension NearbyUsersViewController : UICollectionViewDelegate {
    

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

// MARK: - FirebaseDelegate

extension NearbyUsersViewController : FirebaseDelegate {
    func clearNearbyUsers() {
        nearbyUsers = []
    }
    
    func addNearbyUser(_ nearbyUserId: String, _ profilePicURL: String) {
        let newUser = NearbyUser(uid: nearbyUserId, userProfilePicURL: profilePicURL)
        self.nearbyUsers.append(newUser)
        print("newUser", newUser)
    }
    
    func refreshCollectionView() {
        DispatchQueue.main.async {
            self.nearbyUsersCollectionView.reloadData()
            if self.nearbyUsers.count > 0 {
                let indexPath = IndexPath(row: self.nearbyUsers.count - 1, section: 1)
                self.nearbyUsersCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension NearbyUsersViewController : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                locationManager.requestLocation()
                startLoadingSpinner()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let location = locations.first else {
            setTitle("No Location")
            self.stopLoadingSpinner()
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print(error!.localizedDescription)
                self.stopLoadingSpinner()
                return
            }
            
            if let firstPlacemark = placemarks?.first {
                let currentlocation = firstPlacemark.subAdministrativeArea ?? "no sub area"
                //update current user's postalCity in firestore
                self.firebaseManager.setDataForCurrentUser("postalCity", currentlocation)
                //get once, query where postalCity, not current uid, limit 20
                self.firebaseManager.queryForUsersInLocation(currentlocation)
                self.setTitle(currentlocation)
                self.stopLoadingSpinner()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}


