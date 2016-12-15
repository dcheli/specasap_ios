//
//  Element.swift
//  SpecAsap
//
//  Created by David Cheli on 11/13/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//
import Foundation

class NCPDPElement {
    var elementId: String?
    var elementName: String?
    var definition: String?
    var segmentId: String?
    var segmentName: String?
    var standardFormats : [String]
    var lengths : [String]
    var transactions : [String]
    var versions : [String]
    var codes : [String]
 
    init(elementId: String?, elementName: String?, definition : String?, segmentId: String?,
         segmentName: String?, standardFormats : [String], lengths : [String], transactions : [String],
         versions : [String], codes : [String]) {
        self.elementId = elementId
        self.elementName = elementName
        self.definition = definition
        self.segmentId = segmentId
        self.segmentName = segmentName
        self.standardFormats = standardFormats
        self.lengths = lengths
        self.transactions = transactions
        self.versions = versions
        self.codes = codes
    }
}
