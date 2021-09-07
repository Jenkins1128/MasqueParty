//
//  ProfileETableViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/15/16.


import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
class ProfileETableViewController: UITableViewController, CLLocationManagerDelegate {
    var about = ["Describe yourself in one word","What makes you happy?","What animal would you be? Why?"]
@IBAction func previos(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
    let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileD")
    self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func savo(sender: AnyObject) {
        var index = 0
        while index<about.count {
            
            let indexPath =  NSIndexPath(row: index, section: 0)
            let cell: TextInputETableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputETableView?
            let item = (cell?.myTextEField.text!)!
            if cell?.myTextEField.text != "" || cell?.myTextEField.text == ""{
                
                
                
                switch about[index]{
                case "Describe yourself in one word":
                    self.ref.child("user_profile").child("\(user!.uid)/oneword").setValue(item)
                case "What makes you happy?":
                    self.ref.child("user_profile").child("\(user!.uid)/happy").setValue(item)
                case "What animal would you be? Why?":
                    self.ref.child("user_profile").child("\(user!.uid)/animal").setValue(item)
                    
                default:
                    print("Don't Update")
                    
                    
                }
            }
            index+=1
        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeView")
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
                    let cell: TextInputETableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputETableView?
                    let field: String = ((cell?.myTextEField.placeholder!.lowercased)!)()
                    switch field{
                    
                    case "describe yourself in one word":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "oneword") as? String, placeholder: "Describe yourself in one word")
                        
//                        cell?.configure(userDetails?.objectForKey("oneword") as? String, placeholder: "Describe yourself in one word")
                    case "what makes you happy?":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "happy") as? String, placeholder: "What makes you happy?")
                        
//                        cell?.configure(userDetails?.objectForKey("happy") as? String, placeholder: "What makes you happy?")
                    case "what animal would you be? why?":
                        cell?.configure(text: (userDetails as AnyObject).object(forKey: "animal") as? String, placeholder: "What animal would you be? Why?")
//                        cell?.configure(userDetails?.objectForKey("animal") as? String, placeholder: "What animal would you be? Why?")
//
                        
                        
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
        let cell:TextInputETableView = tableView.dequeueReusableCell(withIdentifier: "TextInput", for: indexPath as IndexPath) as! TextInputETableView
        
        
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
