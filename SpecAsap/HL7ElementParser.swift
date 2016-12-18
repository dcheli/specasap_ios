//
//  HL7ElementParser.swift
//  SpecAsap
//
//  Created by David Cheli on 12/15/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation

class HL7ElementParser {
    
    var urlString : String?
    
    init(fromUrl urlString : String) {
        self.urlString = urlString
        print (self.urlString!)
    }
    
    func getHL7Spec(urlString: String, completion : @escaping (_ result : [HL7Element]) -> Void) {
        
        let defaultSession  = URLSessionConfiguration.default
        var dataTask : URLSessionDataTask?
        var searchResults = [HL7Element]()
        
        let url = URL(string: self.urlString!)
        
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
                    print("HttpResponse is \(httpResponse.statusCode)")
                    
                    do {
                        let jsonDict  = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as AnyObject
                        if(jsonDict.count > 0) {
                            if let json = jsonDict as? [[String: AnyObject]] {
                                for item in json {
                                    print("Item is: \(item)")
                                    
                                    let elementId  = item["elementId"] as? String ?? ""
                                    let segmentId = item["segmentId"] as? String ?? ""
                                    let segmentName = item["segmentName"] as? String ?? ""
                                    let elementName = item["elementName"] as? String ?? ""
                                    let sequence = item["sequence"] as? Int ?? 0
                                    let length = item["length"] as? String ?? ""
                                    let conformanceLength = item["conformanceLength"] as? String ?? ""
                                    let dataType = item["dataType"] as? String ?? ""
                                    let optionality = item["optionality"] as? String ?? ""
                                    let repetition = item["repetition"] as? String ?? ""
                                    let tableNumber = item["elementRepeat"] as? String ?? ""
                                    let itemNumber = item ["itemNumber"] as? String ?? ""
                                    let definition = item["definition"] as? String ?? ""
                                    
                                    let transactions = item["transactions"] as? [String] ?? []
                                    let versions = item["versions"] as? [String] ?? []
                                    
                                    searchResults.append(HL7Element(elementId: elementId, segmentId: segmentId, segmentName: segmentName, elementName: elementName, sequence: sequence, length : length, conformanceLength : conformanceLength,dataType : dataType, optionality : optionality, repetition : repetition, tableNumber : tableNumber, itemNumber : itemNumber, transactions : transactions, versions : versions, definition : definition))
                                }
                            }
                            
                        } else {
                            print("JSON Error or nothing was found")
                            let alertController = UIAlertController(title: "Alert", message: "Nothing was found", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss:", style: UIAlertActionStyle.default, handler: nil))
                            //      self.present(alertController, animated: true, completion: nil)
                        }
                        
                    } catch  {
                        print("Do better error handling here")
                    }
                    // I think what is going to happen is that a call will be made here to return the array
                    //and I think I want to do something like the below, but hand over the parsed array
                    // maybe the getHL should provide a completion handler?
                    completion(searchResults)
                    
                    // self.updateSearchResults(data as Data?)
                } else {
                    var alertString = ""
                    if(httpResponse.statusCode == 404) {
                        print("Just not found")
                        alertString = "No records were found."
                    } else {
                        alertString = "An error occured and Support as been notified.\n Please try again later."
                    }
                    let alertController = UIAlertController(title: "", message: alertString, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    //   self.present(alertController, animated: true, completion: nil)
                    
                    print("HttpResponse is \(httpResponse.statusCode)")
                }
            }
        }
        dataTask?.resume()
        
    }

    
}
