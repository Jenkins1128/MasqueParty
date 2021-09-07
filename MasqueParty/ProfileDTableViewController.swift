//
//  ProfileDTableViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class ProfileDTableViewController: UITableViewController, CLLocationManagerDelegate {
     var about = ["Favorite Food(s)", "Zodiac Sign", "Greatest Strengths", "Things you want to improve on in life", "Where do you see yourself in 5 years?"]

    
    @IBAction func previo(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileC")
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func next(sender: AnyObject) {
        var index = 0
        while index<about.count {
            
            let indexPath =  NSIndexPath(row: index, section: 0)
            let cell: TextInputDTableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputDTableView?
            let item = (cell?.myTextDField.text!)!
            if cell?.myTextDField.text != "" || cell?.myTextDField.text == ""{
                
                
                
                switch about[index]{
                case "Favorite Food(s)":
                    self.ref.child("user_profile").child("\(user!.uid)/foods").setValue(item)
                case "Zodiac Sign":
                    self.ref.child("user_profile").child("\(user!.uid)/zodiac").setValue(item)
                case "Greatest Strengths":
                    self.ref.child("user_profile").child("\(user!.uid)/strengths").setValue(item)
                case "Things you want to improve on in life":
                    self.ref.child("user_profile").child("\(user!.uid)/improve").setValue(item)
                case "Where do you see yourself in 5 years?":
                    self.ref.child("user_profile").child("\(user!.uid)/years").setValue(item)
                        
                        default:
                        print("Don't Update")
                    
                    
                }
            }
            index+=1
        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileE")
        self.present(viewController, animated: true, completion: nil)

        
    }
    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0)
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
            self.ref.child("user_profile").child("\(self.user!.uid)/postalCity").removeValue()
        }

        _ = self.ref.child("user_profile").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            let nothin = snapshot.value
            if nothin != nil{
                let usersDict = snapshot.value as! NSDictionary
               
                
                
                let userDetails = usersDict.object(forKey: self.user!.uid)
                
                var index = 0
                
                
                while index<self.about.count{
                    
                    let indexPath = NSIndexPath(row:index, section:0)
                    let cell: TextInputDTableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputDTableView?
                    
                    let field: String = ((cell?.myTextDField.placeholder!.lowercased)!)()
                    switch field{
                    case "favorite food(s)":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "foods") as? String, placeholder: "Favorite Food(s)")
//                        cell?.configure(text: (userDetails as AnyObject).object("foods") as? String, placeholder: "Favorite Food(s)")
                    case "zodiac sign":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "zodiac") as? String, placeholder: "Zodiac Sign")
//                        cell?.configure(text: (userDetails as AnyObject).object("zodiac") as? String, placeholder: "Zodiac Sign")
                    case "greatest strengths":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "strengths") as? String, placeholder: "Greatest Strengths")
//                        cell?.configure(text: (userDetails as AnyObject).object("strengths") as? String, placeholder: "Greatest Strengths")
                    case "things you want to improve on in life":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "improve") as? String, placeholder: "Things you want to improve on in life")
//                        cell?.configure(text: (userDetails as AnyObject).object("improve") as? String, placeholder: "Things you want to improve on in life")
                    case "where do you see yourself in 5 years?":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "years") as? String, placeholder: "Where do you see yourself in 5 years?")
//                        cell?.configure(text: (userDetails as AnyObject).object("years") as? String, placeholder: "Where do you see yourself in 5 years?")
                        
                        
                        
                    default:
                        print("shit")
                        
                        
                        
                    }
                    index+=1
                }
                
            }else{
                
                
            }
        })
        
        
        self.tableView.separatorStyle = .none

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return about.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TextInputDTableView = tableView.dequeueReusableCell(withIdentifier: "TextInput", for: indexPath as IndexPath) as! TextInputDTableView
        cell.configure(text: "", placeholder: "\(about[indexPath.row])")
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
