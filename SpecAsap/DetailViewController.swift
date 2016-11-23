//
//  detailViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 11/13/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation
import UIKit


class DetailViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var element : Element! = nil
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Set the text in specViewText
        var displayString = "Element Name: " +  element.elementName! + "\n"
        displayString += "Element ID: " +  element.elementId! + "\n"
        displayString += "Segment Name: " +  element.segmentName! + "\n"
        displayString += "Segment ID: " +  element.segmentId! + "\n"
        
        
        if element.lengths.count > 0{
            displayString += "Length(s):"
            displayString += processArray(element.lengths)
        }
        if element.versions.count > 0 {
            displayString += "Version(s):"
            displayString += processArray(element.versions)
        }
        
        if element.standardFormats.count > 0 {
            displayString += "Standard Format(s):"
            displayString += processArray(element.standardFormats)
        }
        
        if element.transactions.count > 0 {
            displayString += "Transaction(s):"
            displayString += processArray(element.transactions)
        }
        
        displayString += "Definition: " +  element.definition! + "\n"
        
        textView.text = displayString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func processArray(_ array : [String]) -> String {
        var output = ""
        for item in array {
            output += " " + item + ","
        }
        return String(output.characters.dropLast()) + "\n"
    }
}
