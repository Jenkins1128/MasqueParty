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
    var handle : AuthStateDidChangeListenerHandle?
    var loginButton = FBLoginButton()
    
    @IBOutlet var loadingspinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.delegate = self
        loginButton.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                //next screen
                //                let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                //                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeView")
                //                self.present(homeViewController, animated: true, completion: nil)
                
                print("signed in")
                
            } else {
                // No user is signed in.
                //show log in button
                self.loginButton.isHidden = false
                self.loginButton.center = self.view.center
                self.loginButton.permissions = ["public_profile", "email", "user_friends"]
                
                self.view!.addSubview(self.loginButton)
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
}



//MARK: - LoginButtonDelegate

extension LoginViewController : LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        loadingspinner.startAnimating()
        if let error = error {
            print(error.localizedDescription)
            loadingspinner.stopAnimating()
            return
        }
        
        let credential = FacebookAuthProvider
            .credential(withAccessToken: AccessToken.current!.tokenString)
        let firebaseManager = FirebaseManager()
        if(!firebaseManager.signIn(with: credential)){
            return
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
    
    func showTextInputPrompt(withMessage message: String,
                             completionBlock: @escaping ((Bool, String?) -> Void)) {
      let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        completionBlock(false, nil)
      }
      weak var weakPrompt = prompt
      let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        guard let text = weakPrompt?.textFields?.first?.text else { return }
        completionBlock(true, text)
      }
      prompt.addTextField(configurationHandler: nil)
      prompt.addAction(cancelAction)
      prompt.addAction(okAction)
      present(prompt, animated: true, completion: nil)
    }
    
    func signInError(_ error: Error) {
        let authError = error as NSError
        if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
            // The user is a multi-factor user. Second factor challenge is required.
            let resolver = authError
                .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
            var displayNameString = ""
            for tmpFactorInfo in resolver.hints {
                displayNameString += tmpFactorInfo.displayName ?? ""
                displayNameString += " "
            }
            self.showTextInputPrompt(
                withMessage: "Select factor to sign in\n\(displayNameString)",
                completionBlock: { userPressedOK, displayName in
                    var selectedHint: PhoneMultiFactorInfo?
                    for tmpFactorInfo in resolver.hints {
                        if displayName == tmpFactorInfo.displayName {
                            selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                        }
                    }
                    PhoneAuthProvider.provider()
                        .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
                                           multiFactorSession: resolver
                                            .session) { verificationID, error in
                            if error != nil {
                                print(
                                    "Multi factor start sign in failed. Error: \(error.debugDescription)"
                                )
                            } else {
                                self.showTextInputPrompt(
                                    withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
                                    completionBlock: { userPressedOK, verificationCode in
                                        let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
                                            .credential(withVerificationID: verificationID!,
                                                        verificationCode: verificationCode!)
                                        let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
                                            .assertion(with: credential!)
                                        resolver.resolveSignIn(with: assertion!) { authResult, error in
                                            if error != nil {
                                                print(
                                                    "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
                                                )
                                            } else {
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }
                                    }
                                )
                            }
                        }
                }
            )
        } else {
            self.showMessagePrompt(error.localizedDescription)
            
        }
        
    }
    
    
    
}
