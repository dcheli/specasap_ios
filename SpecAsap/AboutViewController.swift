//
//  AboutViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 11/13/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController : UIViewController, UITableViewDataSource {
    
    let defaultSession  = URLSessionConfiguration.default
    var dataTask : URLSessionDataTask?

    
    @IBOutlet weak var tableView: UITableView!
    let items = [
        ("Privacy Policy"),
        ("Terms Of Service"),
        ("Contact Us"),
        ("Rate Us")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
 
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 //       UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var urlString = ""
        
        let indexPath = self.tableView.indexPathForSelectedRow
        var responseData :  Data?
        
        
        if(segue.identifier == "aboutUs") {
            if items[indexPath!.row] == "Privacy Policy" {
                urlString = "https://dataasap.com/specasap/webapi/privacypolicy"
                print("Privay Policy was selected")
            } else if items[indexPath!.row] == "Terms Of Service" {
                urlString = "https://dataasap.com/specasap/webapi/termsofservice"
                print ("Terms of Service was Selected")
            } else if items[indexPath!.row] == "Contact Us" {
                print("Contact Us was selected")
            }
        }
         let destination = segue.destination as! AboutDetailsViewController
        destination.pageTitle = items[indexPath!.row]

    }
}





