//
//  LoginVC.swift
//  exploreAllumin8
//
//  Created by Kathy Zhou on 12/12/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // adapted from Firebase documentation: https://firebase.google.com/docs/auth/ios/start
    @IBAction func login(_ sender: Any) {
        
        // invalid login alert
        var invalid = UIAlertController(title: "Alert", message: "Incorrect email or password", preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .cancel, handler: {(action) -> Void in
            print("closed")
            })
        invalid.addAction(close)
        
        
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("invalid email")
            return
        }
        guard let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("invalid password")
            return
        }

        if email != "" && password != "" {
            Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
                guard let strongSelf = self else { return }
                if error != nil {
                    print("Invalid email or password")
                    self?.present(invalid, animated: true, completion: nil)
                    return
                }
                print("successful login")
                print(authResult!.user.uid)
            }
        }
        else {
            print("empty input")
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
