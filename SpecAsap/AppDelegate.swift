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
    
    // fucking around
    let errorCode:Int32 = 173
    
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
                AppDelegate.validateReceipt()
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
        var response: URLResponse?
        var error: NSError?
        
        let receiptUrl = Bundle.main.appStoreReceiptURL
        let receipt: NSData = try! NSData(contentsOf: receiptUrl!, options: [])
        
        let receiptData = receipt.base64EncodedString(options:[])
        //print("ReceiptData \(receiptData)")
        
        let request = NSMutableURLRequest(url: URL(string: "https://dataasap.com/specasap/webapi/v1/IAPReceipt/verifyapplereceipt")!)
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let username = "dcheli"
        let password = "aside555"
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)! as Data
        let base64LoginString = loginData.base64EncodedString(options: Data.Base64EncodingOptions())
        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")

        var err: NSError?
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = receiptData.data(using: String.Encoding.ascii)
        
   
        let dataTask = session.dataTask(with: request as URLRequest){
            data, response, error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                do{
                let jsonDict  = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as AnyObject
            //    print("HttpResponse is \(httpResponse.statusCode)")
                //print("Response returned is: \(jsonDict)")
                if(jsonDict.count > 0) {
                    AppDelegate.products.removeAll()
                    if let json = jsonDict as? [[String: AnyObject]] {
                            for item in json {
                              //  print("Item is \(item)")
                                
                                let productId = item["productId"] as? String ?? ""
                                let enabled =  item["enabled"] as? String ?? ""
                                
                               // print("Product  is \(productId)")
                                //print("Enabled is \(enabled)")
                                AppDelegate.products.append(Product(productId: productId, enabled: enabled ))
                        }
                    }
                }

                
                } catch {
                    print("Something is messed")
                }
            }
        
        }
        dataTask.resume()
        
    }
}
