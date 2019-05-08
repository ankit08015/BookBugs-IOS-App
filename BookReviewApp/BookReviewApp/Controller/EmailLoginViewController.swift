//
//  EmailLoginViewController.swift
//  BookReviewApp
//
//  Created by administrator on 4/25/19.
//  Copyright © 2019 ios-development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

class EmailLoginViewController: UIViewController, GIDSignInUIDelegate{

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logInSelector: UISegmentedControl!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var ref: DatabaseReference!
    var isSignIn = false
    
    var userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
             self.view.backgroundColor = UIColor(patternImage: UIImage(named: "books2.jpg")!)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.isHidden = false
        nameLabel.isHidden = false
        
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                
                let name = self.nameTextField.text!
                let userDict : [String: String] = ["name": name, "email": email, "password": password]
                self.ref.child("Users").childByAutoId().setValue(userDict)
                self.signInUser(email: email, password: password)
                
            }
            
            else if error?._code == AuthErrorCode.userNotFound.rawValue {
                print("No User exist. Register user")
            }
            else {
                print(error?.localizedDescription as Any)
                AppDelegate.showAlert(info: "Alert:",msg: (error?.localizedDescription)!,in: self)
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func signInUser(email: String, password: String){

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "homeSegue", sender: self)

            }
            else {
                print(error?.localizedDescription as Any)
                AppDelegate.showAlert(info: "Alert:",msg: (error?.localizedDescription)!,in: self)
            }
        }
    }
    
    func emailFieldValidator()->Bool{
        return true
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        let name = nameTextField.text!

        
        if !emailFieldValidator(){
            return
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if isSignIn{
            if( email == "" || password == ""){
                AppDelegate.showAlert(info: "Alert:",msg: "None of the fields can be blank!",in: self)
                return
            }
            else if isValidEmail(testStr: email)==false {
                AppDelegate.showAlert(info: "Alert:",msg: "Enter valid email address",in: self)
                return
                
            }
            
        signInUser(email: email, password: password)
            
        }
        else {
            
            if(name == "" || email == "" || password == ""){
                AppDelegate.showAlert(info: "Alert:",msg: "None of the fields can be blank!",in: self)
                return
            }
            else if isValidEmail(testStr: email)==false {
                AppDelegate.showAlert(info: "Alert:",msg: "Enter valid email address",in: self)
                return
                
            }
            
            createUser(email: email, password: password)

        }

    }
    
    @IBAction func signButtonControlChanged(_ sender: UISegmentedControl) {
        
        // Flip the label
        isSignIn = !isSignIn
        
        // Check the label and button label
        
        if isSignIn {
            loginButton.setTitle("Sign In", for: .normal)
            nameTextField.isHidden = true
            nameLabel.isHidden = true
        }
        else {
            loginButton.setTitle("Register", for: .normal)
            nameTextField.isHidden = false
            nameLabel.isHidden = false
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
