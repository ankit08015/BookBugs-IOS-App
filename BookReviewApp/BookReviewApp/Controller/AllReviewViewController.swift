//
//  AllReviewViewController.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit

class AllReviewViewController: UIViewController {
    
    var book: RSSItem = RSSItem(title: "Book Details",author: "",pubDate: "",imageSmall: "",imageLarge: "",avgRating: "")

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var pubYearTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var bookTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookTitle.text = book.title
        authorTextField.text = book.author
        pubYearTextField.text = book.pubDate
        ratingTextField.text = book.avgRating
        
        let imagePath = book.imageLarge == "" ? book.imageSmall : book.imageLarge

        let imageUrl = URL(string: imagePath)!
        
        let imageData = try! Data(contentsOf: imageUrl)
        
        let image = UIImage(data: imageData)
        
        imageView.image = image
        
       // let vc = AddReviewViewController()
       // vc.book = self.book
        AppDelegate.book = book
        
        print("user name: \(AppDelegate.currentUserName)")
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "books2.jpg")!)
        

        // Do any additional setup after loading the view.
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
