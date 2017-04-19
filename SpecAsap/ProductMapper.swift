//
//  ProductMapper.swift
//  SpecAsap
//
//  Created by David Cheli on 4/9/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class ProductMapper {
    
    var products = [Product]()
    func mapProduct(fromUrl data : Data) -> [Product] {
    
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? AnyObject
            
            if let count = jsonDict?.count, count > 0 {
                AppDelegate.products.removeAll()
                if let json = jsonDict as? [[String: AnyObject]] {
                    for item in json {
                        let productId = item["productId"] as? String ?? ""
                        let active =  item["enabled"] as? String ?? ""
                        let displayName = item["displayName"] as? String ?? ""
                        let version = item["version"] as? String ?? ""
                        products.append(Product(productId: productId, active: active, displayName : displayName, version: version))
                    }
                }
            }
            
        } catch {
            print("Error mapping ProductMapper")
        }
        return products
    }
}
