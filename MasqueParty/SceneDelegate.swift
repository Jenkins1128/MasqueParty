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
        guard let _ = (scene as? UIWindowScene) else { return }
        let storyboard = UIStoryboard(name: K.mainStoryboard, bundle: nil)
        if let _ = UserDefaults.standard.string(forKey: K.UserDefaults.uid) {
            let mainTabBarController = storyboard.instantiateViewController(identifier: K.Controllers.mainTabBar)
            window?.rootViewController = mainTabBarController
        } else {
            let loginViewController = storyboard.instantiateViewController(identifier: K.Controllers.loginView)
            window?.rootViewController = loginViewController
        }
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        window.rootViewController = vc
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: nil,
                          completion: nil)
    }
}
