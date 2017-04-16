//
//  AboutTableViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 3/15/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    var vcIdentities = [String]()
    
    func settingsMenu() -> [[String]] {
        let firstSection = [
            ("Privacy Policy"),
            ("Terms Of Service"),
            ("Contact Us"),
            ("Rate Us")
        ]
        
        let secondSection = [
            ("Add On Store")
        ]
        // UNREMARK OUT THIS CODE WHEN U R READY
        if UserDefaults.standard.bool(forKey: "IAPCapable") {
            return [firstSection, secondSection]
        } else {
            return[firstSection]
        }
        
    }
    
    
    @IBOutlet weak var home: UIBarButtonItem!
    
    @IBAction func homePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //not sure whhat this is
  //  @IBAction func homeButtonTapped(_ sender: Any) {
  //      self.dismiss(animated: true, completion: nil)
  //  }

    override func viewDidLoad() {
        super.viewDidLoad()
        vcIdentities = ["aboutUs", "addOnStore"]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingsMenu().count
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsMenu()[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutUsCell", for: indexPath)
        
        let items = self.settingsMenu()[indexPath.section]
        let menuItem = items[indexPath.row]
        cell.textLabel?.text = menuItem
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1:
            return self.isProductActive()
        default:
            return ""
        }
        
    }
    
    func isProductActive()  -> String {
        var enabledProducts = ""
        for product in AppDelegate.products {
            if product.active == true {
                enabledProducts += "\(product.productId!) is \(product.active)\n"
            }
            else {
                enabledProducts += "\(product.productId!) is \(product.active)\n"
            }
        }
        
        return enabledProducts
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 1:
                self.performSegue(withIdentifier: "addOnStore", sender: nil)
                break
            default:
                self.performSegue(withIdentifier: "aboutUsDetails", sender: nil)
        }
    }
 
    func restorePurchases() {
        IAPManager.sharedInstance.restoreTransactions()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        let indexPath = self.tableView.indexPathForSelectedRow
        let items = self.settingsMenu()[indexPath!.section]
        let menuItem = items[indexPath!.row]
        
        switch indexPath!.section {
        case 0:
            if let destination = segue.destination as? AboutDetailsViewController {
                destination.pageTitle = menuItem
            }
            break
        case 1:
            
            segue.destination as? StoreTableViewController
            break
        default:
                break
        }
    }

}
