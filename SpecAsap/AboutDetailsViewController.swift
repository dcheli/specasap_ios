//
//  AboutDetailsViewController.swift
//  SpecAsap
//
//  Created by David Cheli on 11/16/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class AboutDetailsViewController : UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var documentDisplay: UITextView!
    var pageTitle: String! = ""
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = pageTitle
        
        if title! == "Privacy Policy" {
            let methodStart = Date()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            NetworkManager.sharedInstance.getLegalDocument(document: "privacypolicy") { (responseCode, data ) -> Void in
                if responseCode == 200 {
                    var document = ""
                    let privacyPolicyMapper = PrivacyPolicyMapper()
                    let privacyPolicy = privacyPolicyMapper.mapPrivacyPolicy(fromUrl: data!)
                    
                    if let general = privacyPolicy?.generalInformation {
                        document.append("GENERAL INFORMATION\n")
                        document.append(general + "\n\n")
                    }
                    
                    if let usage = privacyPolicy?.informationGatheringAndUsage {
                        document.append("INFORMATION GATHERING AND USAGE\n")
                        document.append(usage + "\n\n")
                    }
                    
                    if let cookies  = privacyPolicy?.cookies {
                        document.append("COOKIES\n")
                        document.append(cookies + "\n\n")
                    }
                    
                    if let dataStorage  = privacyPolicy?.dataStorage {
                        document.append("DATA STORAGE\n")
                        document.append(dataStorage + "\n\n")
                    }
                    
                    if let disclosure  = privacyPolicy?.disclosure {
                        document.append("DISCLOSURE\n")
                        document.append(disclosure + "\n\n")
                    }
                    
                    if let safeHarbor  = privacyPolicy?.euAndSwissSafeHarbor {
                        document.append("EU AND SWISS SAFE HARBOR\n")
                        document.append(safeHarbor + "\n\n")
                    }
                    
                    
                    if let changes  = privacyPolicy?.changes {
                        document.append("CHANGES\n")
                        document.append(changes + "\n\n")
                    }
                    
                    if let questions  = privacyPolicy?.questions {
                        document.append("QUESTIONS\n")
                        document.append(questions + "\n\n")
                    }
                    
                    if let lastUpdate  = privacyPolicy?.lastReviewedOrUpdated {
                        document.append("LAST REVIEWED OR UPDATED\n")
                        document.append(lastUpdate + "\n\n")
                    }
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.documentDisplay.attributedText = self.attributedPrivacyPolicy(document: document)
                    }
                    
                } else {
                    let alertMessage = "Error retrieving Privacy Policy: Response Code received is \(responseCode) Please try again or contact support@dataasap.com"
                    let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
           
            let methodFinish = Date()
            let executionTime = methodFinish.timeIntervalSince(methodStart)
            print("Execution time for \(self.title!) was \(executionTime) ms")
            
 
        } else if title! == "Terms Of Service" {
            let methodStart = Date()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            NetworkManager.sharedInstance.getLegalDocument(document: "termsofservice") { (responseCode, data ) -> Void in
                if responseCode == 200 {
                    var document = ""
                    let termsOfServiceMapper = TermsOfServiceMapper()
                    let termsOfService = termsOfServiceMapper.mapTermsOfService(fromUrl: data!)
                    
                    if let introduction = termsOfService?.introduction {
                        document.append("INTRODUCTION\n")
                        document.append(introduction + "\n\n")
                    }
                    
                    if let accountTerms = termsOfService?.accountTerms {
                        document.append("ACCOUNT TERMS\n")
                        document.append(accountTerms + "\n\n")
                    }
                    
                    if let paymentRefunds  = termsOfService?.paymentRefundsUpgradingAndDowngrading {
                        document.append("PAYMENT, REFUNDS, UPGRADING AND DOWNGRADING\n")
                        document.append(paymentRefunds + "\n\n")
                    }
                    
                    if let cancellation = termsOfService?.cancellationAndTermination {
                        document.append("CANCELLATION AND TERMINATION\n")
                        document.append(cancellation + "\n\n")
                    }
                    
                    if let modifications  = termsOfService?.modificationsToTheServiceAndPrices {
                        document.append("MODIFICATIONS TO THE SERVICE AND PRICES\n")
                        document.append(modifications + "\n\n")
                    }
                    
                    if let copyright  = termsOfService?.copyrightAndContentOwnership {
                        document.append("COPYRIGHT AND CONTENT OWNERSHIP\n")
                        document.append(copyright + "\n\n")
                    }
                    
                    
                    if let generalConditions  = termsOfService?.generalConditions {
                        document.append("GENERAL CONDITIONS\n")
                        document.append(generalConditions + "\n\n")
                    }
                    
                    if let lastUpdate  = termsOfService?.lastReviewedOrUpdated {
                        document.append("LAST REVIEWED OR UPDATED\n")
                        document.append(lastUpdate + "\n\n")
                    }
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        self.documentDisplay.attributedText = self.attributedTermsOfService(document: document)
                    }
                
                
                } else {
                    let alertMessage = "Error retrieving Terms of Service: Response Code received is \(responseCode) Please try again or contact support@dataasap.com"
                    let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle : UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }

            let methodFinish = Date()
            let executionTime = methodFinish.timeIntervalSince(methodStart)
            print("Execution time for \(self.title!) was \(executionTime) ms")
            
        } else if title! == "Contact Us" {
            // Note this is from Simon Archers youtube video; kind of

            let mailComposeViewController = configuredMailViewController()
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        } else if title! == "Rate Us" {
            print("Rating should pop up")
            let message = "\nAre you finding this App useful? Please rate us in the App Store!\n If you know of ways we can make the App better, please send us feedback so we can imporve the experience for you.\n\nThanks!\nDataASAP"
            let alertContoller = UIAlertController(title: "Rate Us!", message: message, preferredStyle: .alert)
            
            alertContoller.addAction(UIAlertAction(title: "Rate on iTunes", style: .default, handler: {(action: UIAlertAction!) in
                print("RateUs.RateUs_Tapped")
                print("Send to iTunes")
            }))
            
            alertContoller.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) in
                print("RateUs.Cancel_Tappedx")
            }))
            present(alertContoller, animated: true, completion: nil)
        }
    }
    
    func configuredMailViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.navigationBar.tintColor = UIColor.white
        mailComposerVC.setToRecipients(["support@dataasap.com"])
        mailComposerVC.setSubject("SpecASAP Feedback")
        mailComposerVC.setMessageBody("Your Questions or Comments\n", isHTML: false)
        
        return mailComposerVC
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) { () -> Void in
            
            switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue:
                print("Cancelled Mail")
            case MFMailComposeResult.sent.rawValue:
                print("Message sent")
            default:
                break
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
         let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail. Please check e-mail configuration and try again. You may also visit http://www.dataasap.com to contact us.", preferredStyle: .alert)
        
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
            print("Email alert canceled")
        }))
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
    func attributedPrivacyPolicy(document: String) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string : document, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)])
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        
        let dd : NSString = document as NSString
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "GENERAL INFORMATION"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "GENERAL INFORMATION"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "INFORMATION GATHERING AND USAGE"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "INFORMATION GATHERING AND USAGE"))
        
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "COOKIES"))
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "COOKIES"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "DATA STORAGE"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "DATA STORAGE"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "DISCLOSURE"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "DISCLOSURE"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "EU AND SWISS SAFE HARBOR"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "EU AND SWISS SAFE HARBOR"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "CHANGES"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "CHANGES"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "QUESTIONS"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "QUESTIONS"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "LAST REVIEWED OR UPDATED"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "LAST REVIEWED OR UPDATED"))
        
        return attributedString
    }
    
    
    func attributedTermsOfService(document: String) -> NSMutableAttributedString {
  
        let attributedString = NSMutableAttributedString(string : document, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)])
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        
        let dd : NSString = document as NSString
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "INTRODUCTION"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "INTRODUCTION"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "ACCOUNT TERMS"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "ACCOUNT TERMS"))
        
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "PAYMENT, REFUNDS, UPGRADING AND DOWNGRADING"))
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "PAYMENT, REFUNDS, UPGRADING AND DOWNGRADING"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "CANCELLATION AND TERMINATION"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "CANCELLATION AND TERMINATION"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "MODIFICATIONS TO THE SERVICE AND PRICES"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "MODIFICATIONS TO THE SERVICE AND PRICES"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "COPYRIGHT AND CONTENT OWNERSHIP"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "COPYRIGHT AND CONTENT OWNERSHIP"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "GENERAL CONDITIONS"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "GENERAL CONDITIONS"))
        
        attributedString.addAttributes(boldFontAttribute, range: dd.range(of: "LAST REVIEWED OR UPDATED"))
        attributedString.addAttributes(underlineAttribute, range: dd.range(of: "LAST REVIEWED OR UPDATED"))
        
        return attributedString
    }
}
