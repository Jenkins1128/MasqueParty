//
//  ProfileTableViewController.swift
//  
//
//  Created by Isaiah Jenkins on 8/7/16.

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class ProfileTableViewController: UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    var about = ["Default name","Age","Where are you from?","Your Personality","Interests","Dislikes"]

    
    @IBAction func done(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeView")
        self.present(viewController, animated: true, completion: nil)

    }
    
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
                let cell: TextInputTableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputTableView?
                let field: String = ((cell?.myTextField.placeholder!.lowercased)!)()
                switch field{
                case "default name":
                    cell?.configure(text: (userDetails as AnyObject).object(forKey: "name") as? String, placeholder: "Default name")
//                    cell?.configure(text: (userDetails as AnyObject).object("name") as? String, placeholder: "Default name")
                case "age":
                    cell?.configure(text: (userDetails as AnyObject).object(forKey: "age") as? String, placeholder: "Age")
//                    cell?.configure(text: (userDetails as AnyObject).object("age") as? String, placeholder: "Age")
                case "where are you from?":
                    cell?.configure(text: (userDetails as AnyObject).object(forKey: "from") as? String, placeholder: "Where are you from?")
//                    cell?.configure(text: (userDetails as AnyObject).object("from") as? String, placeholder: "Where are you from?")
                case "your personality":
                    cell?.configure(text: (userDetails as AnyObject).object(forKey: "personality") as? String, placeholder: "Your Personality")
//                    cell?.configure(text: (userDetails as AnyObject).object("personality") as? String, placeholder: "Your Personality")
                case "interests":
                    cell?.configure(text: (userDetails as AnyObject).object(forKey: "interests") as? String, placeholder: "Interests")
//                    cell?.configure(text: (userDetails as AnyObject).object("interests") as? String, placeholder: "Interests")
                case "dislikes":
                    cell?.configure(text: (userDetails as AnyObject).object(forKey: "dislikes") as? String, placeholder: "Dislikes")
//                    cell?.configure(text: (userDetails as AnyObject).object("dislikes") as? String, placeholder: "Dislikes")

                    
                    
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
    
    
    
    var ref = Database.database().reference()
    var user = Auth.auth().currentUser
    

    //       Update Button here

   
    @IBAction func saveContinue(sender: AnyObject) {
        var index = 0
        while index<about.count {
            
            let indexPath =  NSIndexPath(row: index, section: 0)
            let cell: TextInputTableView? = self.tableView.cellForRow(at: indexPath as IndexPath) as! TextInputTableView?
            let item = (cell?.myTextField.text!)!
            if cell?.myTextField.text != "" || cell?.myTextField.text == ""{
                
                
                
                switch about[index]{
                case "Default name":
                    self.ref.child("user_profile").child("\(user!.uid)/name").setValue(item)
                case "Age":
                    self.ref.child("user_profile").child("\(user!.uid)/age").setValue(item)
                case "Where are you from?":
                    self.ref.child("user_profile").child("\(user!.uid)/from").setValue(item)
                case "Your Personality":
                    self.ref.child("user_profile").child("\(user!.uid)/personality").setValue(item)
                case "Interests":
                    self.ref.child("user_profile").child("\(user!.uid)/interests").setValue(item)
                case "Dislikes":
                    self.ref.child("user_profile").child("\(user!.uid)/dislikes").setValue(item)
                    
                default:
                    print("Don't Update")
                    
                    
                }
            }
            index+=1
        }
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "profileBE")
        self.present(viewController, animated: true, completion: nil)
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
        
        let cell:TextInputTableView = tableView.dequeueReusableCell(withIdentifier: "TextInput", for: indexPath as IndexPath) as! TextInputTableView
        
        
        cell.configure(text: "", placeholder: "\(about[indexPath.row])")
        return cell
    }


     /*
     // Override to support conditional editing of the table view.
    
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
