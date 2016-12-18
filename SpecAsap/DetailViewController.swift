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
    //var element : NCPDPElement! = nil
    var element : AnyObject! = nil
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        var displayString = ""
        if element is NCPDPElement {
            
            let e : NCPDPElement = self.element as! NCPDPElement

            displayString += "Element Name: " +  e.elementName! + "\n"
            displayString += "Element ID: " +  e.elementId! + "\n"
            displayString += "Segment Name: " +  e.segmentName! + "\n"
            displayString += "Segment ID: " +  e.segmentId! + "\n"
        
        
            if e.lengths.count > 0{
                displayString += "Length(s):"
                displayString += processArray(e.lengths)
            }
            if e.versions.count > 0 {
                displayString += "Version(s):"
                displayString += processArray(e.versions)
            }
        
            if e.standardFormats.count > 0 {
                displayString += "Standard Format(s):"
                displayString += processArray(e.standardFormats)
            }
        
            if e.transactions.count > 0 {
                displayString += "Transaction(s):"
                displayString += processArray(e.transactions)
            }
        
            if e.codes.count > 0 {
                displayString += "Codes: "
                displayString += processArray(e.codes)
            }
        
            displayString += "Definition: " +  e.definition! + "\n"
        } else if element is X12Element {

            let e : X12Element = self.element as! X12Element
            
            displayString += "Implementation Name: " +  e.implementationName! + "\n"
            displayString += "Element ID: " +  e.elementId! + "\n"
            displayString += "Element Name: " +  e.elementName! + "\n"
            displayString += "Segment ID: " +  e.segmentId! + "\n"
            displayString += "Segment Name: " +  e.segmentName! + "\n"
            displayString += "Data Type: " + e.dataType! + "\n"
            displayString += "Length: " + e.length! + "\n"
            displayString += "Element Repeat: "  + String(e.elementRepeat!) + "\n"
            displayString += "Loop: " + e.loop! + "\n"
            displayString += "Data Element: " + String(e.dataElement!) + "\n"
            
            if e.versions.count > 0 {
                displayString += "Version(s):"
                displayString += processArray(e.versions)
            }
            
            if e.transactions.count > 0 {
                displayString += "Transaction(s):"
                displayString += processArray(e.transactions)
            }
            
            if e.codes.count > 0 {
                displayString += "Codes: "
                displayString += processArray(e.codes)
            }
            
        } else if element is HL7Element {
            
            let e : HL7Element = self.element as! HL7Element
            
            displayString += "Element ID: " +  e.elementId! + "\n"
            displayString += "Element Name: " +  e.elementName! + "\n"
            displayString += "Segment ID: " +  e.segmentId! + "\n"
            displayString += "Segment Name: " +  e.segmentName! + "\n"
            displayString += "Sequence: " + String(e.sequence!) + "\n"

            displayString += "Length: " + e.length! + "\n"
            displayString += "Conformance Length: " + e.conformanceLength! + "\n"
            displayString += "Data Type: " + e.dataType! + "\n"
            displayString += "Optionality: "  + String(e.optionality!) + "\n"
            displayString += "Repetition: " + e.repetition! + "\n"
            displayString += "Table Number: " + String(e.tableNumber!) + "\n"
            displayString += "Item Number: " + String(e.itemNumber!) + "\n"
            
            if e.versions.count > 0 {
                displayString += "Version(s):"
                displayString += processArray(e.versions)
            }
            
            if e.transactions.count > 0 {
                displayString += "Transaction(s):"
                displayString += processArray(e.transactions)
            }
            displayString += "Definition: " + e.definition! + "\n"

        }
        
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
