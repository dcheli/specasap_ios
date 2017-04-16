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

    }
    
    //Dave, you need to look into this.
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    
    }
    

    
    // this is called to get the productlist
    func requestProducts() {
        self.getProductIdentifiers()
    }
    
    func getProductIdentifiers() {
        
        var identifiers : [String] = []
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        NetworkManager.sharedInstance.getProductSet(os: "ios") { (responseCode, data) -> Void in
            
             print("Completion Handler called")
            
            if responseCode == 200 {
                
                let productSetMapper = ProductSetMapper()
                let productSet = productSetMapper.mapProductSet(fromUrl: data!)
                
                if productSet.count > 0 {
                    for item in productSet {
                        if let iProducts = item.products{
                            for id in iProducts {
                                identifiers.append(id.productId!)
                            }
                        }
                    }
        
                    AppDelegate.productSet = productSet
                }
                AppDelegate.standardNames = identifiers
                self.performProductRequestForIdentifiersFromiTunes(identifiers: identifiers)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            } else {
                print("result is \(String(describing : responseCode))")
            }
        }

/*
        let dataTask = session.dataTask(with: request) {(data, response, error) -> Void in
            do {
       //    DispatchQueue.main.async {
                let productSetParser  = ProductSetParser()
                productSetParser.parseProductSet(fromUrl: data!)
                
                if AppDelegate.productSet.count > 0 {
                    for productSet in AppDelegate.productSet {
                        for product in productSet.products! {
                            identifiers.append(product.productId!)
                        }
                    }
                }
                
                
                // I need to get the product ids & domains for the sections
                
             //   let jsonArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                DispatchQueue.main.async {
             //       if jsonArray.count > 0 {
               //         for json in jsonArray as! [Dictionary<String, String>]{
                 //           let productId = json["productId"]!
                   //         identifiers.append(productId)
                     //   }
           // }
            
                    self.performProductRequestForIdentifiersFromiTunes(identifiers: identifiers)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                 
                }
                let methodFinish = Date()
                let executionTime = methodFinish.timeIntervalSince(methodStart)
                print("Execution time for productlist request was \(executionTime) ms")
            } catch {
                print("Error: \(error)")
            }

        }
        dataTask.resume()*/
    }
    
    func performProductRequestForIdentifiersFromiTunes(identifiers : [String]) {
        
        // this is making a call to iTunes Connect
        //below is read - force unwrap as Set<String>
        let products = NSSet(array: identifiers) as! Set<String>
        self.request = SKProductsRequest(productIdentifiers: products)
        self.request.delegate = self
        self.request.start()
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
                //verifiy the receipt; RMAPP stuff remmed out 3/10/2017 I think this can be removed and 
                // possibly is the only part of RMApp this is called... need to verify
 /*              self.validateReceipt({ (success, purchases) in
                    if success {
                        print("receipt locally validated..I think")
                        self.persistPurchase(purchases: purchases!)
                        queue.finishTransaction(transaction)
                    } else {
                        // work out the correct behavior at a later time
                        print("Receipt did not validate")
                    }
                })
 */
                break
            case .deferred:
                print("deferred")
                break
            case .failed:
                if let transactionError = transaction.error as NSError? {
                    
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
/*
    func validateReceipt(_ handler: @escaping (Bool, [RMAppReceiptIAP]?) -> Void) {
        let verifier = RMStoreAppReceiptVerifier()
        if verifier.verifyAppReceipt() {
            handler(true, verifier.appReceipt.inAppPurchases)
        } else {
            handler(false, nil)
        }
    }
 */
  /*
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
*/
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
        
        // This stuff was in from the RMStore stuff, not sure what to do with it now
//        self.validateReceipt { (success, purchases) in
//            if success {
//                self.persistPurchase(purchases: purchases!)
//                print("persist restored purchases")
//            } else {
//                print("problem with receipt valication after restore process")
//            }
//        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error)
    }
}
