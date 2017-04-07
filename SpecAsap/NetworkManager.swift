//
//  NetworkManager.swift
//  SpecAsap
//
//  Created by David Cheli on 4/3/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private var urlSession : URLSession
    static let sharedInstance = NetworkManager()
    let baseUrl = URL(string: "https://dataasap.com/")
    let username = "dcheli"
    let password = "aside555"
    let loginString : NSString
    let loginData : Data
    let base64LoginString : String
    
    init() {
        let configuration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration)
        loginString = NSString(format: "%@:%@", username, password)
        loginData = loginString.data(using: String.Encoding.utf8.rawValue)! as Data
        base64LoginString = loginData.base64EncodedString(options: Data.Base64EncodingOptions())
        
        
    }
    
    func getCodeSet(elementId: String, codeSetDomain : String, completion : @escaping ((_ responseCode: Int?, _ data : Data?) -> Void)){
        
        let relativeUrl = URL(string: "specasap/webapi/v1/codesets/\(codeSetDomain)/\(elementId)", relativeTo: baseUrl)
        let components = URLComponents(url: relativeUrl!, resolvingAgainstBaseURL: true)

        
        let request = NSMutableURLRequest(url: components!.url!)
        print("CodeSet URL is \(request.url)")
        
        request.httpMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        
        let dataTask = urlSession.dataTask(with: (request as? URLRequest)!,
                completionHandler: {(data, response, error) -> Void in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let httpResponse = response as? HTTPURLResponse {
        
                       completion(httpResponse.statusCode, data)
                    }
        })
        
        dataTask.resume()
    }
    
    
    func getProductSet(os: String, completion : @escaping ((_ responseCode: Int?, _ data : Data?) -> Void)){
        
        let relativeUrl = URL(string: "specasap/webapi/v1/products/productlist", relativeTo: baseUrl)
        let components = URLComponents(url: relativeUrl!, resolvingAgainstBaseURL: true)
        
        let request = NSMutableURLRequest(url: components!.url!)
        
        request.httpMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
        
        let dataTask = urlSession.dataTask(with: (request as? URLRequest)!,
                completionHandler: {(data, response, error) -> Void in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        
                        completion(httpResponse.statusCode, data)
                    }
        })
        
        dataTask.resume()
    }

}
