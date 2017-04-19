//
//  CCDPlusMapper.swift
//  SpecAsap
//
//  Created by David Cheli on 4/13/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class CCDPlusMapper {

    
     func mapCCDPlusElement (fromUrl data : Data) -> [CCDPlusElement] {
    
        var elementArray = [CCDPlusElement]()
    
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data as Data, options: []) as? AnyObject
            if let count = jsonDict?.count, count > 0 {
                
                if let json = jsonDict as? [[String: AnyObject]] {
                    for item in json {
                        if let attributes = item["attributes"] as? [String: AnyObject] {
                            
                            let segmentName = attributes["segmentName"] as? String ?? ""
                            let segmentId = attributes["segmentId"] as? String ?? ""
                            
                            let elementPosition = attributes["elementPosition"] as? String ?? ""
                            let elementName = attributes["elementName"] as? String ?? ""
                            let usage = attributes["usage"] as? String ?? ""
                            let dataType = attributes["dataType"] as? String ?? ""
                            let length = attributes["length"] as? String ?? ""
                            let position = attributes["position"] as? String ?? ""
                            let definition = attributes["definition"] as? String ?? ""
                            let codes = attributes["codes"] as? Bool ?? false
                            
                            
                            elementArray.append(CCDPlusElement(segmentName: segmentName, segmentId: segmentId, elementPosition: elementPosition, elementName: elementName, usage: usage, dataType: dataType, length: length, position: position, definition: definition, codes: codes))
                        }
                    }
                }
            }
        } catch {
    
            print("Error mapping CCDPlusElement")
        }
        return elementArray
    }
    
}
