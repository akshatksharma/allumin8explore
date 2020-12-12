//
//  AddCaptionVC.swift
//  exploreAllumin8
//
//  Created by Akshat Sharma on 12/11/20.
//  Copyright © 2020 Akshat Sharma. All rights reserved.
//

import UIKit

class AddCaptionVC: UIViewController {
    
    @IBOutlet weak var captionText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.isHidden = true
        captionText.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        // Do any additional setup after loading the view.
    }
    
    @objc func endEditing() {
        print("save photo hot")
        view.endEditing(true)
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

extension AddCaptionVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}



