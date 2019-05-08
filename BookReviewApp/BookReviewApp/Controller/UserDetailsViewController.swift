//
//  UserDetailsViewController.swift
//  BookReviewApp
//
//  Created by administrator on 4/26/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource

{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var postData = ["Sample"]
    var ref: DatabaseReference!
    var databaseHandle = DatabaseHandle()
    
    var reviews = [Review]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        
        userNameTextField.text = AppDelegate.currentUserName
        userEmailTextField.text =   AppDelegate.currentUserEmail
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        AppDelegate.loadReviewsSortByUSer()
        
        reviews = AppDelegate.reviewsByUser
        
        print(reviews.count)
        
        AppDelegate.bookList.removeAll()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "books2.jpg")!)
    }
    
    @IBAction func cancelView(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
