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

        
//        let headerlineAttributes : [String : Any] = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,NSForegroundColorAttributeName : UIColor.blue]
       
        let headerlineAttributes : [String : Any] = [NSForegroundColorAttributeName : UIColor.black,NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]
        
        
      //  NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]
        
        //NSForegroundColorAttributeName : UIColor.blue]
        let bodyAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
        

        var displayString = ""
        var ddd : NSMutableAttributedString = NSMutableAttributedString()
        
        if element is NCPDPElement {
            
            self.codeSetDomain = "ncpdp"
            self.codeSetVersion = "D0"
            
            let e : NCPDPElement = self.element as! NCPDPElement
            

            if let elementName = e.elementName {
                displayString += "Element Name: " +  elementName + "\n"
                
            }
            
            if let elementId = e.elementId {
                self.elementId = elementId
                displayString += "Element ID: " +  elementId + "\n"
            }
            
            if let segmentNames = e.segmentNames {
                if segmentNames .count > 0 {
                    displayString += "Segment(s): "
                    displayString += processArray(segmentNames)
                }
            }

            if let fieldFormats = e.fieldFormats {
                if fieldFormats.count > 0 {
                    displayString += "Field Format(s): "
                    displayString += processArray(fieldFormats)
                }
            }
            
            if let lengths = e.lengths {
                if lengths.count > 0{
                    displayString += "Length(s): "
                    displayString += processArray(lengths)
                }
            }

 
            if let definition = e.definition, !definition.isEmpty {
                displayString += "Definition: " +  definition + "\n"
            }
            
            if let comments = e.comments, !comments.isEmpty {
                displayString += "Comments: " +  comments + "\n"
            }
            
            if let codes = e.codes {
                if codes.count > 0 {
                    self.getCodeSetButton.isHidden = false
                    self.getCodeSetButton.isEnabled = true
                }
            }

            if let fbRejectMessages = e.fbRejectMessages {
                if fbRejectMessages.count > 0 {
                    displayString += "FB Reject Codes: \n"
                    displayString += processArray(fbRejectMessages, addNewLine: true)
                }
            }

            if let standardFormats = e.standardFormats {
                if standardFormats.count > 0 {
                    displayString += "Standard Format(s): "
                    displayString += processArray(standardFormats)
                }
            }
        
            if let requestTransactions = e.requestTransactions {
                if requestTransactions.count > 0  || !requestTransactions.isEmpty {
                    displayString += "Request Transaction(s): \n"
                    displayString += processArray(requestTransactions, addNewLine: true)
                }
            }
        
            if let responseTransactions = e.responseTransactions {
        
                if responseTransactions.count > 0  || !responseTransactions.isEmpty {
                    displayString += "Response Transaction(s): \n"
                    displayString += processArray(responseTransactions, addNewLine: true)
                }
            }
        
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
            let dd : NSString = displayString as NSString

            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "FB Reject Codes:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Segment ID(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Segment(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Length(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Standard Format(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Codes:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Field Format(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Request Transaction(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Response Transaction(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Definition:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Comments:"))
            
            ddd = attributedString

            
        } else if element is X12Element {
            
            self.codeSetDomain = "x12"
            self.codeSetVersion = "5010"
            
            let e : X12Element = self.element as! X12Element
            
            
            if let impName = e.implementationName {
                displayString += "Implementation Name: " +  impName + "\n"
            }
            
            if let elementName = e.elementName {
                displayString += "Element Name: " +  elementName + "\n"
            }
            
            if let elementId = e.elementId {
                self.elementId = e.elementId
                displayString += "Element ID: " +  elementId + "\n"
            }
            
            if let segmentId = e.segmentId {
                displayString += "Segment ID: " +  segmentId + "\n"
            }
            
            if let segmentName = e.segmentName {
                displayString += "Segment Name: " + segmentName + "\n"
            }
            
            if let dataType = e.dataType {
                displayString += "Data Type: " + dataType + "\n"
            }
            
            if let length = e.length {
                displayString += "Length: " + length + "\n"
            }
            
            if let elementRepeat = e.elementRepeat {
                displayString += "Element Repeat: "  + String(elementRepeat) + "\n"
            }
            
            if let loop = e.loop {
                if !loop.isEmpty {
                    displayString += "Loop: " + loop + "\n"
                }
            }
            
            if let dataElement = e.dataElement {
                displayString += "Data Element: " + String(dataElement) + "\n"
            }
            
 
            if let transactions = e.transactions {
                if transactions.count > 0 {
                    displayString += "Transaction(s): "
                    displayString += processArray(transactions)
                }
            }
            
            if let codes = e.codes {
                
                if codes.count > 0 {
                    self.getCodeSetButton.isHidden = false
                    self.getCodeSetButton.isEnabled = true
                }
            }
            
            
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
    
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Implementation Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Element ID:"))
            
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Segment ID:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Segment Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Data Type:"))
            
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Length:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Element Repeat:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Loop:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Data Element:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Codes:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Transaction(s):"))
            
            ddd = attributedString

            
        } else if element is HL7Element {
            
            self.codeSetDomain = "hl7"
            self.codeSetVersion = "282"
            
            let e : HL7Element = self.element as! HL7Element
            
            if let elementName = e.elementName{
                displayString += "Element Name: " +  elementName + "\n"
            }
            
            if let elementId = e.elementId {
                self.elementId = elementId
                displayString += "Element ID: " +  elementId + "\n"
            }
            
            if let segmentId = e.segmentId {
                displayString += "Segment ID: " +  segmentId + "\n"
            }
            
            if let segmentName = e.segmentName {
                displayString += "Segment Name: " +  segmentName + "\n"
            }
            
            if let sequence = e.sequence {
                displayString += "Sequence: " + String(sequence) + "\n"
            }
            
            if let dataType = e.dataType {
                displayString += "Data Type: " + dataType + "\n"
            }
            
            if let length = e.length {
                displayString += "Length: " + length + "\n"
            }
            
            if let conformanceLength = e.conformanceLength {
                displayString += "Conformance Length: " + conformanceLength + "\n"
            }
            
            if let optionality = e.optionality {
                displayString += "Optionality: "  + String(optionality) + "\n"
            }
           
            if let repetition = e.repetition {
                if !repetition.isEmpty{
                    displayString += "Repetition: " + repetition + "\n"
                }
            }
            
            if let tableNumber = e.tableNumber {
                displayString += "Table Number: " + String(tableNumber) + "\n"
            }
            
            if let itemNumber = e.itemNumber {
                displayString += "Item Number: " + String(itemNumber) + "\n"
            }
            
            if let versions = e.versions {
                if versions.count > 0 {
                    displayString += "Version(s):"
                    displayString += processArray(versions)
                }
            }
            
            if let transactions = e.transactions {
                if transactions.count > 0 {
                    displayString += "Transaction(s):"
                    displayString += processArray(transactions)
                }
            }
            
            if let definition = e.definition {
                displayString += "Definition: " + definition + "\n"
            }
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
            
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Element ID:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Element Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Segment ID:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Segment Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Sequence:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Length:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Conformance Length:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Optionality:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Repetition:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Table Number:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Item Number:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Version(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Transaction(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Definition:"))
            
            ddd = attributedString
        } else if element is CCDPlusElement {
            self.codeSetDomain = "ccdplus"
            self.codeSetVersion = ""
            
            let e : CCDPlusElement = self.element as! CCDPlusElement
            
            
            if e.codes == true {
                self.getCodeSetButton.isHidden = false
                self.getCodeSetButton.isEnabled = true
                
            }
            if let fieldName = e.elementName {
                // Yes this is correct.
                self.elementId = fieldName
                displayString += "Field Name: " +  fieldName + "\n"
            }
            if let recordName = e.segmentName {
                displayString += "Record Name: " +  recordName + "\n"
            }
            
            if let recordPosition = e.elementPosition {
                displayString += "Record Position: " +  recordPosition + "\n"
            }
            
            if let position = e.position {
                displayString += "Field Position: " + position + "\n"
            }
            
            if let usage = e.usage {
                displayString += "Usage: " + usage + "\n"
            }
            
            if let dataType = e.dataType {
                displayString += "Data Type: " + dataType + "\n"
            }
            
            if let length = e.length {
                displayString += "Length: " + length + "\n"
            }
            
            if let definition = e.definition {
                displayString += "Definition: " + definition + "\n"
            }
            
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Record Position:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Field Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Record Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Record ID:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Length:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Field Position:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Usage:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Definition:"))
            
            ddd = attributedString
        } else if element is BAIElement {
            
            self.codeSetDomain = "bai"
            self.codeSetVersion = "2"
            
            let e : BAIElement = self.element as! BAIElement

            
            if e.codes == true {
                self.getCodeSetButton.isHidden = false
                self.getCodeSetButton.isEnabled = true
                
            }
            
            if let fieldName = e.elementName {
                // yes this is correct
                self.elementId = fieldName
                displayString += "Field Name: " +  fieldName + "\n"
            }

            if let recordNames = e.segmentNames {
                if recordNames.count > 0 {
                    displayString += "Record Name(s):"
                    displayString += processArray(recordNames)
                }
            }
            
            if let recordPosition = e.position {
                displayString += "Record Position: " + recordPosition + "\n"
            }
    
            if let usage = e.usage {
                displayString += "Usage: " + usage + "\n"
            }
            
            if let dataType = e.dataType {
                displayString += "Data Type: " + dataType + "\n"
            }
            if let length = e.length {
                displayString += "Length: " + length + "\n"
            }
            
            if let definition = e.definition {
                displayString += "Definition: " + definition + "\n"
            }
            
            let attributedString = NSMutableAttributedString(string : displayString as String, attributes: bodyAttributes)
            
            let dd : NSString = displayString as NSString
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Field Position:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Field Name:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Record Name(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Record ID(s):"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Length:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Record Position:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Usage:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Data Type:"))
            attributedString.addAttributes(headerlineAttributes, range: dd.range(of: "Definition:"))
            
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
