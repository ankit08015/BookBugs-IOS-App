//
//  User.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import Foundation

import UIKit

class User
{
    var password: String
    let uid: String
    var fullName: String
    var email: String
    
    init(uid: String, password: String, email: String, fullName: String)
    {
        self.uid = uid
        self.password = password
        self.email = email
        self.fullName = fullName
    }

    
    
    func toDictionary() -> [String : Any]
    {
        return [
            "uid" : uid,
            "password" : password,
            "fullName" : fullName,
            "email" : email
        ]
    }
}




