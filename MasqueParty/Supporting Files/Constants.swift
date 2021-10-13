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
    static let appName = "⚡️FlashChat"
//    static let cellIdentifier = "ReusableCell"
//    static let cellNibName = "MessageCell"
//    static let registerSegue = "RegisterToChat"
//    static let loginSegue = "LoginToChat"
    
//    struct BrandColors {
//        static let purple = "BrandPurple"
//        static let lightPurple = "BrandLightPurple"
//        static let blue = "BrandBlue"
//        static let lighBlue = "BrandLightBlue"
//    }
    
    struct FStore {
        static let usersCollection = "users"
        static let postsCollection = "posts"
        static let currentUser = Auth.auth().currentUser
        static let currentUserId = Auth.auth().currentUser?.uid ?? ""
//        static let senderField = "sender"
//        static let bodyField = "body"
//        static let dateField = "date"
    }
}
