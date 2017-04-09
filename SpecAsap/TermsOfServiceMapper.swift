//
//  TermsOfServiceMapper.swift
//  SpecAsap
//
//  Created by David Cheli on 4/9/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class TermsOfServiceMapper {
    
    func mapTermsOfService(fromUrl data : Data) -> TermsOfService? {
        var termsOfService = TermsOfService()
        
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? AnyObject
            
            if let count = jsonDict?.count, count > 0 {
                
                if let json = jsonDict as? [String : AnyObject] {
                    let introduction  = json["introduction"] as? String ?? ""
                    let accountTerms  = json["accountTerms"] as? String ?? ""
                    let paymentRefundsUpgradingAndDowngrading  = json["paymentRefundsUpgradingAndDowngrading"] as? String ?? ""
                    let cancellationAndTermination  = json["cancellationAndTermination"] as? String ?? ""
                    let modificationsToTheServiceAndPrices  = json["modificationsToTheServiceAndPrices"] as? String ?? ""
                    let copyrightAndContentOwnership  = json["copyrightAndContentOwnership"] as? String ?? ""
                    let generalConditions = json["generalConditions"] as? String ?? ""
                    let lastReviewedOrUpdated  = json["lastReviewedOrUpdated"] as? String ?? ""
                    
                
                    let tos  = TermsOfService(introduction: introduction, accountTerms: accountTerms, paymentRefundsUpgradingAndDowngrading: paymentRefundsUpgradingAndDowngrading, cancellationAndTermination: cancellationAndTermination, modificationsToTheServiceAndPrices: modificationsToTheServiceAndPrices, copyrightAndContentOwnership: copyrightAndContentOwnership, generalConditions: generalConditions, lastReviewedOrUpdated: lastReviewedOrUpdated)
                    termsOfService = tos
                }
                
                
            } else {
                print("TermsOfService was not returned")
            }
            
        } catch {
            print("Error mapping TermsOfService")
        }
        
        return termsOfService
    }
    
    
}
