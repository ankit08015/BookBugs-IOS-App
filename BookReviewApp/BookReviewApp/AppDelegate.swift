//
//  AppDelegate.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate{
    

    var window: UIWindow?
    let userDefault = UserDefaults()
    
    static var bookList: Array<RSSItem> = Array()
    static var ref: DatabaseReference!
    static var databaseHandle = DatabaseHandle()
    
    static var reviews = [Review]()
    static var reviewsByUser = [Review]()
    
    static var currentUserEmail = ""
    static var currentUserName = ""
    
    static var book : RSSItem = RSSItem(title: "",author: "",pubDate: "",imageSmall: "",imageLarge: "",avgRating: "")
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        AppDelegate.loadReviews()
        AppDelegate.loadReviewsSortByUSer()
       // AppDelegate.getUserName(userEmail: (Auth.auth().currentUser?.email)!)
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    class func showAlert (info: String, msg: String, in vc: UIViewController){
        let alertController = UIAlertController(title: info, message: msg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    class func loadReviews() {
        
        // Do any additional setup after loading the view.
        //fetchData()
     
        ref = Database.database().reference()
        
        // retrieve the post and listen for changes
        
        //  let userID = Auth.auth().currentUser?.uid
        databaseHandle = ref.child("Reviews").observe(DataEventType.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //print(value)
            // if let body = snapshot.value as? String {
            //   print(body)
            // }
            
            let keys = value!.allKeys as? [String]

            
            for key in keys! {
                
                self.ref.child("Reviews").child(key).observe(DataEventType.value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let username = value?["name"] as? String ?? ""
                    let title = value?["title"] as? String ?? ""
                    let review = value?["review"] as? String ?? ""
                    let rating = value?["rating"] as? String ?? ""
                    
                    let imageUrl = value?["image"] as? String ?? ""
                    
                    AppDelegate.reviews.append(Review(title: title, review: review, name: username, rating: rating, imageUrl: imageUrl))
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    class func getUserName(userEmail: String) {
        
        print(userEmail)
        
        
        
        ref = Database.database().reference()
        
        // retrieve the post and listen for changes
        
        //  let userID = Auth.auth().currentUser?.uid
        databaseHandle = ref.child("Users").observe(DataEventType.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
           
            let keys = value!.allKeys as? [String]
            
            
            for key in keys! {
                
                self.ref.child("Users").child(key).observe(DataEventType.value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let username = value?["name"] as? String ?? ""
                    let email = value?["email"] as? String ?? ""
                    
                    print(username)
                    print(email)
                    
                    if email == userEmail {
                        AppDelegate.currentUserName = username
                    
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    class func loadReviewsSortByUSer() {
        // Do any additional setup after loading the view.
        //fetchData()
        
        ref = Database.database().reference()
        let currUser = AppDelegate.currentUserName
        
        // retrieve the post and listen for changes
        
        //  let userID = Auth.auth().currentUser?.uid
        databaseHandle = ref.child("Reviews").observe(DataEventType.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //print(value)
            // if let body = snapshot.value as? String {
            //   print(body)
            // }
            
            let keys = value!.allKeys as? [String]
            
            for key in keys! {
                
                self.ref.child("Reviews").child(key).observe(DataEventType.value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let username = value?["name"] as? String ?? ""
                    let title = value?["title"] as? String ?? ""
                    let review = value?["review"] as? String ?? ""
                    let rating = value?["rating"] as? String ?? ""
                    
                    let imageUrl = value?["image"] as? String ?? ""
                    if currUser == username {
                        
                    
                    AppDelegate.reviewsByUser.append(Review(title: title, review: review, name: username, rating: rating, imageUrl: imageUrl))
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
                if error == nil {                    
                    let userDict : [String: String] = ["name": (result?.user.displayName)!, "email": (result?.user.email)!, "password":"None"]
                    AppDelegate.ref.child("Users").childByAutoId().setValue(userDict)
                    
                    self.userDefault.set(true, forKey: "usersignedin")
                    self.userDefault.synchronize()
                                 
                    self.window?.rootViewController!.performSegue(withIdentifier: "homeSegue", sender: nil)
                } else {                    
                    print(error?.localizedDescription as Any)
                }
            }
            }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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


}

