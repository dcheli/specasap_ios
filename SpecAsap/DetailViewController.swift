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
        var ddd : NSMutableAttributedString = NSMutableAttributedString()
        
        if element is NCPDPElement {
            
            let e : NCPDPElement = self.element as! NCPDPElement

            displayString += "Element ID: " +  e.elementId! + "\n"
            displayString += "Element Name: " +  e.elementName! + "\n"

            if e.segmentIds .count > 0 {
                displayString += "Segment ID(s): "
                displayString += processArray(e.segmentIds)
            }
            
            if e.segmentNames .count > 0 {
                displayString += "Segment Name(s): "
                displayString += processArray(e.segmentNames)
            }

            
            if e.fieldFormats.count > 0 {
                displayString += "Field Format(s): "
                displayString += processArray(e.fieldFormats)
            }
            if e.lengths.count > 0{
                displayString += "Length(s): "
                displayString += processArray(e.lengths)
            }
            if e.versions.count > 0 {
                displayString += "Version(s): "
                displayString += processArray(e.versions)
            }
        
            if e.standardFormats.count > 0 {
                displayString += "Standard Format(s): "
                displayString += processArray(e.standardFormats)
            }
        
            if e.requestTransactions.count > 0 {
                displayString += "Request Transaction(s): \n"
                displayString += processArray(e.requestTransactions, addNewLine: true)
            }
            if e.responseTransactions.count > 0 {
                displayString += "Response Transaction(s): \n"
                displayString += processArray(e.responseTransactions, addNewLine: true)
            }
        
            if e.codes.count > 0 {
                displayString += "Codes: "
                displayString += processArray(e.codes)
            }
            
            
        
            displayString += "Definition: " +  e.definition! + "\n"
            
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)])
            let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Segment ID(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment ID(s):"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Segment Name(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment Name(s):"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Length(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Length(s):"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Standard Format(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Standard Format(s):"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Codes:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Codes:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Field Format(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Field Format(s):"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Version(s):"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Request Transaction(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Request Transaction(s):"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Response Transaction(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Response Transaction(s):"))

            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Definition:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Definition:"))
            
            
            ddd = attributedString

            
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
            
            
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)])
            let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Implementation Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Implementation Name:"))

            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Segment ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment ID:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Segment Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment Name:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Data Type:"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Length:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Length:"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Element Repeat:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element Repeat:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Loop:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Loop:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Data Element:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Data Element:"))

            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Codes:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Codes:"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Version(s):"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Transaction(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Transaction(s):"))
            
            ddd = attributedString

            
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
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)])
            let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Segment ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment ID:"))

            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Segment Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment Name:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Sequence:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Sequence:"))

            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Length:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Length:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Conformance Length:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Conformance Length:"))

            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Optionality:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Optionality:"))

            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Repetition:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Repetition:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Table Number:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Table Number:"))

            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Item Number:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Item Number:"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Version(s):"))
            
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Transaction(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Transaction(s):"))
            attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "Definition:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Definition:"))
            
            
            ddd = attributedString
        }
        
        textView.attributedText = ddd
        
    }
    
    override func viewDidLayoutSubviews() {
        // this forces the textView to go to the top row rather then the bottom row.
        super.viewDidLayoutSubviews()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
        // the below code is to deal with a bug in ios
        textView.isScrollEnabled = false
        textView.isScrollEnabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func processArray(_ array : [String], addNewLine: Bool = false) -> String {
        var output = ""
        
        let stringSeparator : String
        if addNewLine {
            stringSeparator = ",\n"
        } else {
            stringSeparator = ","
        }
        
        for item in array {
            output += " " + item + stringSeparator
        }
        
        // This drops the addtional \n character
        if addNewLine {
            return String(output.characters.dropLast(2)) + "\n"
        } else {
            return String(output.characters.dropLast()) + "\n"
        }
    }
    
}
