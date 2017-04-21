//
//  X12ElementParser.swift
//  SpecAsap
//
//  Created by David Cheli on 12/12/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation

class X12ElementMapper {
    
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
