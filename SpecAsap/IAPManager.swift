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
    
    // SKProducts call back
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products

        for product in self.products {
            print("Found \(product.localizedTitle)")
        }
    }
    
    func getProductIdentifiers() -> [String] {
        var identifiers : [String] = []
        
        if let fileUrl = Bundle.main.url(forResource: "products", withExtension: "plist") {
            
            let products = NSArray(contentsOf: fileUrl)
            
            for product in products as! [String] {
                identifiers.append(product)
            }
        }
        
        return identifiers
    }
    
    func performProductRequestForIdentifiers(identifiers : [String]) {
        
        // this I believe is making a call to iTunes Connect
        //force unwrap as Set<String>
        let products = NSSet(array: identifiers) as! Set<String>
        self.request = SKProductsRequest(productIdentifiers: products)
        self.request.delegate = self
        self.request.start()
    }
    
    func requestProducts() {
        performProductRequestForIdentifiers(identifiers: self.getProductIdentifiers())
    }
    
    func setupPurchases(_ handler: @escaping (Bool) ->Void) {
        if SKPaymentQueue.canMakePayments() {
            handler(true)
            SKPaymentQueue.default().add(self)
            return
        }
        handler(false)
    }
    
    func createPaymentRequestForProduct(product : SKProduct) {
        let payment = SKMutablePayment(product : product)
        payment.quantity = 1
        
        SKPaymentQueue.default().add(payment)
    }
    
    // Transaction Observer
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
                break
            case .purchased:
                print("purchased")
                //verifiy the receipt; RMStore stuff
                self.validateReceipt({ (success, purchases) in
                    if success {
                        print("receipt validated")
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
                print("failed")
                queue.finishTransaction(transaction)
                break
            case .restored:
                print("restored")
                
                queue.finishTransaction(transaction)
                break
            }
        }
    }
    
    // some of this stuff is for non-auto renewing subscriptions
    //Receipt Verification completion handler
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
