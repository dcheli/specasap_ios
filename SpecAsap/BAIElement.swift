//
//  BAIElement.swift
//  SpecAsap
//
//  Created by David Cheli on 4/15/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation
class BAIElement {
    
    var segmentNames : [String]?
    var segmentIds : [String]?
    var elementName : String?
    var usage : String?
    var dataType : String?
    var length : String?
    var definition : String?
    var position : String?
    var codes : Bool?
    
    init(segmentNames : [String]?, segmentIds : [String]?,  elementName : String?, usage : String?,dataType : String?, length : String?, definition : String?, position : String?, codes : Bool?) {
        
        self.segmentNames = segmentNames
        self.segmentIds  = segmentIds
        self.elementName  = elementName
        self.usage  = usage
        self.dataType  = dataType
        self.length  = length
        self.definition  = definition
        self.position = position
        self.codes = codes
    }
    
    
}
