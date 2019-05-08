//
//  HomePageViewController.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn


class HomePageViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var userDefault = UserDefaults()
    
    @IBOutlet weak var searchTextBok: UITextField!
    
    var postData = ["Sample"]
    var ref: DatabaseReference!
    var databaseHandle = DatabaseHandle()
    
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        //fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        AppDelegate.loadReviews()

        reviews = AppDelegate.reviews
        
        print(reviews.count)
        
        AppDelegate.bookList.removeAll()
        
        guard let email = Auth.auth().currentUser?.email else { return }
        
        AppDelegate.currentUserEmail = email
       AppDelegate.getUserName(userEmail: email)
        
        print("email: \(email)")
        print("user name: \(AppDelegate.currentUserName)")
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "books2.jpg")!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
       
        // Configure the cell...
       let item = reviews[indexPath.row]
        
        cell!.textLabel?.text = "Rating: " + item.rating + " Title: " + item.title
        cell!.detailTextLabel?.text = item.name + " Says: " + item.review
        
        let imageUrl = URL(string: item.imageUrl)!
        
        let imageData = try! Data(contentsOf: imageUrl)
        
        let image = UIImage(data: imageData)
        
        cell!.imageView?.image = image
        
        return cell!
    }
    
    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        do {
            
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            userDefault.removeObject(forKey: "usersignedin")
            userDefault.synchronize()
            self.dismiss(animated: true, completion: nil)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func onSearchText(_ sender: UIButton) {
        var searchText = searchTextBok.text
        
        if( searchText == ""){
            AppDelegate.showAlert(info: "Alert:",msg: "Please enter some text to search!",in: self)
            return
        }
        
        //AppDelegate.bookList.removeAll()
        
        searchText = searchText!.replacingOccurrences(of: " ", with: "+")
        fetchData(searchText: searchText!)
        print(AppDelegate.bookList.count)
        if AppDelegate.bookList.count > 0 {
            self.performSegue(withIdentifier: "goToSearch", sender: self)
        }

    }

    
    private func fetchData(searchText: String)
    {
        let usrNew =  "https://www.goodreads.com/search.xml?key=2Cmyozf8OMukSq1It3mftQ&q=\(searchText)"
        
        print(usrNew)
        
        let feedParser = FeedParser()
        feedParser.parseFeed(url: usrNew) {
            (response) in

        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
