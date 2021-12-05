//
//  FirebaseManager.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/7/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FBSDKLoginKit
import FBSDKCoreKit

protocol FirebaseDelegate {
    @available(iOS 13.0, *) func signInSuccess()
    func signInError(_ error: Error)
    func clearNearbyUsers()
    func refreshCollectionView(_ currentLocation: String)
    func addNearbyUser(_ nearbyUserId: String, _ picURL: String, _ name: String, _ bio: String)
    func updateUserProfileUI(_ userData: [String: Any]?)
    func promptMessage(_ message: String)
}

struct FirebaseManager {
    var delegate : FirebaseDelegate?
    private var db = Firestore.firestore()
    private var currentUser : NearbyUser?
    
    @available(iOS 13.0, *)
    func signIn(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if error == nil {
                delegate?.signInSuccess()
                storeProfilePicture()
            } else {
                delegate?.signInError(error!)
            }
        }
    }
    
    @available(iOS 13.0, *)
    func signOut()  {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: K.UserDefaults.uid)
            LoginManager().logOut()
            goTo(K.Controllers.loginView)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func storeProfilePicture() {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: K.Storage.storageRef)
        let user = K.FStore.currentUser
        let userId = K.FStore.currentUserId
        let profilePicRef = storageRef.child(userId+"/profile_pic_small.jpg")
        let photoURLWithAccessToken =  "http://graph.facebook.com/\(AccessToken.current!.userID)/picture?type=large"
        
        guard let imageData = try? Data(contentsOf: URL(string: photoURLWithAccessToken)!) else {
            return
        }
        
        if !checkFieldExistsInDocument("name") {
            setDataForCurrentUser("name", user?.displayName ?? "")
        }
        
        _ = profilePicRef.putData(imageData as Data, metadata:nil) { metadata, error in
            guard error == nil,
                metadata != nil else {
                return
            }
            
            profilePicRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                
                setDataForCurrentUser("profile_pic_small", downloadURL.absoluteString)
            }
        }
    }
    
    @available(iOS 13.0, *)
    func goTo(_ storyboardId: String){
        let storyboard = UIStoryboard(name: K.mainStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: storyboardId)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(controller)
    }
    
    func checkFieldExistsInDocument(_ field: String) -> Bool {
        var exists = false
        let docRef = db.collection(K.FStore.usersCollection).document(K.FStore.currentUserId)
        
        docRef.getDocument { (document, error) in
            guard let document = document,
                  document.exists,
                  document.get(field) != nil else {
                      return
                  }
            
            exists = true
        }
        
        return exists
    }
    
    func setDataForCurrentUser(_ key: String, _ value: String) {
        db.collection(K.FStore.usersCollection).document(K.FStore.currentUserId).setData([
            key: value,
        ], merge: true) { error in
            if let error = error {
                let errorMessage = error.localizedDescription
                
                delegate?.promptMessage(errorMessage)
            }else{
                delegate?.promptMessage("Saved.")
            }
        }
    }
    
    func readUserData(_ uid: String = K.FStore.currentUserId) {
        let docRef = db.collection(K.FStore.usersCollection).document(uid)
        
        docRef.getDocument { (document, error) in
            guard let document = document,
                  document.exists else {
                      return
                  }
            
            delegate?.updateUserProfileUI(document.data())
        }
    }

    
    func queryForUsersInLocation(_ currentLocation: String) {
        let docRef = db.collection(K.FStore.usersCollection).whereField("postalCity", isEqualTo: currentLocation).limit(to: 20)
        
        docRef.getDocuments() { querySnapshot, error in
            guard error == nil,
                  let snapshotDocuments = querySnapshot?.documents else {
                print("Error retrieving data \(error!)")
                return
            }
            
            delegate?.clearNearbyUsers()
            
            for doc in snapshotDocuments {
                let data = doc.data()
                let nearbyUserId = doc.documentID
                let profilePic = (data[K.FStore.profilePic] ?? "") as! String
                let name = (data["name"] ?? "") as! String
                let bio = (data["bio"] ?? "") as! String
                
                if nearbyUserId != K.FStore.currentUserId {
                    delegate?.addNearbyUser(nearbyUserId, profilePic, name, bio)
                }
            }
            
            delegate?.refreshCollectionView(currentLocation)
        }
    }
}

extension FirebaseDelegate {
    func clearNearbyUsers() {}
    func refreshCollectionView(_ currentLocation: String) {}
    func signInError(_ error: Error) {}
    func signInSuccess() {}
    func addNearbyUser(_ nearbyUserId: String, _ picURL: String, _ name: String, _ bio: String) {}
    func updateUserProfileUI(_ userData: [String: Any]?) {}
    func promptMessage(_ message: String) {}
}
