//
//  X12Element.swift
//  SpecAsap
//
//  Created by David Cheli on 12/14/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation

class X12Element {
    
    var elementId: String?
    var segmentId : String?
    var segmentName : String?
    var elementName : String?
    var dataType : String?
    var usage : String?
    var length : String?
    var implementationName : String?
    var elementRepeat : Int?
    var loop : String?
    var dataElement : Int?
    
    var codes : [String]?
    var transactions : [String]?
    var versions : [String]?
    
    init(elementId : String?, segmentId : String?, segmentName : String?, elementName : String?,
         dataType : String?, usage : String?, length : String?, implementationName : String?,
         elementRepeat : Int?, loop : String?, dataElement : Int?, codes : [String]?,
         transactions : [String]?, versions : [String]?) {
        self.elementId = elementId
        self.segmentId = segmentId
        self.segmentName = segmentName
        self.elementName = elementName
        self.dataType = dataType
        self.usage = usage
        self.length = length
        self.implementationName = implementationName
        self.elementRepeat = elementRepeat
        self.loop = loop
        self.dataElement = dataElement
        self.codes = codes
        self.transactions = transactions
        self.versions = versions
    }
}
