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
    let baseURL = "https://dataasap.com/specasap/webapi/v1/"
    var elementsURL = ""
    var codesURL  = ""
    var urlString = ""
    var version = ""
    var selectedStandard  = ""
    var searchDomain  = ""
    var standardsDomain = ""
    var queryURL = ""
    
    var searchResults = [AnyObject]()
    
  
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(SearchViewController.dismissKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = selectedStandard
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
   
        
        // this is the default when entering this screen
        urlString = elementsURL
        
        
        switch selectedStandard {
            case "NCPDP D.0":
                self.standardsDomain = "ncpdpvD0"
                self.elementsURL = baseURL + "elements/ncpdp/"
                self.codesURL = baseURL + "codes/ncpdp/"
                self.version = "D0"
            case "X12 5010" :
                self.standardsDomain = "x12v5010"
                self.elementsURL = baseURL + "elements/x12/"
                self.codesURL = baseURL + "codes/x12/"
                self.version = "5010"
            case "HL7 v2":
                self.standardsDomain = "hl7v2"
                self.elementsURL = baseURL + "elements/hl7/"
                self.codesURL = baseURL + "codes/hl7/"
                self.version = "282"
            default:
                self.urlString +=  ""
                self.version = ""
        }
        // This is the default url
        self.queryURL = self.elementsURL
     }
    
    // this is activated when you move to this screen, via the Home Screen; fyi after viewDidAppear is called, didMove toParentViewControlelr is called

    override func viewDidAppear(_ animated: Bool) {
       

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

        let expectedCharSet = CharacterSet.urlQueryAllowed
        let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        searchResults.removeAll()
        self.queryURL = elementsURL +  searchTerm! + "?v=" + version
        
        if self.standardsDomain == "ncpdpvD0" {
            let ncpdpElementParser  = NCPDPElementParser(fromUrl : self.queryURL)
            ncpdpElementParser.getNCPDPSpec(urlString: self.queryURL) {
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
      
        } else if self.standardsDomain == "hl7v2" {

            let hL7ElementParser  = HL7ElementParser(fromUrl : self.queryURL)
            hL7ElementParser.getHL7Spec(urlString: self.queryURL) {
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

        } else if self.standardsDomain == "x12v5010" {
    //else if self.selector.selectedSegmentIndex == 2 {
            let x12ElementParser  = X12ElementParser(fromUrl : self.queryURL)
            x12ElementParser.getX12Spec(urlString: self.queryURL) {
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
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
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

