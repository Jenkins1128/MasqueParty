//
//  ProfileCTableViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class ProfileCTableViewController: UITableViewController, CLLocationManagerDelegate {
    var about = ["What are you doing today to reach your goals?","Types of Music","Types of Movies or Shows","What's your greatest achievement?", "Ethnicity"]
    
    @IBAction func previous1(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileBE")
        self.present(viewController, animated: true, completion: nil)

    }
    
    @IBAction func next(sender: AnyObject) {
        var index = 0
        while index<about.count {
            
            let indexPath =  NSIndexPath(row: index, section: 0)
            let cell: TextInputCTableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputCTableView?
            let item = (cell?.myTextCField.text!)!
            if cell?.myTextCField.text != "" || cell?.myTextCField.text == ""{
                
                
                
                switch about[index]{
                case "What are you doing today to reach your goals?":
                    self.ref.child("user_profile").child("\(user!.uid)/reachgoals").setValue(item)
                case "Types of Music":
                    self.ref.child("user_profile").child("\(user!.uid)/music").setValue(item)
                case "Types of Movies or Shows":
                    self.ref.child("user_profile").child("\(user!.uid)/movies").setValue(item)
                case "What's your greatest achievement?":
                    self.ref.child("user_profile").child("\(user!.uid)/achievement").setValue(item)
                case "Ethnicity":
                    self.ref.child("user_profile").child("\(user!.uid)/ethnicity").setValue(item)
                    
                default:
                    print("Don't Update")
                    
                    
                }
            }
            index+=1
        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileD")
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
                    let cell: TextInputCTableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputCTableView?
                    let field: String = ((cell?.myTextCField.placeholder!.lowercased)!)()
//                    let field: String = (cell?.myTextCField.placeholder?.lowercased)!
                    switch field{
                    case "what are you doing today to reach your goals?":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "reachgoals") as? String, placeholder: "What are you doing today to reach your goals?")
//                        cell?.configure(text: (userDetails as AnyObject).object("reachgoals") as? String, placeholder: "What are you doing today to reach your goals?")
                    case "types of music":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "music") as? String, placeholder: "Types of Music")
//                        cell?.configure(text: (userDetails as AnyObject).object("music") as? String, placeholder: "Types of Music")
                    case "types of movies or shows":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "movies") as? String, placeholder: "Types of Movies or Shows")
//                        cell?.configure(text: (userDetails as AnyObject).object("movies") as? String, placeholder: "Types of Movies or Shows")
                    case "what's your greatest achievement?":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "achievement") as? String, placeholder: "What's your greatest achievement?")
//                        cell?.configure(text: (userDetails as AnyObject).object("achievement") as? String, placeholder: "What's your greatest achievement?")
                    case "ethnicity":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "ethnicity") as? String, placeholder: "Ethnicity")
//                        cell?.configure(text: (userDetails as AnyObject).object("ethnicity") as? String, placeholder: "Ethnicity")
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
        let cell:TextInputCTableView = tableView.dequeueReusableCell(withIdentifier: "TextInput", for: indexPath as IndexPath) as! TextInputCTableView
        
        
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
