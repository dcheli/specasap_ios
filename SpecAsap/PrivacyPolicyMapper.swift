//
//  PrivacyPolicyMapper.swift
//  SpecAsap
//
//  Created by David Cheli on 4/9/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class PrivacyPolicyMapper {
    
    func mapPrivacyPolicy(fromUrl data : Data) -> PrivacyPolicy? {
        var privacyPolicy = PrivacyPolicy()
        
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? AnyObject

            if let count = jsonDict?.count, count > 0 {

                if let json = jsonDict as? [String : AnyObject] {
                    let generalInformation  = json["generalInformation"] as? String ?? ""
                    let informationGatheringAndUsage = json["informationGatheringAndUsage"] as? String ?? ""
                    let cookies = json["cookies"] as? String ?? ""
                    let dataStorage = json["dataStorage"] as? String ?? ""
                    let disclosure = json["disclosure"] as? String ?? ""
                    let euAndSwissSafeHarbor = json["euAndSwissSafeHarbor"] as? String ?? ""
                    let changes = json["changes"] as? String ?? ""
                    let questions = json["questions"] as? String ?? ""
                    let lastReviewedOrUpdated = json["lastReviewedOrUpdated"] as? String ?? ""
                    
                    let pp  = PrivacyPolicy(generalInformation: generalInformation, informationGatheringAndUsage: informationGatheringAndUsage, cookies: cookies, dataStorage: dataStorage, disclosure: disclosure, euAndSwissSafeHarbor: euAndSwissSafeHarbor, changes: changes, questions: questions, lastReviewedOrUpdated: lastReviewedOrUpdated)
                        privacyPolicy = pp
                }
                
                
            } else {
                print("PrivacyPolicy was not returned")
            }
            
        } catch {
            print("Error mapping PrivacyPolicy")
        }
        
        return privacyPolicy
    }
    
}
