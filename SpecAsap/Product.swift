//
//  Product.swift
//  SpecAsap
//
//  Created by David Cheli on 1/23/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class Product {
    var productId : String?
    var active : Bool
    var displayName : String?
    var version : String?
    
    init(productId : String?, active : String?, displayName : String?, version: String?) {
        self.productId = productId!
        if active! == "true" {
            self.active = true
        } else {
            self.active = false
        }
        self.displayName = displayName
        self.version = version
        
    }
}
