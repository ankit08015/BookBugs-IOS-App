//
//  Review.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import Foundation
import UIKit

class Review
{
    var title: String
    let review: String
    var name: String
    var rating: String
    var imageUrl: String

    
    init(title: String, review: String, name: String, rating: String, imageUrl: String){
        self.title = title
        self.review = review
        self.name = name
        self.rating = rating
        self.imageUrl = imageUrl
        
    }

}

