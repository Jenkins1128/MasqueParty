//
//  HomeViewController.swift
//  MasqueParty
//     var appID = "57d7908be51c4b742a00000c"
//var sdk = VungleSDK.sharedSDK()
// start vungle publisher library
//sdk.startWithAppId(appID)
//  Created by Isaiah Jenkins on 8/4/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//For the In app purchase, it's going to be .99 for 100 pts., 2.50 for 500pts, 5.00 for 1000pts
//For Guest user, if current user == nil then set current uid to masqueguest uid :) for each page that you need
import UIKit
import Firebase
import FBSDKCoreKit
import CoreLocation
import FBSDKLoginKit
import FBSDKShareKit



var checkarea = [""]
class HomeViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var Likers: UILabel!
    @IBOutlet weak var Bio: UILabel!
    @IBOutlet var pointView: UILabel!
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var pointNum: UILabel!
   
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var boost: UIButton!
    @IBAction func close(sender: AnyObject) {
        errorLabel.isHidden = true
        
        errorLabel.center = CGPoint(x: errorLabel.center.x + 120, y: errorLabel.center.y - 420)
        
        closeButton.isHidden = true
        
        closeButton.center = CGPoint(x: closeButton.center.x + 120, y: closeButton.center.y - 420)
        
    }
    @IBAction func didTapMess(sender: AnyObject) {
        let image = UIImage(named: "MasqueParty.png")!
//        FBSDKMessengerSharer.share(image, with: nil)
    }
   
    @IBAction func mula(sender: AnyObject) {
    }
    @IBAction func wazzup(sender: AnyObject) {
        if user?.email != nil{
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "wazzup")
            self.present(homeViewController, animated: true, completion: nil)
        }else{
            errorLabel.isHidden = false
            closeButton.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                self.errorLabel.center = CGPoint(x: self.errorLabel.center.x - 120, y: self.errorLabel.center.y + 420)
                
                self.closeButton.center = CGPoint(x: self.closeButton.center.x - 120, y: self.closeButton.center.y + 420)
                
            })

        }
    }
  lazy var numca = [""]

   lazy var thaCity = [""]
    @IBAction func points(sender: AnyObject) {
        if user?.email != nil {

//            ref.child("user_profile").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let numco = self.numca.first {
//
//                if var input:Int = Int(numco) {
//
//                    input += 150
//                    self.ref.child("user_profile").child("\(self.user!.uid)/points").setValue("\(input)")
//
//                }else{
//
//                }
//            }else{
//
//            }
//
//
//        })
        }else{
            errorLabel.isHidden = false
            closeButton.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                
                self.errorLabel.center = CGPoint(x: self.errorLabel.center.x - 120, y: self.errorLabel.center.y + 420)
                
                self.closeButton.center = CGPoint(x: self.closeButton.center.x - 120,y: self.closeButton.center.y + 420)
                
            })
            

        }
    }
    
    
  
    @IBAction func editYou(sender: AnyObject) {
       if user?.email != nil {
            let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileIDE")
        self.present(homeViewController, animated: true, completion: nil)
        }else{
        errorLabel.isHidden = false
        closeButton.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.errorLabel.center = CGPoint(x: self.errorLabel.center.x - 120,y: self.errorLabel.center.y + 420)
        
            self.closeButton.center = CGPoint(x: self.closeButton.center.x - 120,y: self.closeButton.center.y + 420)
            
        })
        

        }
  
    }
    
    @IBAction func biotap(sender: AnyObject) {
        if user?.email != nil{
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BIO")
            self.present(viewController, animated: true, completion: nil)
        
//        self.ref.child("user_profile").child("\(self.user!.uid)/uides").setValue(self.user!.uid)
        }else{
//            globalusers[0] = ""
        }
    }
    @IBOutlet weak var profileName: UILabel!
   
    
    @IBAction func didTapLogout(sender: AnyObject) {
     if user?.email != nil{
//       self.ref.child("user_profile").child("\(self.user!.uid)/postalCity").removeValue()
        
        try! Auth.auth().signOut()
        AccessToken.current = nil
       
        //AccessToken.setCurrent(nil)
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainView")
        self.present(viewController, animated: true, completion: nil)
        
     }else{
//        self.ref.child("user_profile").child("\("jtHIiFvY1LZgae6YquGgnAt9pfh2")/\(guestCoda[0])").removeValue()
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainView")
        self.present(viewController, animated: true, completion: nil)
        }
    }
//    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
var product_id: NSString?;
    
 var manager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy - kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        errorLabel.isHidden = true
        
        errorLabel.center = CGPoint(x: errorLabel.center.x - 500,y: errorLabel.center.y + 420)
        
        closeButton.isHidden = true
        
        closeButton.center = CGPoint(x: closeButton.center.x - 500,y: closeButton.center.y + 420)
        
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
//                self.ref.child("user_profile").child("\(self.user!.uid)/postalCity").removeValue()
            }else{
//                self.ref.child("user_profile").child("\("jtHIiFvY1LZgae6YquGgnAt9pfh2")/\(guestCoda[0])").setValue("")
            }

        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        let userIDE: String = (Auth.auth().currentUser?.uid)!
        
//        ref.child("user_profile").child(userIDE).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let value = snapshot.value as? [String: Any] {
//                let ntm = value["appendNo"] as? String
//
//                if ntm == nil || ntm == "" || ntm == "1" {
//                    self.ref.child("user_profile").child("\(userIDE)/appendNo").setValue("0")
//
//                }
//            }
//
//        })
//        ref.child("user_profile").child(userIDE).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let value = snapshot.value as? [String: Any] {
//
//                let nrm = value["appendNa"] as? String
//
//                if nrm == nil || nrm == "" || nrm == "1" {
//                    self.ref.child("user_profile").child("\(userIDE)/appendNa").setValue("0")
//
//                }
//
//            }
//
//        })

        
        
        
//        self.ref.child("user_profile").child("\(self.user!.uid)/uids").setValue(userIDE)
        
//        _ = self.ref.child("user_profile").observe(DataEventType.value, with: { (snapshot) in
//        let usersDict = snapshot.value as! NSDictionary
//
//
//            let userDetails = usersDict.object(forKey: userIDE)
//
//            let nam = (userDetails! as AnyObject).value(forKey: "views") as? String
//            let ndm = (userDetails! as AnyObject).value(forKey: "postViews") as? String
//            let nom = (userDetails! as AnyObject).value(forKey: "points") as? String
//            let place = (userDetails! as AnyObject).value(forKey: "postalCity") as? String
//
//            if nom == nil || nom == ""{
//                self.ref.child("user_profile").child("\(userIDE)/points").setValue("0")
//
//            }else{
//                self.pointNum.text = "\(numberFormatter.string(from: NSNumber(value: Int(nom!)!))!)"
//                self.numca[0] = "\(nom!)"
//            }
//            if nam == nil || nam == ""{
//                self.ref.child("user_profile").child("\(userIDE)/views").setValue("0")
//
//            }else{
//                self.pointView.text = "\(numberFormatter.string(from: NSNumber(value: Int(nam!)!))!)"
//            }
//            if place == nil || place == ""{
//                 self.ref.child("user_profile").child("\(userIDE)/postalCity").setValue(self.thaCity[0])
//
//            }
//            if ndm == nil || ndm == ""{
//                self.ref.child("user_profile").child("\(userIDE)/postViews").setValue("0")
//            }
//            })
           
        
    
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
     
        
        if let user = Auth.auth().currentUser {
            // User is signed in.
            let name = user.displayName
            _ = user.email
            _ = user.photoURL
            _ = user.uid;
           
            self.profileName.text = name
            
//            self.ref.child("user_profile").child("\(user.uid)/name").setValue(name)
          self.navigationItem.title = "#masqueparty"
         
//            self.navigationController?.navigationBar.tintColor = UIColor.yellow
            let storage = Storage.storage()
            
            let storageRef = storage.reference(forURL: "gs://masqueparty-173fe.appspot.com")
            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
            
            let profilePacRef = storageRef.child(user.uid+"/profile_pic_small.jpg")
            
            profilePicRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print("Unable to download iamge")
                } else {
                    if(data != nil || data == nil)
                    {
                        print("User already has an image, no need to download from facebook")
                        
                    }
                }
            }
            
            if(self.profilePic.image == nil || self.profilePic.image != nil){
            
                let profilePicture = GraphRequest(graphPath: "me/picture", parameters:["height":300,"width": 300, "redirect": false], httpMethod: HTTPMethod(rawValue: "Get"))
                profilePicture.start(completionHandler: {(connection, result, error) -> Void in
            
                if(error == nil){
                    
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data")
                    
                    if let urlPic = ((data as AnyObject).value(forKey: "url"))! as? String {
                    
                    if let imageData = NSData(contentsOf: NSURL(string:urlPic)! as URL){
                        
                        _ = profilePicRef.putData(imageData as Data, metadata: nil){
                            metadata,error in
                            
                            if(error == nil)
                            {
                                //size, content type or the download url
                              
                                
                                profilePicRef.downloadURL { (url, error) in
                                  guard let downloadURL = url else {
                                    // Uh-oh, an error occurred!
                                    return
                                  }
                                    _ = downloadURL.absoluteString
                                }
                            }else{
                                print("Error in downloading image")
                            }
                        }
                        self.profilePic.image = UIImage(data:imageData as Data)
                        
                        _ = profilePacRef.putData(imageData as Data, metadata: nil){
                            metadata,error in
                            
                            if(error == nil)
                            {
                                //size, content type or the download url
                                
                                profilePicRef.downloadURL { (url, error) in
                                  guard let downloadURL = url else {
                                    // Uh-oh, an error occurred!
                                    return
                                  }
//                                    self.ref.child("user_profile").child("\(user.uid)/profile_pic_small").setValue(downloadURL.absoluteString)
                                }
                             
                            }else{
                                print("Error in downloading image")
                            }
                        }
                        }
                    }
                }
                
            })
                
                
                //update small pic here
            }
            
            
        }
 
        }
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 10, animations: {
            self.views.layer.opacity = 0
            self.Likers.layer.opacity = 0
            self.Bio.layer.opacity = 0
            
        })
  
        
        
        /*
        self.boost.alpha = 0
        UIView.animateWithDuration(1.5, delay: 0.5, options: [.Repeat, .Autoreverse], animations: {() -> Void in
            self.boost.alpha = 1
            }, completion: { _ in })

      */
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        
        let userLocation:CLLocation = (locations[0] as CLLocation?)!
        
    
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                print(error!)
            } else {
               
                if let p = placemarks?[0] {
                     let theCity = p.subAdministrativeArea! //City
                     if self.user?.email != nil {
                   
                   
                        if let theName = p.name {
                        
                      
//                         self.ref.child("user_profile").child("\(self.user!.uid)/postalCity").setValue(theName)
                         checkarea[0] = "\(theName)"
                    }else{
                       
//                         self.ref.child("user_profile").child("\(self.user!.uid)/postalCity").setValue(theCity)
                        checkarea[0] = "\(String(describing: theCity))"
                    }
                     }               
                }
            }
            
            
        })
        
    }
    
}
