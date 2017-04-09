//
//  CodeSetParser.swift
//  SpecAsap
//
//  Created by David Cheli on 4/4/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class CodeSetMapper {
    
    init() {
        
    }
    
    func mapCodeSet(fromUrl data : Data) -> CodeSet? {
        
        var codeSet : CodeSet?
        var codesS :  [Code]? = [Code]()
        var elementIdsS  =  [String]()
        
        do {
            let jsonDict  = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String: AnyObject]
            
            if let elementIds = jsonDict["elementIds"] as? [String] {
                 elementIdsS = elementIds
            }
            if let codes = jsonDict["codes"] as? [[String: AnyObject]]{
                for code in codes {
                    let c = code["code"] as? String ?? ""
                    let description  = code["description"] as? String ?? ""
                    let longDescription = code["longDescription"] as? String ?? "No Additional Information"
                    codesS?.append(Code(code: c, description: description, longDescription : longDescription))
                   
                }
            } else {
                print("Dump \(jsonDict)")
            }
                
            codeSet = CodeSet(elementIds: elementIdsS, codes: codesS)
            
 
        } catch {
            print("Error mapping CodeSet")
        }

        return codeSet
    
    }
}
