//
//  CodeSetTableViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 4/4/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import UIKit

class CodeSetTableViewController: UITableViewController {
    
    var elementId : String?
    var codeSet : CodeSet = CodeSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        guard let e = elementId else {
            print("Bam.. prob dismiss the screen")
            return
        }
        
        NetworkManager.sharedInstance.getCodeSet(elementId: e) { (responseCode, data) -> Void in
            if responseCode == 200 {
             
                let codeSetParser = CodeSetParser()
                self.codeSet = codeSetParser.parseCodeSet(fromUrl: data!)!
                
                self.tableView.reloadData()
            } else {
                print("result is \(String(describing : responseCode))")
            }
        }
        
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
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.codeSet.codes?.count else {
            return 0
        }
        
        print("returning \(count)")
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CodeSetCell", for: indexPath)
        
        if let code = codeSet.codes?[indexPath.row] {
            cell.textLabel?.text = code.code
             print("desc is \(code.description!)")
            cell.detailTextLabel?.text = code.description
        }
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
