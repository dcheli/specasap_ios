//
//  SearchViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 11/13/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//


import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var criteriaLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    let urlElements = "https://dataasap.com/specasap/webapi/v1/elements/"
    var urlElementsString = ""
    var version = ""
    
    var searchResults = [AnyObject]() // this was cast as NCPDPElement
    let defaultSession  = URLSessionConfiguration.default
    
    var dataTask : URLSessionDataTask?
    
    

    @IBAction func standardSegmentedControl(_ sender: Any) {
/*
        for product in AppDelegate.products {
            
            if product.productId == "com.dataasap.ncpdpasap" {
                print("Product id is \(product.productId!) and active is \(product.active)")
                segmentedControl.setEnabled(product.active, forSegmentAt: 0)
            }
            else if product.productId == "com.dataasap.hl7asap" {
                print("Product id is \(product.productId!) and active is \(product.active)")
                segmentedControl.setEnabled(product.active, forSegmentAt: 1)
            }
            else if product.productId == "com.dataasap.x12asap" {
                print("Product id is \(product.productId!) and active is \(product.active)")
                segmentedControl.setEnabled(product.active, forSegmentAt: 2)
            }
        }
  */
        switch segmentedControl.selectedSegmentIndex {
        case 0: // NCPDP D.0
            self.urlElementsString = urlElements + "ncpdp/"
            self.version = "D0"
            break
        case 1: // HL7 2.8.2
            self.urlElementsString = urlElements + "hl7/"
            self.version = "282"
            break
        case 2: // X12 v5010
            self.urlElementsString = urlElements + "x12/"
            self.version = "5010"
            break
        default:
            break
        }
    }
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(SearchViewController.dismissKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
     }
    
    // this is activated when you move to this screen, via the Home Screen; fyi after viewDidAppear is called, didMove toParentViewControlelr is called

    override func viewDidAppear(_ animated: Bool) {
        print("SeachViewController, viewDidAppear")
        var segmentSelected : Bool = false
        //here is where you need to somehow call the function that enables the segmented controls
        if AppDelegate.products.count == 0 {
            sleep(3)
        }
        print("SearchViewController product is \(AppDelegate.products)")
        for product in AppDelegate.products {
            
            if product.productId == "com.dataasap.ncpdpasap" {
                segmentedControl.setEnabled(product.active, forSegmentAt: 0)
                if product.active && !segmentSelected {
                    segmentedControl.selectedSegmentIndex = 0
                    self.urlElementsString = urlElements + "ncpdp/"
                    self.version = "D0"
                    segmentSelected = true
                }

   
            }
            else if product.productId == "com.dataasap.hl7asap" {
                segmentedControl.setEnabled(product.active, forSegmentAt: 1)
                if product.active && !segmentSelected {
                    segmentedControl.selectedSegmentIndex = 1
                    self.urlElementsString = urlElements + "hl7/"
                    self.version = "282"
                    segmentSelected = true
                }

            }
            else if product.productId == "com.dataasap.x12asap" {
                segmentedControl.setEnabled(product.active, forSegmentAt: 2)
                if product.active && !segmentSelected {
                    segmentedControl.selectedSegmentIndex = 2
                    self.urlElementsString = urlElements + "x12/"
                    self.version = "5010"
                    segmentSelected = true
                }

            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        
        if(segue.identifier == "attributes") {
            let destination = segue.destination as! DetailViewController
            if searchResults[indexPath!.row] is NCPDPElement {
                destination.element = searchResults[indexPath!.row] as! NCPDPElement
            } else if searchResults[indexPath!.row] is X12Element {
                destination.element = searchResults[indexPath!.row] as! X12Element
            } else if searchResults[indexPath!.row] is HL7Element {
                destination.element = searchResults[indexPath!.row] as! HL7Element
            }
            
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        if(!searchBar.text!.isEmpty) {
            if(dataTask != nil) {
                dataTask?.cancel()
            }
        }

        let expectedCharSet = CharacterSet.urlQueryAllowed
        let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            searchResults.removeAll()
            let urlString =  urlElementsString + searchTerm! + "?v=" + version
            let ncpdpElementParser  = NCPDPElementParser(fromUrl : urlString)
            ncpdpElementParser.getNCPDPSpec(urlString: urlString) {
                (result : [NCPDPElement]) in
                if result.isEmpty{
                    let alertController = UIAlertController(title: "Alert", message: "No matching data elements were found", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    for item in result {
                        self.searchResults.append(item)
                    }
            
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                }
            }
      
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            searchResults.removeAll()

            let urlString =  urlElementsString + searchTerm! + "?v=" + version
            let hL7ElementParser  = HL7ElementParser(fromUrl : urlString)
            hL7ElementParser.getHL7Spec(urlString: urlString) {
                (result : [HL7Element]) in
                if result.isEmpty{
                    let alertController = UIAlertController(title: "Alert", message: "No matching data elements were found", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    for item in result {
                        self.searchResults.append(item)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                }
            }

        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            searchResults.removeAll()
            let urlString =  urlElementsString + searchTerm! + "?v=" + version
            let x12ElementParser  = X12ElementParser(fromUrl : urlString)
            x12ElementParser.getX12Spec(urlString: urlString) {
                (result : [X12Element]) in
                if result.isEmpty{
                    let alertController = UIAlertController(title: "Alert", message: "No matching data elements were found", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    for item in result {
                        self.searchResults.append(item)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                }
                
            }
            
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ElementCell", for: indexPath) as! ElementCell
        
        if searchResults[indexPath.row] is NCPDPElement {
            let element = searchResults[indexPath.row] as? NCPDPElement
            cell.elementId.text = element?.elementId
            cell.elementName.text = element?.elementName

        } else if searchResults[indexPath.row] is X12Element {
            let element = searchResults[indexPath.row] as? X12Element
            cell.elementId.text = element?.elementId
            cell.elementName.text = element?.implementationName!

        } else if searchResults[indexPath.row] is HL7Element {
            let element = searchResults[indexPath.row] as? HL7Element
            cell.elementId.text = element?.elementId
            cell.elementName.text = element?.elementName!

        }
  
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
}

