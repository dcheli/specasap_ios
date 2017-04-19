//
//  detailViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 11/13/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation
import UIKit


class ElementDetailViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var element : AnyObject! = nil
    var elementId : String?
    var codeSetDomain : String?
    var codeSetVersion : String?
    
    @IBOutlet weak var getCodeSetButton: UIButton!
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.getCodeSetButton.isEnabled = false
        self.getCodeSetButton.isHidden = true
        getCodeSetButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        
        
        let underlineAttribute : [String : Any] = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,NSForegroundColorAttributeName : UIColor.blue]
        let bodyAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]


        var displayString = ""
        var ddd : NSMutableAttributedString = NSMutableAttributedString()
        
        if element is NCPDPElement {
            
            self.codeSetDomain = "ncpdp"
            self.codeSetVersion = "D0"
            
            let e : NCPDPElement = self.element as! NCPDPElement
            self.elementId = e.elementId

            
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

            if e.versions.count > 0 {
                displayString += "Version(s): "
                displayString += processArray(e.versions)
            }
            if e.definition != nil  || !(e.definition?.isEmpty)!{
                displayString += "Definition: " +  e.definition! + "\n"
            }
            
            if e.comments != nil  || !(e.comments?.isEmpty)!{
                displayString += "Comments: " +  e.comments! + "\n"
            }
            
            if e.codes.count > 0 {
                self.getCodeSetButton.isHidden = false
                self.getCodeSetButton.isEnabled = true
                
            }

            if e.fieldFormats.count > 0 {
                displayString += "Field Format(s): "
                displayString += processArray(e.fieldFormats)
            }
            if e.lengths.count > 0{
                displayString += "Length(s): "
                displayString += processArray(e.lengths)
            }
        
            if e.standardFormats.count > 0 {
                displayString += "Standard Format(s): "
                displayString += processArray(e.standardFormats)
            }
        
            if e.requestTransactions.count > 0  || !e.requestTransactions.isEmpty {
                displayString += "Request Transaction(s): \n"
                displayString += processArray(e.requestTransactions, addNewLine: true)
            }
            if e.responseTransactions.count > 0 {
                displayString += "Response Transaction(s): \n"
                displayString += processArray(e.responseTransactions, addNewLine: true)
            }
        
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
            let dd : NSString = displayString as NSString

            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment ID(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment Name(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Length(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Standard Format(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Codes:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Field Format(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Request Transaction(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Response Transaction(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Definition:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Comments:"))
            
            ddd = attributedString

            
        } else if element is X12Element {
            
            self.codeSetDomain = "x12"
            self.codeSetVersion = "5010"
            
            let e : X12Element = self.element as! X12Element
            self.elementId = e.elementId
            
            displayString += "Implementation Name: " +  e.implementationName! + "\n"
            displayString += "Element ID: " +  e.elementId! + "\n"
            displayString += "Element Name: " +  e.elementName! + "\n"
            displayString += "Segment ID: " +  e.segmentId! + "\n"
            displayString += "Segment Name: " +  e.segmentName! + "\n"
            displayString += "Data Type: " + e.dataType! + "\n"
            displayString += "Length: " + e.length! + "\n"
            displayString += "Element Repeat: "  + String(e.elementRepeat!) + "\n"
            
            if !(e.loop?.isEmpty)!{
                displayString += "Loop: " + e.loop! + "\n"
            }
            
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
                self.getCodeSetButton.isHidden = false
                self.getCodeSetButton.isEnabled = true
            }
            
            
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
    
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Implementation Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element ID:"))
            
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Data Type:"))
            
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Length:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element Repeat:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Loop:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Data Element:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Codes:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Transaction(s):"))
            
            ddd = attributedString

            
        } else if element is HL7Element {
            
            self.codeSetDomain = "hl7"
            self.codeSetVersion = "282"
            
            let e : HL7Element = self.element as! HL7Element
            self.elementId = e.elementId
            
            displayString += "Element ID: " +  e.elementId! + "\n"
            displayString += "Element Name: " +  e.elementName! + "\n"
            displayString += "Segment ID: " +  e.segmentId! + "\n"
            displayString += "Segment Name: " +  e.segmentName! + "\n"
            displayString += "Sequence: " + String(e.sequence!) + "\n"

            displayString += "Length: " + e.length! + "\n"
            displayString += "Conformance Length: " + e.conformanceLength! + "\n"
            displayString += "Data Type: " + e.dataType! + "\n"
            displayString += "Optionality: "  + String(e.optionality!) + "\n"
           
            if let repetition = e.repetition {
                if !repetition.isEmpty{
                    displayString += "Repetition: " + e.repetition! + "\n"
                }
            }
            
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
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
            
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Segment Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Sequence:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Length:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Conformance Length:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Optionality:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Repetition:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Table Number:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Item Number:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Transaction(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Definition:"))
            
            ddd = attributedString
        } else if element is CCDPlusElement {
            self.codeSetDomain = "ccdplus"
            self.codeSetVersion = ""
            
            let e : CCDPlusElement = self.element as! CCDPlusElement
            self.elementId = e.elementName
            
            if e.codes == true {
                self.getCodeSetButton.isHidden = false
                self.getCodeSetButton.isEnabled = true
                
            }

            displayString += "Field Name: " +  e.elementName! + "\n"
            displayString += "Field Position: " + e.position! + "\n"
            displayString += "Record Name: " +  e.segmentName! + "\n"
            displayString += "Record ID: " + e.segmentId! + "\n"
            displayString += "Record Position: " +  e.elementPosition! + "\n"

            displayString += "Usage: " + e.usage! + "\n"
            displayString += "Data Type: " + e.dataType! + "\n"
            displayString += "Length: " + e.length! + "\n"
            displayString += "Definition: " + e.definition! + "\n"
            
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Record Position:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Field Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Record Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Record ID:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Length:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Field Position:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Usage:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Definition:"))
            
            ddd = attributedString
        } else if element is BAIElement {
            
            self.codeSetDomain = "bai"
            self.codeSetVersion = "2"
            
            let e : BAIElement = self.element as! BAIElement
            self.elementId = e.elementName
            
            if e.codes == true {
                self.getCodeSetButton.isHidden = false
                self.getCodeSetButton.isEnabled = true
                
            }
            
            
            displayString += "Field Name: " +  e.elementName! + "\n"
            displayString += "Field Position: " +  e.position! + "\n"
            
            if e.segmentNames.count > 0 {
                displayString += "Record Name(s):"
                displayString += processArray(e.segmentNames)
            }

            if e.segmentIds.count > 0 {
                displayString += "Record ID(s): "
                displayString += processArray(e.segmentIds)
            }
            
            displayString += "Record Position: " + e.position! + "\n"
            displayString += "Usage: " + e.usage! + "\n"
            displayString += "Data Type: " + e.dataType! + "\n"
            displayString += "Length: " + e.length! + "\n"
            displayString += "Definition: " + e.definition! + "\n"
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
            
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Field Position:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Field Name:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Record Name(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Record ID(s):"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Length:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Record Position:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Usage:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(underlineAttribute, range: dd.range(of: "Definition:"))
            
            ddd = attributedString

        }
        //textView.text = displayString
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! CodeSetTableViewController
        if let e = elementId {
            destination.searchParam = e
            destination.codeSetDomain = self.codeSetDomain
            destination.codeSetVersion = self.codeSetVersion
        } else {
            destination.searchParam = nil
        }
        
    }
}
