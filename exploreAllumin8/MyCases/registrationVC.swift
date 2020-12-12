//
//  registrationVC.swift
//  exploreAllumin8
//
//  Created by Kathy Zhou on 12/12/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth

class registrationVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let name = nameField.text else{
            return
        }
        guard let email = emailField.text else{
            return
        }
        guard let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
            return
        }
        guard let confirmPw = confirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
            return
        }
        
        // validate email as xxx@xx.xxx format
        // adapted from https://www.tutorialspoint.com/email-and-phone-validation-in-swift
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let validate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !validate.evaluate(with: email){
            print("invalid email")
            return
        }
        
    
        if password != confirmPw {
            print("passwords don't match")
            return
        }
        if password.count < 6{
            print("Password too short")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print("unsuccessful sign up")
                return
            }
            print("successful sign up")
            self.navigationController?.popViewController(animated: true)
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
