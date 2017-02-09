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
    var segmentIds: [String]
    var segmentNames: [String]
    var standardFormats : [String]
    var lengths : [String]
    var requestTransactions : [String]
    var responseTransactions : [String]
    var versions : [String]
    var codes : [String]
    var dataType : String?
    var fieldFormats : [String]
    
    init(elementId: String?, elementName: String?, definition : String?, segmentIds: [String],
         segmentNames: [String], standardFormats : [String], lengths : [String],
         versions : [String], codes : [String], dataType : String?, fieldFormats : [String],
         requestTransactions : [String], responseTransactions : [String]) {
        self.elementId = elementId
        self.elementName = elementName
        self.definition = definition
        self.segmentIds = segmentIds
        self.segmentNames = segmentNames
        self.standardFormats = standardFormats
        self.lengths = lengths
        self.versions = versions
        self.codes = codes
        self.dataType = dataType
        self.fieldFormats = fieldFormats
        self.requestTransactions = requestTransactions
        self.responseTransactions = responseTransactions
        
    }
}
