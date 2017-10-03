//
//  ViewController.swift
//  Tinder FinalAssesment 2Oct
//
//  Created by RaymondOoi on 02/10/2017.
//  Copyright © 2017 RaymondOoi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    var users: [UserProfile] = []

    @IBOutlet weak var matchingTableView: UITableView!{
        didSet{
            //matchingTableView.delegate = self
            //matchingTableView.dataSource = self
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain
            , target: self, action: #selector(signOutUser))
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserMember() {
        ref = Database.database().reference()
        
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            guard let info = snapshot.value as? [String:Any] else {return}
            print(snapshot.key)
            
             if let userName = info["userName"] as? String,
                let userAge = info["useAge"] as? Int,
                let userGender = info["userGender"] as? String,
                let userEmail = info["userEmail"] as? String,
                let userImage = info["userImage"] as? String {
                
                let newUser = UserProfile(userId: snapshot.key, userName: userName, userAge: userAge, userGender: userGender, userEmail: userEmail, userImage: userImage)
                
                self.users.append(newUser)
                
                let index = self.users.count - 1
                let indexPath = IndexPath(row: index, section: 0)
                self.matchingTableView.insertRows(at: [indexPath], with: .right)
            }
            
        })
        ref.child("users").observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [String:Any] else {return}
            
            print(info)
        })
        
        ref.child("users").observe(.childRemoved, with: { (snapshot) in
            guard let info = snapshot.value as? [String:Any] else {return}
            
            let deletedID = snapshot.key
            print(info)
            
            if let deletedIndex = self.users.index(where: {(user) -> Bool in
                return user.Id == deletedID
                
            }) {
                self.users.remove(at: deletedIndex)
                //let index = self.students.count - 1
                let indexPath = IndexPath(row: deletedIndex, section: 0)
                
                self.matchingTableView.deleteRows(at: [indexPath], with: .fade)
            }
        })
        
        ref.child("users").observe(.childChanged, with: {(snapshot) in
            guard let info = snapshot.value as? [String:Any] else {return}
            
            guard let name = info["name"] as? String,
                let age = info["age"] as? Int
                
                
                
                else {return}
            
            if let matchedIndex = self.users.index(where: { (users) -> Bool in
                return users.Id == snapshot.key
            }) {
                let changedUser = self.users[matchedIndex]
                changedUser.age = age
                changedUser.name = name
                
                let indexPath = IndexPath(row: matchedIndex, section: 0)
                self.matchingTableView.reloadRows(at: [indexPath], with: .none)
            }
        })
        
   }
    
     @objc func signOutUser() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    
    }
    

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return users.count
        }
        
        
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = matchingTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? MatchViewTableViewCell  else {return UITableViewCell()}
            
          let user = users[indexPath.row]
            
        cell.nameLabel.text = user.name
        cell.agelabel.text = "\(user.age)"
            
            
        guard let url = URL(string: user.image) else {return UITableViewCell()}
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    cell.UserImageView.image = UIImage(data: data)
                    
                }
            }
            
        }
        task.resume()
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {return}
        let selectedUser = users[indexPath.row]
        
        destination.selectedUser = selectedUser
        navigationController?.pushViewController(destination, animated: true)
        
    }
}

    
    
    
    


