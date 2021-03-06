//
//  LoginViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 7/29/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    private var loginButton = FBLoginButton()
    private var firebaseManager : FirebaseManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirebaseManager()
        configureDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        showLoginButton()
        showLoadingSpinner(false)
        loginButton.center = self.view.center
        loginButton.permissions = ["public_profile", "user_friends"]
        view.addSubview(self.loginButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func configureFirebaseManager() {
        firebaseManager = FirebaseManager()
    }
    
    func configureDelegates() {
        loginButton.delegate = self
        firebaseManager?.delegate = self
    }
    
    func showLoginButton(_ show: Bool = true) {
        loginButton.isHidden = !show
    }
    
    func showLoadingSpinner(_ show: Bool = true){
        loadingSpinner.isHidden = !show
    }
    
    func startLoadingSpinner() {
        showLoadingSpinner()
        loadingSpinner.startAnimating()
    }
    
    func stopLoadingSpinner() {
        loadingSpinner.stopAnimating()
        showLoadingSpinner(false)
    }
    
    @available(iOS 13.0, *)
    func goTo(_ storyboardId: String){
        let storyboard = UIStoryboard(name: K.mainStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: storyboardId)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(controller)
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
        guard error == nil,
              let result = result else {
            print(error!.localizedDescription)
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
        
        showLoginButton(false)
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
        showLoginButton()
        showMessagePrompt(error.localizedDescription)
    }
    
    @available(iOS 13.0, *)
    func signInSuccess() {
        DispatchQueue.main.async {
            self.stopLoadingSpinner()
            UserDefaults.standard.setValue(K.FStore.currentUserId, forKey: "uid")
            self.goTo("MainTabBarController")
        }
    }
}
