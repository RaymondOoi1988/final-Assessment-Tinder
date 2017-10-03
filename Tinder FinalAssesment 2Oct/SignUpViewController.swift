//
//  SignUpViewController.swift
//  Tinder FinalAssesment 2Oct
//
//  Created by RaymondOoi on 02/10/2017.
//  Copyright © 2017 RaymondOoi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    var userImageUrl: String = ""
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBAction func uploadBtnTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
        
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    
    @IBOutlet weak var submitBtn: UIButton!{
        didSet{
    submitBtn.addTarget(self, action: #selector(userSignUp), for: .touchUpInside)
        }
    }


    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
                else {return}
            
            //skip loginpage
            present(vc, animated: true, completion: nil)
        }

        // Do any additional setup after loading the view.
    }

    // mark - upload Photo to Storage
    
    func uploadToStorage(_ image: UIImage) {
        let ref = Storage.storage().reference()
        let timeStamp = Date().timeIntervalSinceReferenceDate
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        ref.child("\(timeStamp).jpeg").putData(imageData, metadata:metaData) { (meta, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            if let downloadPath = meta?.downloadURL()?.absoluteString {
                self.userImageUrl = downloadPath
                self.userImageView.image = image
            }
        }
    }
    
    // mark - userSignUp
    
     @objc func userSignUp() {
        
        guard let name = nameTextField.text,
            let age = ageTextField.text,
            let gender = genderTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let userBio = bioTextView.text
            else {return}
        
        if userImageView.image == nil {
            anError("Missing image", "A profile image must be picked")
            return
        }
        
        
        if password != confirmPassword {
            anError("Password Error", "Password do not match")
            return
        } else if email == "" || password == "" {
            anError("Missing input text", "must fill in the text")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error)
            in
            if let validError = error {
                self.anError("Error", validError.localizedDescription)
            }
            if let validUser = user {
                let ref = Database.database().reference()
                
                //let randomAge = arc4random_uniform(30) + 1
                let post : [String:Any] = ["name": name, "age": age, "gender": gender, "email": email, "image": self.userImageUrl]
                
                //validUser.uid is the random id given by Firebase at authentication
                
                //option one
                //ref.child("students").childByAutoId() //option two at below
                ref.child("users").child(validUser.uid).setValue(post)
                
                self.navigationController?.popViewController(animated: true)
            }
        }

        
    }
    
    
    // mark - anError
    
    func anError(_ title:String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Please Try Again", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension SignUpViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        defer {
            ////no matter what happens, this code will run
            dismiss(animated: true, completion: nil)
        }
        
        guard let image = info [UIImagePickerControllerOriginalImage] as? UIImage
            else {return}
        
        uploadToStorage(image)
        
    }
    
}








