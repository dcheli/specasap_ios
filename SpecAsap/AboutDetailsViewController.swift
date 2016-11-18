//
//  AboutDetailsViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 11/16/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation
import UIKit

class AboutDetailsViewController : UIViewController {
    
    var pageTitle: String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
    }
}


