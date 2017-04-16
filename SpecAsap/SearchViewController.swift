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
 
    var version = ""
    var selectedStandard  = ""
    var elementDomain  = ""
    var standardsDomain = ""
    
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
        
        switch selectedStandard {
            case "NCPDP D.0":
                self.standardsDomain = "ncpdpvD0"
                self.elementDomain = "ncpdp"
                self.version = "D0"
            case "X12 5010" :
                self.standardsDomain = "x12v5010"
                self.elementDomain = "x12"
                self.version = "5010"
            case "HL7 v2":
                self.standardsDomain = "hl7v2"
                self.elementDomain = "hl7"
                self.version = "282"
            case "CCD+" :
                self.standardsDomain = "ccdplus"
                self.elementDomain = "ccdplus"
                self.version = ""
            case "BAI" :
                self.standardsDomain = "bai"
                self.elementDomain = "bai"
                self.version = "2"

            default:
                self.version = ""
        }
     }
    
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
            let destination = segue.destination as! ElementDetailViewController
            if searchResults[indexPath!.row] is NCPDPElement {
                destination.element = searchResults[indexPath!.row] as! NCPDPElement
            } else if searchResults[indexPath!.row] is X12Element {
                destination.element = searchResults[indexPath!.row] as! X12Element
            } else if searchResults[indexPath!.row] is HL7Element {
                destination.element = searchResults[indexPath!.row] as! HL7Element
            } else if searchResults[indexPath!.row] is CCDPlusElement {
                destination.element = searchResults[indexPath!.row] as! CCDPlusElement
            } else if searchResults[indexPath!.row] is BAIElement {
                destination.element = searchResults[indexPath!.row] as! BAIElement
            }
            
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        let expectedCharSet = CharacterSet.urlQueryAllowed
        let searchParam = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        searchResults.removeAll()
        //self.queryURL = elementsURL +  searchParam! + "?v=" + version
        
        let methodStart = Date()
        
        if self.standardsDomain == "ncpdpvD0" {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkManager.sharedInstance.getElements(elementDomain: elementDomain, version: version, searchParam: searchParam!) { (responseCode, data ) -> Void in
                if responseCode == 200 {
                    let ncpdpMapper = NCPDPElementMapper()
                    let ncpdpElements = ncpdpMapper.mapNCPDPElement(fromUrl: data!)
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.searchResults = ncpdpElements
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                    
                } else {
                    var alertMessage : String
                    
                    if let code = responseCode {
                        if code == 404 {
                            alertMessage = "The requested Data Element was not found. Please check your search query. If you think this is an error, please contact us at support@dataasap.com"
                        } else {
                            alertMessage = "Error retrieving NCPDP Elements: Response Code received is \(code). Please try again or contact support@dataasap.com"
                        }
                    } else {
                        alertMessage = "Error retrieving NCPDP Elements: Response Code received is unknown. Please try again or contact support@dataasap.com"
                    }
                    let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        
        } else if self.standardsDomain == "hl7v2" {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkManager.sharedInstance.getElements(elementDomain: elementDomain, version: version, searchParam: searchParam!) { (responseCode, data ) -> Void in
                if responseCode == 200 {
                    let hl7Mapper = HL7ElementMapper()
                    let hl7Elements = hl7Mapper.mapHL7Element(fromUrl: data!)
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.searchResults = hl7Elements
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                
                } else {
                    var alertMessage : String
                    
                    if let code = responseCode {
                        if code == 404 {
                            alertMessage = "The requested Data Element was not found. Please check your search query. If you think this is an error, please contact us at support@dataasap.com"
                        } else {
                            alertMessage = "Error retrieving HL7 Elements: Response Code received is \(code). Please try again or contact support@dataasap.com"
                        }
                    } else {
                        alertMessage = "Error retrieving HL7 Elements: Response Code received is unkonwn. Please try again or contact support@dataasap.com"

                        
                    }
                    let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                   
                }
            }
            
        } else if self.standardsDomain == "x12v5010" {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            NetworkManager.sharedInstance.getElements(elementDomain: elementDomain, version: version, searchParam: searchParam!) { (responseCode, data ) -> Void in
                if responseCode == 200 {
                    let x12Mapper = X12ElementMapper()
                    let x12Elements = x12Mapper.mapX12Element(fromUrl: data!)
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.searchResults = x12Elements
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                    
                }  else {
                    var alertMessage : String
                    
                    if let code = responseCode {
                        
                        if code == 404 {
                            alertMessage = "The requested Data Element was not found. Please check your search query. If you think this is an error, please contact us at support@dataasap.com"
                        } else {
                            alertMessage = "Error retrieving X12 Elements: Response Code received is \(code). Please try again or contact support@dataasap.com"
                        }
                    } else {
                        alertMessage = "Error retrieving X12 Elements: Response Code received is unkonwn. Please try again or contact support@dataasap.com"
                        
                        
                    }
                    let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        } else if self.standardsDomain == "ccdplus" {
                    
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    
            NetworkManager.sharedInstance.getElements(elementDomain: elementDomain, version: version, searchParam: searchParam!) { (responseCode, data) -> Void in
                    if responseCode == 200 {
                        let ccdPlusMapper = CCDPlusMapper()
                        let ccdPlusElements = ccdPlusMapper.mapCCDPlusElement(fromUrl: data!)
                        print("CCDPlus \(ccdPlusElements.count)")
                    DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.searchResults = ccdPlusElements
                            self.tableView.reloadData()
                            self.tableView.setContentOffset(CGPoint.zero, animated: false)
                        }
                    } else {
                        var alertMessage : String
                        
                        if let code = responseCode {
                            
                            if code == 404 {
                                alertMessage = "The requested Data Element was not found. Please check your search query. If you think this is an error, please contact us at support@dataasap.com"
                            } else {
                                alertMessage = "Error retrieving CCDPlus Elements: Response Code received is \(code). Please try again or contact support@dataasap.com"
                            }
                        } else{
                            alertMessage = "Error retrieving CCDPlus Elements: Response Code received is unkonwn. Please try again or contact support@dataasap.com"
                            
                            
                        }
                        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                }
            }

        } else if self.standardsDomain == "bai" {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            NetworkManager.sharedInstance.getElements(elementDomain: elementDomain, version: version, searchParam: searchParam!) { (responseCode, data) -> Void in
                if responseCode == 200 {
                    let baiMapper = BAIElementMapper()
                    let baiElements = baiMapper.mapBAIElement(fromUrl: data!)
                    print("BAI \(baiElements.count)")
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.searchResults = baiElements
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    }
                } else {
                    var alertMessage : String
                    
                    if let code = responseCode {
                        
                        if code == 404 {
                            alertMessage = "The requested Data Element was not found. Please check your search query. If you think this is an error, please contact us at support@dataasap.com"
                        } else {
                            alertMessage = "Error retrieving BAI Elements: Response Code received is \(code). Please try again or contact support@dataasap.com"
                        }
                    } else{
                        alertMessage = "Error retrieving BAI Elements: Response Code received is unkonwn. Please try again or contact support@dataasap.com"
                        
                        
                    }
                    let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }

        
        }
        
        else {
            var alertMessage : String
            alertMessage = "Error retrieving Request Elements: Response Code received is unknown. Please try again or contact support@dataasap.com"

            let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
        
        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time for \(self.title!) was \(executionTime) ms")

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

        } else if searchResults[indexPath.row] is CCDPlusElement {
            let element = searchResults[indexPath.row] as? CCDPlusElement
            
            if let position = element?.elementPosition {
                cell.elementId.text = "Position \(position)"
            }
            cell.elementName.text = element?.elementName!
        } else if searchResults[indexPath.row] is BAIElement {
            let element = searchResults[indexPath.row] as? BAIElement
            
            if let position = element?.position {
                cell.elementId.text = "Position \(position)"
            }
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

