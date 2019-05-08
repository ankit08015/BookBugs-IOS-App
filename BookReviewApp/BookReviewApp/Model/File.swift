//
//  File.swift
//  BookReviewApp
//
//  Created by administrator on 4/26/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import Foundation

class RSSItem {
    var title: String
    var author: String
    var pubDate: String
    var imageSmall: String
    var imageLarge: String
    var avgRating: String
    
    init(title: String, author: String, pubDate: String, imageSmall: String, imageLarge: String, avgRating : String) {
        self.title = title
        self.author = author
        self.pubDate = pubDate
        self.avgRating = avgRating
        self.imageLarge = imageLarge
        self.imageSmall = imageSmall
    
    }
}
