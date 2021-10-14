//
//  SceneDelegate.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/13/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        print("hi")
        
        // add these lines
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // if user is logged in before
        if let _ = UserDefaults.standard.string(forKey: "uid") {
            // instantiate the main tab bar controller and set it as root view controller
            // using the storyboard identifier we set earlier
            print("SIGNED IN")
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            window?.rootViewController = mainTabBarController
        } else {
            // if user isn't logged in
            // instantiate the navigation controller and set it as root view controller
            // using the storyboard identifier we set earlier
            print("NOT SIGNED IN")
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginViewController")
            window?.rootViewController = loginNavController
        }
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        print("FLIP FLIP")
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        window.rootViewController = vc
        
        // add animation
        UIView.transition(with: window,
                              duration: 0.5,
                              options: [.transitionFlipFromLeft],
                              animations: nil,
                              completion: nil)
    }
}
