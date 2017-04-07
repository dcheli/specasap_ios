//
//  CodeSet.swift
//  SpecAsap
//
//  Created by David Cheli on 4/4/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class CodeSet {
    var elementIds : [String]?
    var codes : [Code]?
    
    init() {
        
    }
    
    init(elementIds : [String]?, codes : [Code]?) {
        
        self.elementIds = elementIds!
        self.codes = codes!
    }

    
}
