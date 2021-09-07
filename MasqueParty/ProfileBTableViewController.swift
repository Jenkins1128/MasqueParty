//
//  ProfileBTableViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class ProfileBTableViewController: UITableViewController, CLLocationManagerDelegate {
 

    @IBAction func previous(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileIDE")
        self.present(viewController, animated: true, completion: nil)
    }
       var about = ["Your attitude towards your life","Your motto","Relationship Status","What's your type? (In terms of who you like)","Goals & Dreams"]
    @IBAction func Save(sender: AnyObject) {
        var index = 0
        while index<about.count {
            
            let indexPath =  NSIndexPath(row: index, section: 0)
            let cell: TextInputBTableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputBTableView?
            let item = (cell?.myTextBField.text!)!
            if cell?.myTextBField.text != "" || cell?.myTextBField.text == ""{
                
                
                
                switch about[index]{
                case "Your attitude towards your life":
                    self.ref.child("user_profile").child("\(user!.uid)/attitude").setValue(item)
                case "Your motto":
                    self.ref.child("user_profile").child("\(user!.uid)/motto").setValue(item)
                case "Relationship Status":
                    self.ref.child("user_profile").child("\(user!.uid)/status").setValue(item)
                case "What's your type? (In terms of who you like)":
                    self.ref.child("user_profile").child("\(user!.uid)/type").setValue(item)
                case "Goals & Dreams":
                    self.ref.child("user_profile").child("\(user!.uid)/goals").setValue(item)
                    
                default:
                    print("Don't Update")
                    
                    
                }
            }
            index+=1
        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileC")
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
                    let cell: TextInputBTableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputBTableView?
                    let field: String = ((cell?.myTextBField.placeholder!.lowercased)!)()
                    switch field{
                    case "your attitude towards your life":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "attitude") as? String, placeholder: "Your attitude towards your life")
                        
//                        cell?.configure(text: (userDetails as AnyObject).object("attitude") as? String, placeholder: "Your attitude towards your life")
                    case "your motto":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "motto") as? String, placeholder: "Your motto")
//                        cell?.configure(text: (userDetails as AnyObject).object("motto") as? String, placeholder: "Your motto")
                    case "relationship status":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "status") as? String, placeholder: "Relationship Status")
//                        cell?.configure(text: (userDetails as AnyObject).object("status") as? String, placeholder: "Relationship Status")
                    case "what's your type? (in terms of who you like)":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "type") as? String, placeholder: "What's your type? (In terms of who you like)")
//                        cell?.configure(text: (userDetails as AnyObject).object("type") as? String, placeholder: "What's your type? (In terms of who you like)")
                    case "goals & dreams":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "goals") as? String, placeholder: "Goals & Dreams")
//                        cell?.configure(text: (userDetails as AnyObject).object("goals") as? String, placeholder: "Goals & Dreams")
                        
                        
                        
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
        let cell:TextInputBTableView = tableView.dequeueReusableCell(withIdentifier: "TextInput", for: indexPath as IndexPath) as! TextInputBTableView
        
        
        cell.configure(text: "\(about[indexPath.row])", placeholder: "\(about[indexPath.row])")


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
