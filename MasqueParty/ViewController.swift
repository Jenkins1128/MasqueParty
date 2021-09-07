//
//  ViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 7/29/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//
/*
 let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
 let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeView")
 self.presentViewController(homeViewController, animated: true, completion: nil)
 
 let databaseRef = FIRDatabase.database().reference()
 let secret = self.randomize(self.stra)
 
 databaseRef.child("user_profile").child("\("jtHIiFvY1LZgae6YquGgnAt9pfh2")/\(secret)").setValue("")
 guestCoda[0] = "\(secret)"
 
 
 
 let stra = "abcdefghijklmonpqrstuvwxyz0123456789"
 
 // returns string with random order of characters
 func randomize(stra: String)->String {
 var chars = stra.characters.map{ $0 }
 let c = UInt32(chars.count)
 if c < 2 { return stra}
 
 for i in 0..<(c - 1) {
 let j = arc4random_uniform(c)
 if i != j {
 swap(&chars[Int(i)], &chars[Int(j)])
 }
 }
 return chars.reduce("", combine: { (stra, c) -> String in
 stra + String(c)
 })
 }
 */


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
var guestCoda = [""]
class ViewController: UIViewController, LoginButtonDelegate {
    var loginButton: FBLoginButton = FBLoginButton()
    
    @IBOutlet var loadingspinner: UIActivityIndicatorView!
    
    @IBAction func guest(sender: AnyObject) {
        
        
      //THE LAST THING WE HAVE TO DO IS SET THE PERMISSIONS TO TRUE FOR GUEST
        
    }
    
      override func viewDidLoad() {
        super.viewDidLoad()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        self.loginButton.isHidden = true
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                //next screen
                let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeView")
                self.present(homeViewController, animated: true, completion: nil)
                
                
                
            } else {
                // No user is signed in.
                //show log in button
                self.loginButton.center = self.view.center
                self.loginButton.permissions = ["public_profile", "email", "user_friends"]
//                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self;
                
                self.view!.addSubview(self.loginButton)
                self.loginButton.isHidden = false
            }
        }
        
        
        // Optional: Place the button in the center of your view.
        
        }
 

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("User logged in.")
        
        self.loginButton.isHidden = true
        loadingspinner.startAnimating()
        if error != nil {
            self.loginButton.isHidden = false
        loadingspinner.stopAnimating()
        }else if result!.isCancelled{
            self.loginButton.isHidden = false
        loadingspinner.stopAnimating()
        }else{
            
       
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
            print("User logged in to Firebase App")
           
            
            
            if(error == nil){
                let storage = Storage.storage()
                let storageRef = storage.reference(forURL: "gs://masqueparty-173fe.appspot.com")
                let user = Auth.auth().currentUser;
                let userId = (user?.uid)!
                let profilePicRef = storageRef.child(userId+"/profile_pic_small.jpg")
          
               
                let databaseRef = Database.database().reference()
                databaseRef.child("user_profile").child(userId).child("profile_pic_small").observeSingleEvent(of: .value,with:{ (snapshot) in
                    
                let profile_pic = snapshot.value as? String?
                
                    if(profile_pic == nil)
                    {
                        
                        if let imageData = NSData(contentsOf: (user?.photoURL!)!){
                            _ = profilePicRef.putData(imageData as Data, metadata:nil){
                                metadata,error in
                                
                                if(error == nil){
                                    guard metadata != nil else {
                                      // Uh-oh, an error occurred!
                                      return
                                    }
                                    
                                    profilePicRef.downloadURL { (url, error) in
                                      guard let downloadURL = url else {
                                        // Uh-oh, an error occurred!
                                        return
                                      }
                                        databaseRef.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(downloadURL.absoluteString)
                                    }
                                    //let downloadURL = metadata!.downloadURL
                                
                            }else{
                                print("error in downloading image")
                            }
                            
                        }
                        
                    }
                    databaseRef.child("user_profile").child("\(userId)/name").setValue(user?.displayName)
                        
                                      }else{
                        print("user has logged in earlier!")
                    }
                
                })
            }
        }
    }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out")
    }
    
  
    
    

    }
