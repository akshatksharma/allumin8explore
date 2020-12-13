//
//  registrationVC.swift
//  exploreAllumin8
//
//  Created by Kathy Zhou on 12/12/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class registrationVC: UIViewController {

    var db:Firestore?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore.firestore()

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
        
        // invalid email alert
        let invalidEmail = UIAlertController(title: "Alert", message: "Invalid email", preferredStyle: .alert)
        let close = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        invalidEmail.addAction(close)
        
        // invalid password alert
        let invalidPw = UIAlertController(title: "Alert", message: "Please set a password with at least 6 characters", preferredStyle: .alert)
        invalidPw.addAction(close)
        
        // invalid password alert
        let pwMatch = UIAlertController(title: "Alert", message: "The passwords you have entered do not match", preferredStyle: .alert)
        pwMatch.addAction(close)
        
        // existing email alert
        let user = UIAlertController(title: "Alert", message: "This email address is already associated to an account.", preferredStyle: .alert)
        user.addAction(close)
        
        // validate email as xxx@xx.xxx format
        // adapted from https://www.tutorialspoint.com/email-and-phone-validation-in-swift
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let validate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !validate.evaluate(with: email){
            print("invalid email")
            self.present(invalidEmail, animated: true, completion: nil)
            return
        }
        
        if password != confirmPw {
            print("passwords don't match")
            self.present(pwMatch, animated: true, completion: nil)
            return
        }
        if password.count < 6{
            print("Password too short")
            self.present(invalidPw, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.present(user, animated: true, completion: nil)
                print("unsuccessful sign up")
                return
            }
            print("successful sign up")
            print(authResult?.user.uid)
            guard let uid = authResult?.user.uid else{
                return
            }
            self.addUserToDB(uid: uid, name: name)
            let vc = self.storyboard?.instantiateViewController(identifier: "addHospital")
            self.navigationController?.pushViewController(vc!, animated: true)
        }


    }
    
    
    // adapted from https://firebase.google.com/docs/firestore/manage-data/add-data#swift
    
    func addUserToDB(uid: String, name: String){
        db?.collection("surgeons").document(uid).setData([
            "name":name
        ]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            }
            else{
                print("Document successfully written!")
            }
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
