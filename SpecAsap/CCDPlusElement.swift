//
//  CCDPlusElement.swift
//  SpecAsap
//
//  Created by David Cheli on 4/12/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation
class CCDPlusElement {
    
    var segmentName : String?
    var segmentId : String?
    var elementPosition : String?
    var elementName : String?
    var usage : String?
    var dataType:  String?
    var length : String?
    var position : String?
    var definition : String?
    var codes : Bool
    
    init ( segmentName : String?, segmentId : String?, elementPosition : String?, elementName : String?, usage : String?, dataType:  String?, length : String?, position : String?, definition : String?, codes : Bool) {
        self.segmentName  = segmentName
        self.segmentId = segmentId
        self.elementPosition = elementPosition
        self.elementName = elementName
        self.usage  = usage
        self.dataType = dataType
        self.length  = length
        self.position  = position
        self.definition = definition
        self.codes = codes
    }
}
