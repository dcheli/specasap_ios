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
    let baseUrl = URL(string: "https://dataasap.com/specasap/webapi/v1/")
    let username = "dcheli"
    let password = "aside555"
    let loginString : NSString
    let loginData : Data
    let base64LoginString : String
    let authorizationString = "Authorization"
    
    init() {
        let configuration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration)
        loginString = NSString(format: "%@:%@", username, password)
        loginData = loginString.data(using: String.Encoding.utf8.rawValue)! as Data
        base64LoginString = loginData.base64EncodedString(options: Data.Base64EncodingOptions())
    }
    
    func getCodeSet(searchParam: String, codeSetDomain : String, codeSetVersion : String, completion : @escaping ((_ responseCode: Int?, _ data : Data?) -> Void)){
        
        let element = searchParam.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let codeSet = codeSetDomain.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let relativeUrl = URL(string: "codesets/\(codeSet!)/\(element!)", relativeTo: baseUrl)
        var components = URLComponents(url: relativeUrl!, resolvingAgainstBaseURL: true)
        let versionQueryItem = URLQueryItem(name: "v", value: codeSetVersion)
        components?.queryItems = [versionQueryItem]
        
        var request = URLRequest(url: components!.url!)
        request.httpMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: authorizationString)
        print("Codeset url is \(request.url!)")
    
        let dataTask = urlSession.dataTask(with: (request as URLRequest),
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
        
        let relativeUrl = URL(string: "products/productlist", relativeTo: baseUrl)
        let components = URLComponents(url: relativeUrl!, resolvingAgainstBaseURL: true)
        
        var request = URLRequest(url: components!.url!)

        request.httpMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: authorizationString)
        
        
        let dataTask = urlSession.dataTask(with: (request as URLRequest),
                completionHandler: {(data, response, error) -> Void in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        
                        completion(httpResponse.statusCode, data)
                    }
        })
        
        dataTask.resume()
    }
    
    func getLegalDocument(document: String, completion : @escaping ((_ responseCode: Int?, _ data : Data?)->Void)) {
        
        let relativeUrl = URL(string: "legal/\(document)", relativeTo: baseUrl)
        let components = URLComponents(url: relativeUrl!, resolvingAgainstBaseURL: true)
        
        var request = URLRequest(url: components!.url!)
        request.httpMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: authorizationString)

        let dataTask = urlSession.dataTask(with: (request as URLRequest) ,
                completionHandler: {(data, response, error) -> Void in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let httpResponse = response as? HTTPURLResponse {
                            completion(httpResponse.statusCode, data)
                    }
            })
            dataTask.resume()
    }
    
    func getElements(elementDomain: String, version: String, searchParam : String, completion : @escaping ((_ responseCode: Int?, _ data : Data?)->Void)) {
        
        let relativeUrl = URL(string: "elements/\(elementDomain)/\(searchParam)", relativeTo: baseUrl)
        var components = URLComponents(url: relativeUrl!, resolvingAgainstBaseURL: true)
        let versionQueryItem = URLQueryItem(name: "v", value: version)
        components?.queryItems = [versionQueryItem]
        
        var request = URLRequest(url: components!.url!)
        request.httpMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: authorizationString)
  
        
        let dataTask = urlSession.dataTask(with: (request as URLRequest),
                completionHandler: {(data, response, error) -> Void in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        completion(httpResponse.statusCode, data)
                    }
        })
        dataTask.resume()
    }
    
    func verifyReceipt(receiptData : String, completion : @escaping ((_ responseCode : Int?, _ data : Data?) -> Void)) {
        let relativeUrl = URL(string: "IAPReceipt/verifyapplereceipt", relativeTo: baseUrl)
        
        let components = URLComponents(url: relativeUrl!, resolvingAgainstBaseURL: true)
        
        var request = URLRequest(url: components!.url!)
        request.httpMethod = "POST"
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = receiptData.data(using: String.Encoding.ascii)
        request.setValue(base64LoginString, forHTTPHeaderField: authorizationString)
        
        let dataTask = urlSession.dataTask(with: (request as URLRequest),
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
