//
//  HL7ElementParser.swift
//  SpecAsap
//
//  Created by David Cheli on 12/15/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation

class HL7ElementMapper {
     
    func mapHL7Element (fromUrl data : Data) -> [HL7Element] {
        
        var elementArray = [HL7Element]()
        
        do {
            let jsonDict  = try JSONSerialization.jsonObject(with: data as Data, options: []) as? AnyObject
            
            if let count = jsonDict?.count, count > 0 {
                if let json = jsonDict as? [[String: AnyObject]] {
                    for item in json {
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
                        
                        elementArray.append(HL7Element(elementId: elementId, segmentId: segmentId, segmentName: segmentName, elementName: elementName, sequence: sequence, length : length, conformanceLength : conformanceLength,dataType : dataType, optionality : optionality, repetition : repetition, tableNumber : tableNumber, itemNumber : itemNumber, transactions : transactions, versions : versions, definition : definition))
                    }
                }
            }
        } catch  {
            print("Error mapping HL7Element")
        }
        return elementArray
    }

    
}
