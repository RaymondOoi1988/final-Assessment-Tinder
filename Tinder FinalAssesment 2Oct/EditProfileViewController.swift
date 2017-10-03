//
//  EditProfileViewController.swift
//  Tinder FinalAssesment 2Oct
//
//  Created by RaymondOoi on 03/10/2017.
//  Copyright © 2017 RaymondOoi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditProfileViewController: UIViewController {
    
    var selectedUser: UserProfile?
    var ref : DatabaseReference!
    var isEdit : Bool = true
    
    
    @IBOutlet weak var userEditImageView: UIImageView!
    
    @IBOutlet weak var editPhotoBtn: UIButton!
    
    @IBOutlet weak var editUserNameTextField: UITextField! {
        didSet{
            editUserNameTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var editUserAgeTextField: UITextField!{
        didSet{
            editUserAgeTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var userBioTextView: UITextView!{
        didSet{
            userBioTextView.isUserInteractionEnabled = false
        }
    }
    
    
    
    @IBOutlet weak var editSaveBtnTapped: UIButton!{
        didSet{
            editSaveBtnTapped.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let name = selectedUser?.name,
            let age = selectedUser?.age
            else {return}
        
         editUserNameTextField.text = selectedUser?.name
        editUserAgeTextField.text = "\(age)"
       editSaveBtnTapped.titleLabel?.text = "Edit"
        
        // Do any additional setup after loading the view.
    }
    
  @objc func editButtonTapped() {
        if editSaveBtnTapped.titleLabel?.text == "Edit" {
            editSaveBtnTapped.setTitle("Done", for: .normal)
            editUserNameTextField.isUserInteractionEnabled = true
            editUserAgeTextField.isUserInteractionEnabled = true
            userBioTextView.isUserInteractionEnabled = true
        } else {
            ref = Database.database().reference()
            guard let id = selectedUser?.Id,
                let name = editUserNameTextField?.text,
                let userBio = userBioTextView?.text,
                let agestring = editUserAgeTextField?.text,
                let age = Int(agestring)
                else {return}
            
            let post: [String:Any] = ["name": name, "age" : age]
            // dig path to reach a specific student
            ref.child("students").child(id).updateChildValues(post)
            editSaveBtnTapped.setTitle("Edit", for: .normal)
            
        }
    }
    

    

}
