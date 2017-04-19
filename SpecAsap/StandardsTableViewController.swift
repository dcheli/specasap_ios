//
//  StandardsTableViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 3/5/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import UIKit

class StandardsTableViewController: UITableViewController {
    let sectionImages : [UIImage] = [#imageLiteral(resourceName: "healthcare"), #imageLiteral(resourceName: "finance")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppDelegate.productSet.count == 0 {
            print("Count is 0")
            
            sleep(5) // this puts in a wait for the restful service
            
            if AppDelegate.productSet.count   == 0 {
                let alertMessage = "Error retrieving Standard Sets. Please try again or contact support@dataasap.com"
                let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: false, completion: nil)
            } else {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return AppDelegate.productSet.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return (AppDelegate.productSet[0].products?.count)!
            default:
                return (AppDelegate.productSet[1].products?.count)!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView()

        view.backgroundColor = UIColor(red: 0.8784, green: 0.8863, blue: 0.898, alpha: 1.0)
        let image = UIImageView(image: sectionImages[section])
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = AppDelegate.productSet[section].domain
    
        
        label.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        view.addSubview(label)
     
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardsCellIdentifier", for: indexPath)
    
        switch indexPath.section {
            case 0:
                cell.textLabel?.text = AppDelegate.productSet[0].products?[indexPath.row].displayName
            default:
                cell.textLabel?.text = AppDelegate.productSet[1].products?[indexPath.row].displayName
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
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

 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "elements" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let section = self.tableView.indexPathForSelectedRow?.section
            let destination = segue.destination as! SearchViewController
            destination.selectedStandard = (AppDelegate.productSet[section!].products?[indexPath!.row].displayName)!
        }
        
    }
}
