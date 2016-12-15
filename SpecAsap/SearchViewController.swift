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
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var ncpdpButton: UIButton!
    @IBOutlet weak var x12Button: UIButton!
    @IBOutlet weak var hl7Button: UIButton!

    let urlElements = "https://dataasap.com/specasap/webapi/v1/elements/"
    var urlElementsString = ""
    
    var searchResults = [AnyObject]() // this was cast as NCPDPElement
    let defaultSession  = URLSessionConfiguration.default
    
    var dataTask : URLSessionDataTask?
    
    @IBAction func ncpdpButtonPressed(_ sender: UIButton) {
        ncpdpButton.isSelected = true
        x12Button.isSelected = false
        hl7Button.isSelected = false
        
        ncpdpButton.setTitle("NCPDP", for: .selected)
        //ncpdpButton.setTitle("✔︎NCPDP", for: .normal)
        x12Button.setTitle("X12", for: .normal)
        hl7Button.setTitle("HL7", for: .normal)
        self.urlElementsString = urlElements + "ncpdp/"

    }
    
    @IBAction func x12ButtonPressed(_ sender: UIButton) {
        ncpdpButton.isSelected = false
        x12Button.isSelected = true
        hl7Button.isSelected = false
        
        ncpdpButton.setTitle("NCPDP", for: .normal)
        x12Button.setTitle("X12", for: .selected)
        hl7Button.setTitle("HL7", for: .normal)

        self.urlElementsString = urlElements + "x12/"
        
    }
    
    @IBAction func hl7ButtonPressed(_ sender: UIButton) {
        ncpdpButton.isSelected = false
        x12Button.isSelected = false
        hl7Button.isSelected = true
        
        ncpdpButton.setTitle("NCPDP", for: .normal)
        x12Button.setTitle("X12", for: .normal)
        hl7Button.setTitle("HL7", for: .selected)
        
        self.urlElementsString = urlElements + "hl7/"
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
        self.ncpdpButton.setTitleColor(UIColor.blue, for: .normal)
        self.ncpdpButton.sendActions(for: .touchUpInside)
        self.x12Button.setTitleColor(UIColor.blue, for: .normal)
        self.hl7Button.setTitleColor(UIColor.blue, for: .normal)
      //  groupingLabel.layer.borderColor = UIColor.gray.cgColor
       // groupingLabel.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateSearchResults(_ data: Data?) {
        searchResults.removeAll()

        do {
            let jsonDict  = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as AnyObject
            if(jsonDict.count > 0) {
                if let json = jsonDict as? [[String: AnyObject]] {
                    for item in json {
                        let elementId  = item["name"] as? String ?? ""
                        let elementName = item["elementName"] as? String ?? ""
                        let segmentId = item["segmentId"] as? String ?? ""
                        let segmentName = item["segmentName"] as? String ?? ""
                        let definition = item["definition"] as? String ?? ""
                        
                        let codes = item["codes"] as? [String] ?? []

                        let standardFormats = item["standardFormats"] as? [String] ?? []
                        let lengths = item["lengths"] as? [String] ?? []
                        let transactions = item["transactions"] as? [String] ?? []
                        let versions = item["versions"] as? [String] ?? []
                        
                        searchResults.append(NCPDPElement(elementId: elementId, elementName: elementName,
                                                definition: definition, segmentId: segmentId, segmentName: segmentName,
                                                standardFormats : standardFormats, lengths: lengths, transactions : transactions,
                                                versions : versions, codes : codes))
                    }
                }
                
            } else {
                print("JSON Error or nothing was found")
               let alertController = UIAlertController(title: "Alert", message: "Nothing was found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss:", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)                
            }
            
        } catch  {
            print("Do better error handling here")
        }
        
        
         DispatchQueue.main.async {
         self.tableView.reloadData()
         self.tableView.setContentOffset(CGPoint.zero, animated: false)
         }
         
 
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        
        if(segue.identifier == "attributes") {
            let destination = segue.destination as! DetailViewController
            destination.element = searchResults[indexPath!.row] as! NCPDPElement
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
        print("something is pressed")
        if self.ncpdpButton.isSelected {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
            let expectedCharSet = CharacterSet.urlQueryAllowed
            let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)
            let urlString =  urlElementsString + searchTerm! + "?v=D0"
            //let urlString = "https://dataasap.com/specasap/webapi/v1/elements/ncpdp/" + searchTerm! + "?v=D0"
            print ("URL String is \(urlString)")
            let url = URL(string: urlString)
        
            print ("URL is \(url)")
        
            let request = NSMutableURLRequest(url:url! as URL)
            request.httpMethod = "GET"
            let username = "dcheli"
            let password = "aside555"
            let loginString = NSString(format: "%@:%@", username, password)
            let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)! as Data
            let base64LoginString = loginData.base64EncodedString(options: Data.Base64EncodingOptions())
            request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        
            let session = URLSession(configuration: defaultSession)
            dataTask = session.dataTask(with: request as URLRequest){
                data, response, error in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if(httpResponse.statusCode == 200) {
                        self.updateSearchResults(data as Data?)
                    } else {
                        var alertString = ""
                        if(httpResponse.statusCode == 404) {
                            alertString = "No records were found."
                        } else {
                            alertString = "An error occured and Support as been notified.\n Please try again later."
                        }
                        let alertController = UIAlertController(title: "", message: alertString, preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)

                        print("HttpResponse is \(httpResponse.statusCode)")
                    }
                }
            }
            dataTask?.resume()
        } else if x12Button.isSelected {
            print(urlElementsString)
        } else if hl7Button.isSelected {
            print (urlElementsString)
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
        let element = searchResults[indexPath.row] as? NCPDPElement
        
        cell.elementId.text = element?.elementId
        cell.elementName.text = element?.elementName
        
        
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

