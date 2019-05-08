//
//  BookListTableTableViewController.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit

class BookListTableTableViewController: UITableViewController , UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!

    
    @IBOutlet var tableViewTest: UITableView!
    
    var rssItems: [RSSItem]?
    var result : [RSSItem] = []
    //private var cellStates: [CellState]?
    
    var searchActive : Bool = false
    
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.leftBarButtonItem = addButton
        
        searchBar.delegate = self
        
        fetchData()
        
        print("user name: \(AppDelegate.currentUserName)")
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "books2.jpg")!)
        
        //navigationItem.searchController = searchController
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
       // self.tableView.reloadData()
    }
    
    
    @objc func insertNewObject(_ sender: Any){
        presentingViewController?.dismiss(animated: true, completion: nil)

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        
        // rssItems
        return AppDelegate.bookList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
           let item = AppDelegate.bookList[indexPath.row]
            cell.textLabel?.text = item.title
           // cell.detailTextLabel?.text = item.author + "- Year: " + item.pubDate
       
          //  let imageUrl = URL(string: item.imageSmall)!
            
          //  let imageData = try! Data(contentsOf: imageUrl)
            
          //  let image = UIImage(data: imageData)
            
          //  cell.imageView?.image = image
    
     // Configure the cell...

        return cell
    }
    
    
    private func fetchData()
    {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://www.goodreads.com/search.xml?key=2Cmyozf8OMukSq1It3mftQ&q=Harry+Potter") { (response) in
            self.rssItems = response
            
            print(self.rssItems!.count)
            self.result = self.rssItems!
            
            
        }
         print("hello \(result.count)")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
