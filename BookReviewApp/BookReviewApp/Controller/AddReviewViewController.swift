
//
//  AddReviewViewController.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddReviewViewController: UIViewController, UITextViewDelegate {
    
    var book : RSSItem = RSSItem(title: "",author: "",pubDate: "",imageSmall: "",imageLarge: "",avgRating: "")
    
    var ref: DatabaseReference!

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var addReview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        book = AppDelegate.book
        AppDelegate.reviewsByUser.removeAll()
        AppDelegate.loadReviewsSortByUSer()
        
        addReview.delegate = self
        
        addReview.text = "Please enter review."
        
        addReview.textColor = UIColor.lightGray
        
        navItem.title = ""
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "books2.jpg")!)        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addReview.textColor == UIColor.lightGray {
            addReview.text = nil
            addReview.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if addReview.text.isEmpty {
            addReview.text = "Please enter review."
            addReview.textColor = UIColor.lightGray
        }
    }

    @IBAction func cancelAddReview(_ sender: Any) {
        dismiss(animated:false , completion :nil)
    }

    @IBAction func addReview(_ sender: UIButton) {
        let review = addReview.text
        
        if( review == "" || review == "Please enter review."){
            AppDelegate.showAlert(info: "Alert:",msg: "Review can not be blank!",in: self)
            return
        }
        let userName = AppDelegate.currentUserName == "" ? "Ankit" : AppDelegate.currentUserName
        
        let imagePath = book.imageLarge == "" ? book.imageSmall : book.imageLarge

        let userDict : [String: String] = ["name": userName, "title": book.title, "image":imagePath, "rating": book.avgRating, "review": review!]
        self.ref.child("Reviews").childByAutoId().setValue(userDict)
        
        AppDelegate.loadReviews()
        
        AppDelegate.loadReviewsSortByUSer()

        dismiss(animated:false , completion :nil)
        
        
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated:false , completion :nil)
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
