//
//  WazzupViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 10/7/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import CoreLocation
import FirebaseStorage
import SwiftyJSON

private let reuseIdentifier = "WazzupCollectionViewCell"
class WazzupViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {
    
    
    
    //    var databaseRef = Database.database().reference()
    var user = Auth.auth().currentUser
    
    @IBAction func postPic(sender: AnyObject) {
        //self.handleSelectProfileImageView()
        self.navigationItem.title = "Loading..."
    }
    @IBOutlet var posted: UILabel!
    @IBAction func posta(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "postView")
        self.present(homeViewController, animated: true, completion: nil)
    }
    
    
    @IBOutlet var uploaded: UILabel!
    
    @IBAction func yourPost(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "postView")
        self.present(homeViewController, animated: true, completion: nil)
        //        self.databaseRef.child("user_profile").child("\(self.user!.uid)/uides").setValue(self.user!.uid)
    }
    @IBOutlet var postNum: UILabel!
    @IBAction func Deleet(sender: AnyObject) {
        //        self.databaseRef.child("user_profile").child("\(self.user!.uid)/postViews").setValue("0")
        //        self.databaseRef.child("user_profile").child("\(self.user!.uid)/THEPOST").setValue("")
        //        self.databaseRef.child("user_profile").child("\(self.user!.uid)/picposted").setValue("")
        whatssUp.text = nil
        self.posted.isHidden = true
        self.uploaded.isHidden = true
    }
    @IBAction func thePost(sender: AnyObject) {
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
        
//        self.databaseRef.child("user_profile").child("\(self.user!.uid)/THEPOST").setValue("\(whatssUp.text!)")
//        self.databaseRef.child("user_profile").child("\(self.user!.uid)/theDate").setValue("\(timestamp)")
        posted.isHidden = false
        UIView.animate(withDuration: 7, animations: {
            self.posted.layer.opacity = 0
            
        })
        
        
    }
    @IBOutlet var whatssUp: UITextField!
    
    @IBOutlet var wazzupCollect: UICollectionView!
    @IBOutlet var friendLoader: UIActivityIndicatorView!
    
    @IBOutlet var friendz: UILabel!
    var ican:  WazzupCollectionViewCell!
    lazy var usersDxct = NSDictionary()
    lazy var userNpmesArray = [String]()
    lazy var userImpgesArray = [String]()
    lazy var userScpres = [String]()
    lazy var userViews = [String]()
    lazy var userIDSp = [String]()
    
    let limitLength = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        posted.isHidden = true
        uploaded.isHidden = true
        whatssUp.delegate = self
        wazzupCollect.dataSource = self as UICollectionViewDataSource
        self.navigationItem.title = "Wazzup"
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
            @unknown default:
                print("No access")
            }
        } else {
            print("Location services are not enabled")
            if self.user?.email != nil {
                //                self.databaseRef.child("user_profile").child("\(self.user!.uid)/postalCity").removeValue()
                
            }else{
                //                self.databaseRef.child("user_profile").child("\("jtHIiFvY1LZgae6YquGgnAt9pfh2")/\(guestCoda[0])").setValue("")            }
                
            }
            
            
            
            //        databaseRef.child("user_profile").child(self.user!.uid).observe(.value, with: {
            //            (snapshot) in
            //            if let value = snapshot.value as? [String: Any] {
            //
            //                let PostViews = value["postViews"] as? String
            //                let numberFormatter = NumberFormatter()
            //                numberFormatter.numberStyle = NumberFormatter.Style.decimal
            //                if let POST = value["THEPOST"] as? String {
            //                    self.postNum.text = "\(numberFormatter.string(from: NSNumber(value: Int(PostViews!)!))!)"
            //                    self.whatssUp.text = "\(POST)"
            //                }else{
            //                    self.whatssUp.text = ""
            //                    self.databaseRef.child("user_profile").child("\(self.user!.uid)/postViews").setValue("0")
            //                }
            //            }
            //        })
            
            self.friendLoader.startAnimating()
            let fbRequest = GraphRequest(graphPath:"/me/friends", parameters: ["fields": "name"]);
            
            fbRequest.start(completionHandler: { (connection, result, error) in
                
                
                if error == nil {
                    
                    //                if let userNameArray : NSArray = result.value(forKey: "data") as? NSArray
                    let json = JSON(result!)
                    
                    let userNameArray = json["data"].arrayValue
                    if userNameArray.count > 0
                    {
                        
                        //                    for i in i ..< userNameArray.count
                        for userArray in userNameArray {
                            
                            let fbfriends =  userArray["name"].stringValue
                            
                            
                            
                            //                        self.databaseRef.child("user_profile").observeSingleEvent(of: DataEventType.value, with :{
                            //                            (snapshot)  in
                            //
                            //                            self.usersDxct = (snapshot.value as? NSDictionary)!
                            //
                            //
                            //                            for(_,details) in self.usersDxct{
                            //                                let numberFormatter = NumberFormatter()
                            //                                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                            //                                let userDetxils = self.usersDxct.object(forKey: self.user!.uid)
                            //                                let appendNA = (userDetxils! as AnyObject).object(forKey: "appendNa") as? String
                            //                                if let name = (details as AnyObject).object(forKey: "name") as? String {
                            //                                    if let prpf = (details as AnyObject).object(forKey: "uids") as? String {
                            //
                            //                                        if name == (fbfriends )  {
                            //
                            //                                            if name != self.user?.displayName  {
                            //                                        if let postN = (details as AnyObject).object(forKey: "THEPOST") as? String {
                            //                                            if postN != "" {
                            //                                                if let nwm = (details as AnyObject).object(forKey: "points") as? String {
                            //                                                    if let nsm = (details as AnyObject).object(forKey: "views") as? String {
                            //                                                        if let lol = (details as AnyObject).value(forKey: "picposted") as? String {
                            //                                                            if let img = (details as AnyObject).object(forKey: "profile_pic_small") as? String {
                            //
                            //
                            //                                                    if let niScore = Int(nwm) {
                            //                                                        if let niView = Int(nsm) {
                            //
                            //                                                            if let nrmScores = numberFormatter.string(from: NSNumber(value: niScore)) {
                            //                                                                if let nvmViews = numberFormatter.string(from: NSNumber(value: niView)) {
                            //                                                if appendNA != "1" {
                            //                                                    print(name)
                            //                                                    print(img)
                            //                                                    print(nrmScores)
                            //                                                    print(nvmViews)
                            //                                                    print(prpf)
                            //                                                    self.userImpgesArray.append(img)
                            //                                                    self.userNpmesArray.append(name)
                            //                                                    self.userScpres.append(nrmScores)
                            //                                                    self.userViews.append(nvmViews)
                            //                                                    self.userIDSp.append("\(prpf)")
                            //                                                    self.databaseRef.child("user_profile").child("\(self.user!.uid)/appendNa").setValue("1")
                            //
                            //                                                    self.navigationItem.title = "Wazzup"
                            //
                            //                                                    if self.userNpmesArray.count > 0 {
                            //                                                    self.friendz.text = "posts from friends" + " (\(numberFormatter.string(from: NSNumber(value: self.userNpmesArray.count))!))"
                            //                                                    }else{
                            //                                                        self.friendz.text = "posts from friends" + " (0)"
                            //                                                    }
                            //
                            //                                                    self.wazzupCollect?.reloadData()
                            //                                                    self.friendLoader.stopAnimating()
                            //                                                }
                            //                                                }
                            //                                            }
                            //                                                }
                            //                                            }
                            //                                                }
                            //                                            }
                            //
                            //                                                }
                            //                                            }
                            //                                                }
                            //                                            }
                            //                                    }
                            //                                        }
                            //                                    }
                            //                                }
                            //                            }
                            //                        })
                            
                        }
                        self.friendLoader.stopAnimating()
                        self.navigationItem.title = "Wazzup"
                        self.friendz.text = "updating posts..."
                        
                    } else {
                        self.friendz.text = "posts from friends" + " (0)"
                        print("Error Getting Friends \(String(describing: error))");
                        
                    }
                }
                self.friendLoader.stopAnimating()
                
                
            })
            
            
            
            let tapRecognizer = UITapGestureRecognizer()
            tapRecognizer.numberOfTapsRequired = 1
            
            
            tapRecognizer.addTarget(self, action: #selector(self.collectionViewBackgroundTapped))
            
            
            self.wazzupCollect.addGestureRecognizer(tapRecognizer)
            
            
            // Do any additional setup after loading the view.
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
    //    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        // Return the number of items in the section
    //        // Return the number of items in a section (number of photos in an album)
    //
    //            return userNpmesArray.count
    //    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("ITEMS ",userNpmesArray.count)
        return userNpmesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ican  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! WazzupCollectionViewCell
        
        
        if let imageUrl = NSURL(string:userImpgesArray[indexPath.row]){
            
            if let imageData = NSData(contentsOf: imageUrl as URL) {
                
                
                ican.friendImg.image = UIImage(data:imageData as Data)
                ican.friendName.text = userNpmesArray[indexPath.row]
                ican.friendScore.text = userScpres[indexPath.row]
                ican.views.text = userViews[indexPath.row]
                ican.friendUi.text = userIDSp[indexPath.row]
                
                
                
                // Configure the cell
                
                
                
                
                
            }
        }
        return ican
    }
    
    
    @objc func collectionViewBackgroundTapped() {
        // Dismiss the keyboard that's shown on the device's screen
        whatssUp.resignFirstResponder()
    }
    
    
    /*
     This function allow the default tap gesture added to the collection view cell,
     an the collection view's background to to work simultaneously
     */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Perform default tap gesture
        return true
    }
    

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        print("Picking image")
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) {
            selectedImageFromPicker = editedImage
        } else if let originalImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
            selectedImageFromPicker = originalImage
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://masqueparty-173fe.appspot.com")
        let profilePicRef = storageRef.child(user!.uid+"/myPpost.png")
        if let im = selectedImageFromPicker {
            if let uploadData = im.pngData() {
                
                profilePicRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        
                        return
                    }else{
                        self.uploaded.isHidden = false
                        UIView.animate(withDuration: 7, animations: {
                            self.uploaded.layer.opacity = 0
                            
                        })
                        self.navigationItem.title = "Wazzup"
                    }
                    
                    profilePicRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            print("Uh-oh, an error occurred!")
                            return
                        }
                        //
                        //           self.databaseRef.child("user_profile").child("\(self.user!.uid)/picposted").setValue("\(downloadURL.absoluteString)")
                        print("Image picked")
                    }
                    
                })
            }
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadshit(){
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        self.navigationItem.title = "Wazzup"
        dismiss(animated: true, completion: nil)
    }
    
    
}
