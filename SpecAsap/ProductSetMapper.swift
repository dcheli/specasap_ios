//
//  ProductSetParser.swift
//  SpecAsap
//
//  Created by David Cheli on 4/6/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class ProductSetMapper{
    
    func mapProductSet(fromUrl data : Data) -> [ProductSet] {

        var products : [Product]? = [Product]()
        var domain : String?
        var operatingSystems : [String]?
        var productSet : [ProductSet] = [ProductSet]()
        
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? AnyObject
            
            
            if let count  = jsonDict?.count, count  > 0 {
                if let json  = jsonDict as? [[String : AnyObject]] {
                    for item in json {
                        domain  = item["domain"] as? String ?? ""
                        operatingSystems = item["operatingSystems"] as? [String] ?? []
                        
                        let jsonArray = item["products"] as? AnyObject
                        
                        if (jsonArray?.count!)! > 0 {
                            if let productArray = jsonArray as? [[String: AnyObject]] {
                            
                                for product in productArray {
                                    let displayName = product["displayName"] as? String ?? ""
                                    let productId = product["productId"] as? String ?? ""
                                    let version = product["version"] as? String ?? ""
                                    print("\(productId)")
                                    products?.append(Product(productId: productId, enabled: "false", displayName: displayName, version: version))
                                }
                            }
                        }

                        productSet.append(ProductSet(domain: domain, operatingSystems: operatingSystems, products: products))
                        products?.removeAll()
                    }

                }
            }
        } catch {
            print("Error mapping ProductSet")
        }
        return productSet
    }
    
    
}
