//
//  ViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 7/29/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//
/*
 uides - user for bio clicked
 uids - current user
 */


import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: UIViewController {
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var loginButton = FBLoginButton()
    var firebaseManager : FirebaseManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.delegate = self
        firebaseManager = FirebaseManager()
        firebaseManager?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        loadingSpinner.isHidden = true
        loginButton.isHidden = false
        loginButton.center = self.view.center
        loginButton.permissions = ["public_profile", "user_friends"]
        view.addSubview(self.loginButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func startLoadingSpinner() {
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimating()
    }
    
    func stopLoadingSpinner() {
        loadingSpinner.stopAnimating()
        loadingSpinner.isHidden = true
    }
}



//MARK: - LoginButtonDelegate


extension LoginViewController : LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        startLoadingSpinner()
        return true
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let result = result else {
            return
        }
        
        if result.isCancelled {
            stopLoadingSpinner()
            return
        }

        let credential = FacebookAuthProvider
            .credential(withAccessToken: AccessToken.current!.tokenString)
        
        if #available(iOS 13.0, *) {
            firebaseManager?.signIn(with: credential)
        }
        
    }
}

//MARK: - FirebaseDelegate

extension LoginViewController : FirebaseDelegate {
    func showMessagePrompt(_ message: String) {
       let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       alert.addAction(okAction)
       present(alert, animated: false, completion: nil)
     }
    
    func signInError(_ error: Error) {
        stopLoadingSpinner()
        self.showMessagePrompt(error.localizedDescription)
    }
    
    @available(iOS 13.0, *)
    func signInSuccess() {
        print("Signed in")
        
        DispatchQueue.main.async {
            self.stopLoadingSpinner()
            self.loginButton.isHidden = true
            UserDefaults.standard.setValue(K.FStore.currentUserId, forKey: "uid")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar

           // print("Flip 1", sceneDelegate)
            //sceneDelegate?.changeRootViewController(mainTabBarController)
            if let scene = UIApplication.shared.connectedScenes.first {

                if let sceneDelegate = scene.delegate as? SceneDelegate {
                    print("Flip 1", sceneDelegate)
                    sceneDelegate.changeRootViewController(mainTabBarController)
                }else{
                    print("sceneDelegate is nil")
                }
               
                
            }
        }
    }
    
    
    
    
    
    
}
