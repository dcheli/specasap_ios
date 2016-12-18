//
//  HL7Element.swift
//  SpecAsap
//
//  Created by David Cheli on 12/15/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation
class HL7Element {
    
    var elementId: String?
    var segmentId : String?
    var segmentName : String?
    var elementName : String?
    var sequence : Int?
    var length : String?
    var conformanceLength : String?
    var dataType : String?
    var optionality : String?
    var repetition : String?
    var tableNumber : String?
    var itemNumber : String?
    var definition : String?

    var transactions : [String]
    var versions : [String]
    
    init(elementId : String?, segmentId : String?, segmentName : String?, elementName : String?, sequence : Int?,
         length : String?, conformanceLength : String? , dataType : String?, optionality : String?,
         repetition : String?, tableNumber : String?, itemNumber : String?, transactions : [String], versions : [String],
         definition : String?) {
        
        self.elementId = elementId
        self.segmentId = segmentId
        self.segmentName = segmentName
        self.elementName = elementName
        self.sequence = sequence
        self.length = length
        self.conformanceLength = conformanceLength
        self.dataType = dataType
        self.optionality = optionality
        self.repetition = repetition
        self.tableNumber = tableNumber
        self.itemNumber = itemNumber
        self.transactions = transactions
        self.versions = versions
        self.definition = definition
    }
}
