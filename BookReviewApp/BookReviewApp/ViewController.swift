//
//  ViewController.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance()?.uiDelegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "books1.jpg")!)
    }


}

