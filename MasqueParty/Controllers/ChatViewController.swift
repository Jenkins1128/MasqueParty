//
//  ChatViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/20/21.
//  Copyright © 2021 MasqueParty. All rights reserved.
//

import UIKit
import FBSDKShareKit

class ChatViewController : UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        openChat()
    }
}

// MARK: - SharingDelegate

extension ChatViewController : SharingDelegate {
    func openChat() {
        guard let image = UIImage(named: "MasqueParty") else {
            return
        }

        let photo = SharePhoto(image: image, userGenerated: true)
        let content = SharePhotoContent()
                content.photos = [photo]

        let dialog = MessageDialog(content: content, delegate: self)

        // Recommended to validate before trying to display the dialog
        do {
            try dialog.validate()
        } catch {
            print(error)
        }

        dialog.show()
    }
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        errorLabel.text = "Please check that you have Facebook Messenger installed or your internet."
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        
    }
}
