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
        
        var ddd : NSMutableAttributedString = NSMutableAttributedString()
        
        var title = ""
        
        if let code = self.code {
            if let description = self.desc {
                if !code.isEmpty  && !description.isEmpty {
                    title = code + " - " + description
                } else if !code.isEmpty {
                    title = code
                } else if !description.isEmpty {
                    title = description
                }
            }
         }
        
        // Add some spacing
        var displayString  = title + "\n\n"
        
        displayString += self.longDescription!


        let bodyAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
        
        let headerlineAttributes : [String : Any] = [NSForegroundColorAttributeName : UIColor.black,NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]

        
        let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
        
        let dd : NSString = displayString as NSString
        attributedString.addAttributes(headerlineAttributes, range: dd.range(of: title))
        
        ddd = attributedString
        
        
    
        longDescriptionTextView.attributedText = ddd
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
