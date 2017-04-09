//
//  TermsOfService.swift
//  SpecAsap
//
//  Created by David Cheli on 4/9/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class TermsOfService {
    
    
    var introduction : String?
    var accountTerms : String?
    var paymentRefundsUpgradingAndDowngrading : String?
    var cancellationAndTermination : String?
    var modificationsToTheServiceAndPrices : String?
    var copyrightAndContentOwnership : String?
    var generalConditions : String?
    var lastReviewedOrUpdated : String?
    
    init() {
        
    }
        
    init(introduction : String?, accountTerms : String? ,paymentRefundsUpgradingAndDowngrading : String?, cancellationAndTermination : String?, modificationsToTheServiceAndPrices : String?, copyrightAndContentOwnership : String?, generalConditions : String?,lastReviewedOrUpdated : String?) {
        self.introduction = introduction
        self.accountTerms = accountTerms
        self.paymentRefundsUpgradingAndDowngrading  = paymentRefundsUpgradingAndDowngrading
        self.cancellationAndTermination = cancellationAndTermination
        self.modificationsToTheServiceAndPrices  = modificationsToTheServiceAndPrices
        self.copyrightAndContentOwnership  = copyrightAndContentOwnership
        self.generalConditions  = generalConditions
        self.lastReviewedOrUpdated  = lastReviewedOrUpdated
    }

}
