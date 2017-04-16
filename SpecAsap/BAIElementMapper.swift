//
//  BAIElementMapper.swift
//  SpecAsap
//
//  Created by David Cheli on 4/15/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class BAIElementMapper {
    
    
    func mapBAIElement (fromUrl data : Data) -> [BAIElement] {
        
        var elementArray = [BAIElement]()
        
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data as Data, options: []) as? AnyObject
            if let count = jsonDict?.count, count > 0 {
                
                if let json = jsonDict as? [[String: AnyObject]] {
                    for item in json {
                        if let attributes = item["attributes"] as? [String: AnyObject] {
                            
                            let segmentNames = attributes["segmentNames"] as? [String] ?? []
                            let segmentIds = attributes["segmentIds"] as? [String] ?? []
                            
                            let elementName = attributes["elementName"] as? String ?? ""
                            let usage = attributes["usage"] as? String ?? ""
                            let dataType = attributes["dataType"] as? String ?? ""
                            let length = attributes["length"] as? String ?? ""
                            let position = attributes["position"] as? String ?? ""
                            let definition = attributes["definition"] as? String ?? ""
                            let codes = attributes["codes"] as? Bool ?? false
                            
                            elementArray.append(BAIElement(segmentNames: segmentNames, segmentIds: segmentIds, elementName: elementName, usage: usage, dataType: dataType, length: length, definition: definition, position : position, codes: codes))
                        }
                    }
                }
            }
        } catch {
            
            print("Error mapping BAIElement")
        }
        return elementArray
    }
    
    
}
