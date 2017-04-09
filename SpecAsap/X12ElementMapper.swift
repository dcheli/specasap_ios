//
//  X12ElementParser.swift
//  SpecAsap
//
//  Created by David Cheli on 12/12/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation

class X12ElementMapper {
    
    var urlString : String?
    
  /*  init(fromUrl urlString : String) {
        self.urlString = urlString
        print (self.urlString!)
    }
    
    func getX12Spec(urlString: String, completion : @escaping (_ result : [X12Element]) -> Void) {
        
        let defaultSession  = URLSessionConfiguration.default
        var dataTask : URLSessionDataTask?
        var searchResults = [X12Element]()
        
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
            OperationQueue.main.addOperation {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

            }
 //           DispatchQueue.main.async {
 //               UIApplication.shared.isNetworkActivityIndicatorVisible = false
 //           }
            
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
                    
                                    let elementId  = item["elementId"] as? String ?? ""
                                    let elementName = item["elementName"] as? String ?? ""
                                    let segmentId = item["segmentId"] as? String ?? ""
                                    let segmentName = item["segmentName"] as? String ?? ""
                                    let dataType = item["dataType"] as? String ?? ""
                                    let usage = item["usage"] as? String ?? ""
                                    let length = item["length"] as? String ?? ""
                                    let implementationName = item["implementationName"] as? String ?? ""
                                    let elementRepeat = item["elementRepeat"] as? Int ?? 0
                                    let loop = item ["loop"] as? String ?? ""
                                    let dataElement = item ["dataElement"] as? Int ?? 0
                                    
                                    let codes = item["codes"] as? [String] ?? []
                                    let transactions = item["transactions"] as? [String] ?? []
                                    let versions = item["versions"] as? [String] ?? []
                                    
                                    searchResults.append(X12Element(elementId: elementId, segmentId: segmentId, segmentName: segmentName, elementName: elementName, dataType : dataType, usage : usage, length : length, implementationName : implementationName, elementRepeat : elementRepeat, loop : loop, dataElement : dataElement, codes : codes, transactions : transactions, versions : versions))
                                }
                            }
                            
                        } else {
                            print("JSON Error or nothing was found")
                            let alertController = UIAlertController(title: "Alert", message: "Nothing was found", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss:", style: UIAlertActionStyle.default, handler: nil))
                      //      self.present(alertController, animated: true, completion: nil)
                        }
                        
                    } catch  {
                        print("Error Mapping X12Element")
                    }
                    //completion(searchResults)
               } else {
                    var alertString = ""
                    if(httpResponse.statusCode == 404) {
                        print("Just not found")
                        alertString = "No records were found."
                    } else {
                        alertString = "An error occured and Support as been notified.\n Please try again later."
                    }
                    print("HttpResponse is \(httpResponse.statusCode)")
                }
            }
            completion(searchResults)
        }
        dataTask?.resume()

    }
    
  */  
    func mapX12Element (fromUrl data : Data) -> [X12Element] {
        
        var elementArray = [X12Element]()
        
        do {
            let jsonDict  = try JSONSerialization.jsonObject(with: data as Data, options: []) as? AnyObject
            if let count = jsonDict?.count, count > 0 {
                
                if let json = jsonDict as? [[String: AnyObject]] {
                    for item in json {
                        
                        let elementId  = item["elementId"] as? String ?? ""
                        let elementName = item["elementName"] as? String ?? ""
                        let segmentId = item["segmentId"] as? String ?? ""
                        let segmentName = item["segmentName"] as? String ?? ""
                        let dataType = item["dataType"] as? String ?? ""
                        let usage = item["usage"] as? String ?? ""
                        let length = item["length"] as? String ?? ""
                        let implementationName = item["implementationName"] as? String ?? ""
                        let elementRepeat = item["elementRepeat"] as? Int ?? 0
                        let loop = item ["loop"] as? String ?? ""
                        let dataElement = item ["dataElement"] as? Int ?? 0
                        
                        let codes = item["codes"] as? [String] ?? []
                        let transactions = item["transactions"] as? [String] ?? []
                        let versions = item["versions"] as? [String] ?? []
                        
                        elementArray.append(X12Element(elementId: elementId, segmentId: segmentId, segmentName: segmentName, elementName: elementName, dataType : dataType, usage : usage, length : length, implementationName : implementationName, elementRepeat : elementRepeat, loop : loop, dataElement : dataElement, codes : codes, transactions : transactions, versions : versions))
                    }
                }
            }
        } catch  {
            print("Error Mapping X12Element")
        }
        return elementArray
    }
}
