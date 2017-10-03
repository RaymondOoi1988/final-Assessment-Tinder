//
//  LogInViewController.swift
//  Tinder FinalAssesment 2Oct
//
//  Created by RaymondOoi on 02/10/2017.
//  Copyright © 2017 RaymondOoi. All rights reserved.
//

import UIKit
import FirebaseAuth // for login

class LogInViewController: UIViewController {
    
    @IBOutlet weak var LogInEmailTextField: UITextField!
    @IBOutlet weak var LogInPasswordTextField: UITextField!
    
    @IBOutlet weak var GetStartBtn: UIButton!{
        didSet{
            GetStartBtn.addTarget(self, action: #selector(userLogIn), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    //mark - userLogIn
    @objc func userLogIn() {
        
        guard let email = LogInEmailTextField.text else {return}
        guard let password = LogInPasswordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                print(validError.localizedDescription)
                self.anError("Error", validError.localizedDescription)
                
        }
        if self.LogInEmailTextField.text == "" {
           self.anError("InValid Email", "Incorrect Email")
           return
                
        } else if self.LogInPasswordTextField.text == "" {
            self.anError("Invalid Pasword", "Incorrect Password")
            return
            
        }
            
        if let validUser = user {
           guard let logInVc = self.storyboard?.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController else {return}
                
            self.present(logInVc, animated: true, completion: nil)
            }
            
    
        }
        
    }
    
    // mark - anError
    func anError(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Please Insert Correctly", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    

    
}
