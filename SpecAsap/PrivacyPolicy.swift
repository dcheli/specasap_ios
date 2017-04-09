//
//  PrivacyPolicy.swift
//  SpecAsap
//
//  Created by David Cheli on 4/9/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import Foundation

class PrivacyPolicy {
    
    var generalInformation : String?
    var informationGatheringAndUsage : String?
    var cookies : String?
    var dataStorage : String?
    var disclosure : String?
    var euAndSwissSafeHarbor : String?
    var changes : String?
    var questions: String?
    var lastReviewedOrUpdated : String?
    init() {
        
    }
    
    init(generalInformation : String?, informationGatheringAndUsage : String?, cookies : String?, dataStorage : String? ,disclosure : String?, euAndSwissSafeHarbor : String?, changes : String?, questions: String?, lastReviewedOrUpdated : String?) {
        
        self.generalInformation = generalInformation
        self.informationGatheringAndUsage  = informationGatheringAndUsage
        self.cookies = cookies
        self.dataStorage = dataStorage
        self.disclosure  = disclosure
        self.euAndSwissSafeHarbor = euAndSwissSafeHarbor
        self.changes = changes
        self.questions = questions
        self.lastReviewedOrUpdated  = lastReviewedOrUpdated
        
    }

}
