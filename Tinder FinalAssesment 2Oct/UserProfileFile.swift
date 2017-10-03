//
//  UserProfileFile.swift
//  Tinder FinalAssesment 2Oct
//
//  Created by RaymondOoi on 02/10/2017.
//  Copyright © 2017 RaymondOoi. All rights reserved.
//

import Foundation

class UserProfile {
    
    var Id : String = ""
    var name : String = ""
    var age : Int = 0
    var gender : String = ""
    var email : String = ""
    var image : String = ""
    
    init(userId: String, userName: String , userAge: Int, userGender: String, userEmail: String, userImage: String) {
        
        self.Id = userId
        self.name = userName
        self.age = userAge
        self.gender = userGender
        self.email = userEmail
        self.image = userImage
    }
}
