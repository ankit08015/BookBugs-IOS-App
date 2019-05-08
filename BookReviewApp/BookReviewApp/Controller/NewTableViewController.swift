//
//  NewTableViewController.swift
//  BookReviewApp
//
//  Created by administrator on 4/26/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit

class NewTableViewController: UITableViewController {
    
    var book: RSSItem = RSSItem(title: "Book title Details",author: "",pubDate: "",imageSmall: "",imageLarge: "",avgRating: "")

    
    @IBAction func cancelPredded(_ sender: Any) {
        AppDelegate.bookList.removeAll()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.leftBarButtonItem = addButton
        self.navigationItem.title = "All Books"
        
        
        print("user name: \(AppDelegate.currentUserName)")

    }

    @objc func insertNewObject(_ sender: Any){
        AppDelegate.bookList.removeAll()
        
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AppDelegate.bookList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let item = AppDelegate.bookList[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.author + "- Year: " + item.pubDate
        
        var imagePath = item.imageLarge == "" ? item.imageSmall : item.imageLarge
        
        let imageUrl = URL(string: imagePath)!
        
        let imageData = try! Data(contentsOf: imageUrl)
        
        let image = UIImage(data: imageData)
        
        cell.imageView?.image = image
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if editingStyle == .delete {
                // Delete the row from the data source
            AppDelegate.bookList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        book = AppDelegate.bookList[indexPath.row]
        performSegue(withIdentifier: "allReview", sender: self)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        book = AppDelegate.bookList[indexPath.row]
        performSegue(withIdentifier: "allReview", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
         let vc = segue.destination as! AllReviewViewController
         vc.book = book
        
    }


}
