//
//  NCPDPParser.swift
//  SpecAsap
//
//  Created by David Cheli on 12/18/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation

class NCPDPElementMapper{
    
    
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
