//
//  CodeSetDetailViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 4/7/17.
//  Copyright © 2017 David Cheli. All rights reserved.
//

import UIKit

class CodeSetDetailViewController: UIViewController {
    var code : String?
    var desc : String?
    var longDescription : String?

    @IBOutlet weak var longDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        var displayString = self.code! + " - " + self.desc! + "\n\n"
        
        displayString += self.longDescription!
    
        longDescriptionTextView.text = displayString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
