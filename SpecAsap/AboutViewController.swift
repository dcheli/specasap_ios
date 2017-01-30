//
//  AboutViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 11/13/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //let defaultSession  = URLSessionConfiguration.default
    //var dataTask : URLSessionDataTask?

    
    @IBOutlet weak var tableView: UITableView!
    
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
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingsMenu().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let items = self.settingsMenu()[indexPath.section]
        let menuItem = items[indexPath.row]
        cell.textLabel?.text = menuItem
        //cell.textLabel?.text = firstSection[indexPath.row]
        return cell
    }
    //func tableView(_ tableView : UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            self.performSegue(withIdentifier: "aboutus", sender: nil)
            break
        case 1:
           self.performSegue(withIdentifier: "storefront", sender: nil)
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
 
    }
    // this is temporary in that it only provides product feedback to me in the AboutViewController
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let indexPath = self.tableView.indexPathForSelectedRow
 
        let items = self.settingsMenu()[indexPath!.section]
        let menuItem = items[indexPath!.row]
        
        if(segue.identifier == "aboutus"){
            let destination = segue.destination as! AboutDetailsViewController
            destination.pageTitle = menuItem
        } else {
            segue.destination as! StoreTableViewController
        }
    }
    
    func restorePurchases() {
        IAPManager.sharedInstance.restoreTransactions()
    }
}





