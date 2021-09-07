//
//  SearchTableViewController.swift
//  MasqueParty
//
//  Created by Isaiah Jenkins on 8/16/16.
//  Copyright © 2016 MasqueParty. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchTableViewController: UITableViewController {
    var databaseRef = FIRDatabase.database().reference()
    var usersDict = NSDictionary?()
    
    var userNames = [people]()
    var userFrom = [String]()
    var userImages = [String]()
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    var filteredNames = [people]()
    
    func filterContentForSearchText(searchText:String, scope: String = "All"){
        filteredNames = userNames.filter{ people in
            //below is where you will put user.name
            return people.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        self.databaseRef.child("user_profile").observeEventType(.Value, withBlock: { (snapshot) in
            self.usersDict = snapshot.value as? NSDictionary
            
            for (_ , details) in self.usersDict!{
                let newPeople : people = people(name:((details.objectForKey("name")) as? String)!, from: ((details.objectForKey("from")) as? String)!, image: ((details.objectForKey("profilePic")) as? String)!)
                self.userNames.append(newPeople)

               
               
            }
            
                
            
            self.searchController.searchResultsUpdater = self
            self.searchController.dimsBackgroundDuringPresentation = false
            self.definesPresentationContext = true
            self.tableView.tableHeaderView = self.searchController.searchBar
            
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredNames.count
        }
        return userNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let People: people
      
        if searchController.active && searchController.searchBar.text != "" {
            People = filteredNames[indexPath.row]
        }else{
            People = userNames[indexPath.row]
        }
        
        cell.textLabel!.text = People.name
        cell.detailTextLabel?.text = People.from

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


override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let nameDetail : people
            if searchController.active && searchController.searchBar.text != "" {
               nameDetail = filteredNames[indexPath.row]
            }else{
               nameDetail = userNames[indexPath.row]
            }
            
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            controller.nameDetail = nameDetail
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}
}

extension SearchTableViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
}
