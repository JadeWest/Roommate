//
//  User.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/25.
//

import Foundation

enum Gender {
    case male, female, other
}

struct User {
    let email: String
    let username: String
//    let password: String
    let createdDate: Date
    let modifiedDate: Date
    let gender: Gender
    let birthDate: Date
//    let targetLocation: String? = ""
    
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureURL: URL? {
        return URL(string: "\(safeEmail)_profile_picture.png")
    }
}
