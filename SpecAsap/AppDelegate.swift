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
    static var standardNames = [String]()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         // Override point for customization after application launch.
        customizeAppearance()
        
  
        IAPManager.sharedInstance.setupPurchases{ (success) in
            // Test against success
            
            if success {
                // This call retrives the list of products, validates them against iTunes, and adds them to the Add On Store IAP section
                IAPManager.sharedInstance.requestProducts()
                
                UserDefaults.standard.set(true, forKey: "IAPCapable")
                UserDefaults.standard.synchronize()
                
   
                // The below is NEEDEDif you are going to be using auto-renew subscription. I have temporarlity commented it out
                // in order to test on the simulator.

                
                
                AppDelegate.validateReceipt()
                
                
                // The below is just temporary at the moment
      /*          self.getProductIds() {
                    (identifiers: [String]) in
                    AppDelegate.standardNames = identifiers
                }
      */          
                // I put this sleep in, because I think it's needed for some of the inital REST services to complete, particularly
                // the productlist and verifyreceipt
                sleep(3)
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
        
        let receiptUrl = Bundle.main.appStoreReceiptURL

        if let receipt = try? NSData(contentsOf: receiptUrl!, options: []) {
            let receiptData = receipt.base64EncodedString(options:[])
        
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let methodStart = Date()
            
            NetworkManager.sharedInstance.verifyReceipt(receiptData: receiptData)
            { (responseCode, data) -> Void in
                if responseCode == 200 {
                    let productMapper = ProductMapper()
                    let products = productMapper.mapProduct(fromUrl: data!)
                    
                    AppDelegate.products = products
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    
                } else {
                    print("error")
                }
            }
            

            let methodFinish = Date()
            let executionTime = methodFinish.timeIntervalSince(methodStart)
            print("Execution time for Verifying the Receipt was \(executionTime) ms")
       
  
        }
    }
}

// Once satisfied.... remove all the stuff below
        
        /*
         let username = "dcheli"
         let password = "aside555"
         let loginString = NSString(format: "%@:%@", username, password)
         let loginData = loginString.data(using: String.Encoding.utf8.rawValue)! as Data
         let base64LoginString = loginData.base64EncodedString(options: Data.Base64EncodingOptions())
         
         let request = NSMutableURLRequest(url: URL(string: "https://dataasap.com/specasap/webapi/v1/IAPReceipt/verifyapplereceipt")!)
         request.httpMethod = "POST"
         request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
         request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
         request.httpBody = receiptData.data(using: String.Encoding.ascii)
         
         let session = URLSession.shared
         */

        
   /*
         
            
            
            let dataTask = session.dataTask(with: request as URLRequest){
                data, response, error in
                // this is the callback that is being pass data, response, error
                // This invokes the UI update in the main thread.
                DispatchQueue.main.async {
                    print("AppDelegate completion handling is setting isNetworkActivityIndicator to false")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                if let error = error {
                    print(error.localizedDescription)
                } else if (response as? HTTPURLResponse) != nil {
                    do {
                        let jsonDict  = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as AnyObject
                        if(jsonDict.count > 0) {
                            AppDelegate.products.removeAll()
                            if let json = jsonDict as? [[String: AnyObject]] {
                                for item in json {
                                    let productId = item["productId"] as? String ?? ""
                                    let enabled =  item["enabled"] as? String ?? ""
                                    let displayName = item["displayName"] as? String ?? ""
                                    let version = item["version"] as? String ?? ""
                                    AppDelegate.products.append(Product(productId: productId, enabled: enabled , displayName : displayName, version: version))
                                }
                            }
                        }
                    } catch {
                        print("Something is messed")
                    }
                }
            }
            dataTask.resume()
            } else {
                print("AppDelegate.validateReceipt() did not find local receipt.")
            }
   */     
        
        
    //}
    
    
    
    
    //myshit
/*
      func getProductIds(completion : @escaping (_ completion : [String]) -> Void) {
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
        
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                    if jsonArray.count > 0 {
                        for json in jsonArray as! [Dictionary<String, String>]{
                            let productId = json["displayName"]!
                            identifiers.append(productId)
                        }
                    }
                DispatchQueue.main.async {
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                }
                
                let methodFinish = Date()
                let executionTime = methodFinish.timeIntervalSince(methodStart)
                print("Execution time for productlist request was \(executionTime) ms")
            } catch {
                print("Error: \(error)")
            }
            // I suppose it(?) returned??? so this is called now?
            completion(identifiers)
            
        })
        dataTask.resume()
    }
 */   
    

