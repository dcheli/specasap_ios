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
        // set as a default for the moment
        self.urlElementsString = urlElements + "ncpdp/"
        self.version = "D0"
    
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//    func updateSearchResults(_ data: Data?) {
  //      searchResults.removeAll()

    //    do {
      //      let jsonDict  = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as AnyObject
        
 //           if(jsonDict.count > 0) {
   //             if let json = jsonDict as? [[String: AnyObject]] {
     //               for item in json {

       //                 let elementId  = item["elementId"] as? String ?? ""
         //               let segmentId = item["segmentId"] as? String ?? ""
           //             let segmentName = item["segmentName"] as? String ?? ""
             //           let elementName = item["elementName"] as? String ?? ""
               //         let definition = item["definition"] as? String ?? ""
                        
                 //       let codes = item["codes"] as? [String] ?? []
                        
                   //     let standardFormats = item["standardFormats"] as? [String] ?? []
                     //   let lengths = item["lengths"] as? [String] ?? []
                       // let transactions = item["transactions"] as? [String] ?? []
//                        let versions = item["versions"] as? [String] ?? []
  //
    //                    searchResults.append(NCPDPElement(elementId : elementId, elementName: elementName,
      //                                                  definition: definition, segmentId: segmentId, segmentName: segmentName,
        //                                                standardFormats : standardFormats, lengths: lengths, transactions : transactions,
          //                                              versions : versions, codes : codes))
            //        }
              //  }
                
//            } else {
  //              print("JSON Error or nothing was found")
    //           let alertController = UIAlertController(title: "Alert", message: "Nothing was found", preferredStyle: UIAlertControllerStyle.alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss:", style: UIAlertActionStyle.default, handler: nil))
  //              self.present(alertController, animated: true, completion: nil)
    //        }
            
  //      } catch  {
    //        print("Do better error handling here")
      //  }
        
        
//         DispatchQueue.main.async {
  //       self.tableView.reloadData()
    //     self.tableView.setContentOffset(CGPoint.zero, animated: false)
      //   }
         
 
 //   }
 
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
            print("ElementID is \(element?.elementId)")
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

