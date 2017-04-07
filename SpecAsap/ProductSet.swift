//
//  ProductSet.swift
//  SpecAsap
//
//  Created by David Cheli on 4/6/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class ProductSet {
    
    var domain : String?
    var operatingSystems : [String]?
    var products : [Product]?
    
    init() {
        
    }
    
    init (domain : String?, operatingSystems : [String]?, products : [Product]?) {
        
        self.domain = domain
        self.operatingSystems = operatingSystems
        self.products = products
    }
    
}
