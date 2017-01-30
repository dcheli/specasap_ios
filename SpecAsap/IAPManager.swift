//
//  IAPManager.swift
//  SpecAsap
//
//  Created by David Cheli on 11/27/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import UIKit
import StoreKit

class IAPManager : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let sharedInstance = IAPManager()
    
    var request:SKProductsRequest!
    var products:[SKProduct] = []
    var id : [String] = []
    
    // SKProducts call back. Apple will process the request and call this method
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products

 //       for product in self.products {
 //           print("Found \(product.localizedTitle)")
 //       }
    }
    
    //Dave, you need to look into this.
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    
    }
    
    func performProductRequestForIdentifiers(identifiers : [String]) {
        
        // this is making a call to iTunes Connect
        //force unwrap as Set<String>
        let products = NSSet(array: identifiers) as! Set<String>
        self.request = SKProductsRequest(productIdentifiers: products)
        self.request.delegate = self
        self.request.start()
    }
    

    
    // this is called to get the productlist
    func requestProducts() {
        self.getProductIdentifiers()
    }
    
    func getProductIdentifiers() {
        
        // So this is where u would make the call to URLSession to get the identfiers
        //let defaultSession  = URLSessionConfiguration.default

        var identifiers : [String] = []
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let username = "dcheli"
        let password = "aside555"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)! as Data
        let base64LoginString = loginData.base64EncodedString(options: Data.Base64EncodingOptions())

        let methodStart = Date()
        let session = URLSession.shared
        let url = URL(string: "https://dataasap.com/specasap/webapi/v1/products/productlist")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")

        let dataTask = session.dataTask(with: request) {(data, response, error) -> Void in
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                DispatchQueue.main.async {
                    if jsonArray.count > 0 {
                        for json in jsonArray as! [Dictionary<String, String>]{
                            let productId = json["productId"]!
                            identifiers.append(productId)

                        }
                    }
                    self.performProductRequestForIdentifiers(identifiers: identifiers)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                let methodFinish = Date()
                let executionTime = methodFinish.timeIntervalSince(methodStart)
                print("Execution time for productlist request was \(executionTime) ms")
            } catch {
                print("Error: \(error)")
            }

        }
        dataTask.resume()
    }
    

    
    func setupPurchases(_ handler: @escaping (Bool) ->Void) {
        if SKPaymentQueue.canMakePayments() {
            handler(true)
            SKPaymentQueue.default().add(self)
            return
        }
        handler(false)
    }
    
    // Make the Payment
    
    // This function makes the payment request; allows you to buy the product
    func createPaymentRequestForProduct(product : SKProduct) {
        let payment = SKMutablePayment(product : product)
        payment.quantity = 1
        
        SKPaymentQueue.default().add(payment) // Storekit will handle it from here
    }
    
    // Transaction Observer. This observer will let us know when Apple processes the request
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
                break
            case .purchased:
                print("purchased")
                print("AppDelegate.validateReceipt is being called from IAPManager after purchase is made")
                AppDelegate.validateReceipt()
                //verifiy the receipt; RMStore stuff
               self.validateReceipt({ (success, purchases) in
                    if success {
                        print("receipt locally validated..I think")
                        self.persistPurchase(purchases: purchases!)
                        queue.finishTransaction(transaction)
                    } else {
                        // work out the correct behavior at a later time
                        print("Receipt did not validate")
                    }
                })
                
                break
            case .deferred:
                print("deferred")
                break
            case .failed:
                if let transactionError = transaction.error as? NSError {
                    if transactionError.code != SKError.paymentCancelled.rawValue {
                        print("Transaction error: \(transaction.error?.localizedDescription)")
                    } else {
                        print ("User cancelled transaction")
                    }
                }
                queue.finishTransaction(transaction)
                break
            case .restored:
                print("restored")
                if SKPaymentQueue.canMakePayments() {
                    queue.restoreCompletedTransactions()
                }
                
                queue.finishTransaction(transaction)
                break
            }
        }
    }
    
    
    // Some of this stuff is for non-auto renewing subscriptions
    // Receipt Verification completion handler
    
    func validateReceipt(_ handler: @escaping (Bool, [RMAppReceiptIAP]?) -> Void) {
        let verifier = RMStoreAppReceiptVerifier()
        if verifier.verifyAppReceipt() {
            handler(true, verifier.appReceipt.inAppPurchases)
        } else {
            handler(false, nil)
        }
    }
    
    func persistPurchase(purchases: [RMAppReceiptIAP]) {
        for purchase in purchases {
            if let endDate = purchase.subscriptionExpirationDate {
                //Auto renewing purchase; RMStore-oriented
                if purchase.isActiveAutoRenewableSubscription(for: endDate) {
                    self.unlockProductIdentifier(identifier: purchase.productIdentifier)
                } else {
                    self.lockProductIdentifier(identifier: purchase.productIdentifier)
                }
                
            } else {
                // this is for other types product types; i.e. non auto-renewing subscriptions
                self.unlockProductIdentifier(identifier: purchase.productIdentifier)
            }

        }
    }
    
    func unlockProductIdentifier(identifier: String) {
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
    }
    
    func lockProductIdentifier(identifier: String) {
        UserDefaults.standard.set(false, forKey: identifier)
        UserDefaults.standard.synchronize()
    }
    
    func restoreTransactions() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // this is called when we have successfully completed the restore process
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Restore complete")
        self.validateReceipt { (success, purchases) in
            if success {
                self.persistPurchase(purchases: purchases!)
                print("persist restored purchases")
            } else {
                print("problem with receipt valication after restore process")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error)
    }
}
