//
//  Constants.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/7/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import Foundation
import FirebaseAuth

struct K {
    static let mainStoryboard = "Main"
    static let sceneConfigurationName = "Default Configuration"
    
    struct Controllers {
        static let mainTabBar = "MainTabBarController"
        static let loginView = "LoginViewController"
    }
   
    struct CellInfo {
            static let nearbyCellIdentifier = "NearbyCollectionViewCell"
            static let nearbyCellNibName = "NearbyCollectionViewCell"
    }
    
    struct UserDefaults {
        static let uid = "uid"
    }
    
    struct Storage {
        static let storageRef = "gs://masqueparty-173fe.appspot.com"
        
    }
    
    struct FStore {
        static let usersCollection = "users"
        static let postsCollection = "posts"
        static let profilePic = "profile_pic_small"
        static let defaultProfilePicURL = "https://www.gravatar.com/avatar/11c489ceed7151debcbfa12ee3094cf1?d=mp"
        static let currentUser = Auth.auth().currentUser
        static let currentUserId = Auth.auth().currentUser?.uid ?? ""
    }
}
