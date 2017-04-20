//
//  NCPDPParser.swift
//  SpecAsap
//
//  Created by David Cheli on 12/18/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation

class NCPDPElementMapper{
    
    var urlString : String?
/*
    init(fromUrl urlString : String) {
        self.urlString = urlString
        print (self.urlString!)
    }
    
    func getNCPDPSpec(urlString: String, completion : @escaping (_ result : [NCPDPElement]) -> Void) {
        let defaultSession  = URLSessionConfiguration.default
        var dataTask : URLSessionDataTask?
        var searchResults = [NCPDPElement]()
        
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
                                    let elementId  = item["elementId"] as? String ?? ""
                                    let segmentIds = item["segmentIds"] as? [String] ?? []
                                    let segmentNames = item["segmentNames"] as? [String] ?? []
                                    let elementName = item["elementName"] as? String ?? ""
                                    let definition = item["definition"] as? String ?? ""
                                    let comments = item["comments"] as? String ?? ""
                                    
                                    let codes = item["codes"] as? [String] ?? []
                                    
                                    let standardFormats = item["standardFormats"] as? [String] ?? []
                                    let lengths = item["lengths"] as? [String] ?? []
                                    let requestTransactions = item["requestTransactions"] as? [String] ?? []
                                    let responseTransactions = item["responseTransactions"] as? [String] ?? []
                                    let versions = item["versions"] as? [String] ?? []
                                    
                                    let dataType = item["dataType"] as? String ?? ""
                                    let fieldFormats = item["fieldFormats"] as? [String] ?? []
                                    
                                    searchResults.append(NCPDPElement(elementId : elementId, elementName: elementName,
                                                                      definition: definition, segmentIds: segmentIds, segmentNames: segmentNames,
                                                                      standardFormats : standardFormats, lengths: lengths,
                                                                      versions : versions, codes : codes, dataType : dataType, fieldFormats : fieldFormats, requestTransactions : requestTransactions, responseTransactions : responseTransactions, comments: comments))
                               }
                            }
                            
                        } else {
                            print("JSON Error or nothing was found")
                            let alertController = UIAlertController(title: "Alert", message: "Nothing was found", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss:", style: UIAlertActionStyle.default, handler: nil))
                            //      self.present(alertController, animated: true, completion: nil)
                        }
                        
                    } catch  {
                        print("Error mapping NCPDPElement")
                    }
                  //  completion(searchResults)
                    
                } else {
                    var alertString = ""
                    if(httpResponse.statusCode == 404) {
                
                        alertString = "No records were found."
                    } else {
                        alertString = "An error occured and Support as been notified.\n Please try again later."
                    }
                    print("HttpResponse is \(httpResponse.statusCode)")
                }
                completion(searchResults)
            }
        }
        dataTask?.resume()

    }
    
  */  
    
    func mapNCPDPElement (fromUrl data : Data) -> [NCPDPElement] {
        
        var elementArray = [NCPDPElement]()
        
        do {
            let jsonDict  = try JSONSerialization.jsonObject(with: data as Data, options: []) as? AnyObject
            
            if let count = jsonDict?.count, count > 0 {
                if let json = jsonDict as? [[String: AnyObject]] {
                    
                    for item in json {
                        let elementId  = item["elementId"] as? String ?? ""
                        let segmentIds = item["segmentIds"] as? [String] ?? []
                        let segmentNames = item["segmentNames"] as? [String] ?? []
                        let elementName = item["elementName"] as? String ?? ""
                        let definition = item["definition"] as? String ?? ""
                        let comments = item["comments"] as? String ?? ""
                        
                        let codes = item["codes"] as? [String] ?? []
                        
                        let standardFormats = item["standardFormats"] as? [String] ?? []
                        let lengths = item["lengths"] as? [String] ?? []
                        let requestTransactions = item["requestTransactions"] as? [String] ?? []
                        let responseTransactions = item["responseTransactions"] as? [String] ?? []
                        let versions = item["versions"] as? [String] ?? []
                        
                        let dataType = item["dataType"] as? String ?? ""
                        let fieldFormats = item["fieldFormats"] as? [String] ?? []
                        let fbRejectMessages = item["fbRejectMessages"] as? [String] ?? []
                        
                        elementArray.append(NCPDPElement(elementId : elementId, elementName: elementName,
                                                          definition: definition, segmentIds: segmentIds, segmentNames: segmentNames,
                                                          standardFormats : standardFormats, lengths: lengths,
                                                          versions : versions, codes : codes, dataType : dataType, fieldFormats : fieldFormats, requestTransactions : requestTransactions, responseTransactions : responseTransactions, comments: comments, fbRejectMessages : fbRejectMessages))
                    }
                }
            }
        } catch  {
            print("Error mapping NCPDPElement")
        }

        return elementArray
        
    }
}
