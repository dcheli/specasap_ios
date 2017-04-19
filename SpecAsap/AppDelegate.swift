//
//  AppDelegate.swift
//  SpecAsap
//
//  Created by David Cheli on 11/13/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler: (() -> Void)?
    let tintColor =  UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
    static var products = [Product]()
    
    static var productSet = [ProductSet]()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
         // Override point for customization after application launch.
        customizeAppearance()
        
  
        IAPManager.sharedInstance.setupPurchases{ (success) in
        
            // if success == true, then the user can make purchase, if success == false, the user cannot make purchases
 
            if success {
        
                // So the reason that you have to do all of this stuff here is for auto-renewable licenses. Ideally,
                // the ONLY standards available on the Standards screen are those that are still actice during the
                // subscription period. Only those items active are the ones that should display on the 
                // StandardsTableView
                
                // This call retrives the list of products, validates them against iTunes, and adds them to the Add On Store IAP section, additionally, it sets the AppDelegate.productSet variable which is used by StandardsTableViewControleler
                
                // So the question becomes, how do you prevent the application from leaving AppDelegate until you are really ready
                
                // what if you validated the receipt first, then using the product data, build your productSet and check with the itunes store stuff
                
                
                // I'm trying to do this. Get back a productSet for this particular user which inlcudes which products are active for the subexcription period. I'd hope that validateReceipt could handle this. If so, this could elimate part of the functionality of requestProducts. If I know at this point what products are enabled, it woould control which standards are enabled in the Standards Screen. 
                
                AppDelegate.validateReceipt()
                
                IAPManager.sharedInstance.requestProducts()
                
                UserDefaults.standard.set(true, forKey: "IAPCapable")
                UserDefaults.standard.synchronize()
    
            
   
                // The below is NEEDED if you are going to be using auto-renew subscription. I have temporarlity commented it out
                // in order to test on the simulator.

                // This is where u really get if an product is active or not. The reason you would do this here,
                // is to verify that the user still has access to the standard
                
 //               AppDelegate.validateReceipt()
           
            } else {
                print("Setup purchases failed")
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func customizeAppearance() {
        window?.tintColor = tintColor
        UISearchBar.appearance().barTintColor = tintColor
        UINavigationBar.appearance().barTintColor = tintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
    }
    
    static func validateReceipt() {
        print("Inside of validateReceipt")
        
        // This is used to determin which products are active.
        
        let receiptUrl = Bundle.main.appStoreReceiptURL

        if let receipt = try? NSData(contentsOf: receiptUrl!, options: []) {
            print("Uh...anything happening here?")
            let receiptData = receipt.base64EncodedString(options:[])
        
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        
            NetworkManager.sharedInstance.verifyReceipt(receiptData: receiptData)
            { (responseCode, data) -> Void in
                if responseCode == 200 {
                    let productMapper = ProductMapper()
                    let products = productMapper.mapProduct(fromUrl: data!)
                    
                    AppDelegate.products = products
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        print("Er ah.....")
                    }
                    
                } else {
                    print("error")
                }
            }
            
        }
    }
}

    

