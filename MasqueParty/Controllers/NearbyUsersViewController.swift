//
//  NearbyUsersViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 9/1/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class NearbyUsersViewController: UIViewController {
    @IBOutlet weak var nearbyUsersCollectionView: UICollectionView!
    
    private var firebaseManager = FirebaseManager()
    private var locationManager = LocationManager()
    private var nearbyUsers : [NearbyUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureRefreshControl()
        configureCollectionView()
        locationManager.requestPermission()
        locationManager.searchNearbyForUsers()
        startRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureDelegates() {
        firebaseManager.delegate = self
        locationManager.manager.delegate = self
        locationManager.delegate = self
    }
    
    func configureRefreshControl () {
        nearbyUsersCollectionView.refreshControl = UIRefreshControl()
        nearbyUsersCollectionView.refreshControl?.addTarget(self, action:
                                                                #selector(resfreshNearbyUsers),
                                                            for: .valueChanged)
        nearbyUsersCollectionView.refreshControl?.tintColor = .lightGray
    }
    
    @objc func resfreshNearbyUsers(refreshControl: UIRefreshControl) {
        locationManager.searchNearbyForUsers()
    }
    
    func configureCollectionView() {
        nearbyUsersCollectionView.register(UINib(nibName: K.CellInfo.nearbyCellNibName, bundle: nil), forCellWithReuseIdentifier: K.CellInfo.nearbyCellIdentifier)
        nearbyUsersCollectionView.accessibilityIdentifier = "nearbyUsersCollectionView"
    }
    
    func startRefreshing() {
        nearbyUsersCollectionView.refreshControl?.beginRefreshing()
    }
    
    func endRefreshing() {
        nearbyUsersCollectionView.refreshControl?.endRefreshing()
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
        return nearbyUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellInfo.nearbyCellIdentifier, for: indexPath as IndexPath) as! NearbyCollectionViewCell
        let userProfilePicURLString = nearbyUsers[indexPath.row].picURL
        
        guard let userProfilePicURL = URL(string: userProfilePicURLString) else {
            return cell
        }
        
        do {
            let imageData = try Data(contentsOf: userProfilePicURL)
            
            cell.nearbyImage.image = UIImage(data:imageData as Data)
            cell.uid = nearbyUsers[indexPath.row].uid
        } catch {
            print("Unable to load data: \(error)")
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension NearbyUsersViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToUserProfile", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUserProfile" {
            let indexPath = sender as! IndexPath
            let destitinationVC = segue.destination as! UserViewController
            
            destitinationVC.nearbyUser = nearbyUsers[indexPath.row]
        }
    }
}

// MARK: - FirebaseDelegate

extension NearbyUsersViewController : FirebaseDelegate {
    func clearNearbyUsers() {
        nearbyUsers = []
    }
    
    func addNearbyUser(_ uid: String, _ picURL: String, _ name: String, _ bio: String) {
        let newUser = NearbyUser(uid: uid, picURL: picURL, name: name, bio: bio)
        
        self.nearbyUsers.append(newUser)
    }
    
    func refreshCollectionView(_ currentLocation: String) {
        DispatchQueue.main.async {
            self.nearbyUsersCollectionView.reloadData()
            
            if self.nearbyUsers.count > 0 {
                let indexPath = IndexPath(row: self.nearbyUsers.count - 1, section: 0)
                
                self.nearbyUsersCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
            
            self.setControllerTitle(currentLocation)
            self.endRefreshing()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension NearbyUsersViewController : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                locationManager.requestLocation()
                setControllerTitle("Searching nearby...")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            setTitle("No Location")
            return
        }
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil,
                  let firstPlacemark = placemarks?.first else {
                      print(error!.localizedDescription)
                      return
                  }
            
            let currentlocation = firstPlacemark.name ?? firstPlacemark.subAdministrativeArea ?? "no sub area"

            self.firebaseManager.setDataForCurrentUser("postalCity", currentlocation)
            self.firebaseManager.queryForUsersInLocation(currentlocation)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - LocationManagerDelegate

extension NearbyUsersViewController : LocationManagerDelegate {
    func setControllerTitle(_ title: String) {
        setTitle(title)
    }
}

