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
 //   var enabled : String?
    var active : Bool
    
    init(productId : String?, enabled : String?) {
        self.productId = productId!
   //     self.enabled = enabled!
        if enabled == "true" {
            self.active = true
        } else {
            self.active = false
        }
        
    }
}
