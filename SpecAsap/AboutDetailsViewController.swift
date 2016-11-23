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
    var pageTitle: String! = nil
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
//        super.viewDidLoad()
        self.title = pageTitle
        print(title!)
        if title! == "Privacy Policy" {
            let document = LegalDocument()
            document.urlString = "https://dataasap.com/specasap/webapi/privacypolicy"
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            document.getDocument { data in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                // so what this does is somehow returns the UI control back to the main thread. If you don't do this it will crach
                // because this running in a different thread
                DispatchQueue.main.sync(execute: {
                    do {
                        var document = ""
                        let jsonDict  = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as AnyObject
                     //       if let json = jsonDict as? AnyObject {
                       if let json = jsonDict as? [String: String] {
                        // the problem with this is that it displays in any order
                        //        for(key, value) in json {
                        //            let title = key + "\n\n"
                        //            let content = value + "\n\n"
                        //           document.append(title)
                        //            document.append(content)
                        //        }
                        
                        if let general = json["generalInformation"] {
                            document.append("GENERAL INFORMATION\n")
                            document.append(general + "\n\n")
                        }
                        
                        if let usage = json["informationGatheringAndUsage"] {
                            document.append("INFORMATION GATHERING AND USAGE\n")
                            document.append(usage + "\n\n")
                        }

                        if let cookies  = json["cookies"] {
                            document.append("COOKIES\n")
                            document.append(cookies + "\n\n")
                        }
                        
                        if let dataStorage  = json["dataStorage"] {
                            document.append("DATA STORAGE\n")
                            document.append(dataStorage + "\n\n")
                        }
                        
                        if let disclosure  = json["disclosure"] {
                            document.append("DISCLOSURE\n")
                            document.append(disclosure + "\n\n")
                        }
                        
                        if let safeHarbor  = json["euAndSwissSafeHarbor"] {
                            document.append("EU AND SWISS SAFE HARBOR\n")
                            document.append(safeHarbor + "\n\n")
                        }


                        if let changes  = json["changes"] {
                            document.append("CHANGES\n")
                            document.append(changes + "\n\n")
                        }
                        
                        if let questions  = json["questions"] {
                            document.append("QUESTIONS\n")
                            document.append(questions + "\n\n")
                        }

                        if let lastUpdate  = json["lastReviewedOrUpdated"] {
                            document.append("LAST REVIEWED OR UPDATED\n")
                            document.append(lastUpdate + "\n\n")
                        }
                        

                        self.documentDisplay.text = document
                            }
                    }catch  {
                        print("Do better error handling here")
                    }
                    });
            }
            
        } else if title! == "Terms Of Service" {
            print ("terms of service was selected")
            let document = LegalDocument()
            document.urlString = "https://dataasap.com/specasap/webapi/termsofservice"
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            document.getDocument { data in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                DispatchQueue.main.sync(execute: {
                    do {
                        var document = ""
                        
                        let jsonDict  = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as AnyObject
                        //       if let json = jsonDict as? AnyObject {
                        if let json = jsonDict as? [String: String] {
                            print(json)
                            if let introduction = json["introduction"] {
                                document.append("INTRODUCTION\n")
                                document.append(introduction + "\n\n")
                            }
                            
                            if let accountTerms = json["accountTerms"] {
                                document.append("ACCOUNT TERMS\n")
                                document.append(accountTerms + "\n\n")
                            }
                            
                            if let paymentRefunds  = json["paymentRefundsUpgradingAndDowngrading"] {
                                document.append("PAYMENT, REFUNDS, UPGRADING AND DOWNGRADING\n")
                                document.append(paymentRefunds + "\n\n")
                            }
                            
                            if let cancellation = json["cancellationAndTermination"] {
                                document.append("CANCELLATION AND TERMINATION\n")
                                document.append(cancellation + "\n\n")
                            }
                            
                            if let modifications  = json["modificationsToTheServiceAndPrices"] {
                                document.append("MODIFICATIONS TO THE SERVICE AND PRICES\n")
                                document.append(modifications + "\n\n")
                            }
                            
                            if let copyright  = json["copyrightAndContentOwnership"] {
                                document.append("COPYRIGHT AND CONTENT OWNERSHIP\n")
                                document.append(copyright + "\n\n")
                            }
                            
                            
                            if let generalConditions  = json["generalConditions"] {
                                document.append("GENERAL CONDITIONS\n")
                                document.append(generalConditions + "\n\n")
                            }
                            
                            if let lastUpdate  = json["lastReviewedOrUpdated"] {
                                document.append("LAST REVIEWED OR UPDATED\n")
                                document.append(lastUpdate + "\n\n")
                            }
                            
                            self.documentDisplay.text = document
                        }
                    }catch  {
                        print("Do better error handling here")
                    }
                });

            }
            
        } else if title! == "Contact Us" {
            print("Do something")
            let mailComposeController = MFMailComposeViewController()
            mailComposeController.mailComposeDelegate = self
            mailComposeController.setToRecipients(["dcheli@live.com"])
            mailComposeController.setSubject("Support Question")
            mailComposeController.setMessageBody("This is a Test", isHTML: false)
            if MFMailComposeViewController.canSendMail() {
                
            } else {
                self.showSendMailErrorAlert()
            }
        } else if title! == "Rate Us" {
            print("Rating should pop up")
            let message = "\nAre you finding this App useful? Please rate us in the App Store!\\n If you know of ways we can make the App better, please send us feedback so we can imporve the experience for you.\n\nThanks!\nDataASAP"
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
       // let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail. Pelase check e-mailconfiguration and try again. You may also visit http://www.dataasap.com.", delegate: self, cancelButtonTitle: "OK")
         let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail. Pelase check e-mailconfiguration and try again. You may also visit http://www.dataasap.com.", preferredStyle: .alert)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    
}

class LegalDocument {
    var urlString : String! = nil
    
    func getDocument(completion: @escaping (Data) -> ()) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let username = "dcheli"
            let password = "aside555"
            let loginString = NSString(format: "%@:%@", username, password)
            let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)! as Data
            let base64LoginString = loginData.base64EncodedString(options: Data.Base64EncodingOptions())
            request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
            
            let dataTask = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // do something here
                        completion(data!)
                    }
                }
//                if let data = data, let jsonString = String(data: data, encoding: String.Encoding.utf8), error == nil {
//                    completion(jsonString)

//                } else {
//                    print("error=\(error!.localizedDescription)")
//                }
            }
            dataTask.resume()
        }
    }
}



