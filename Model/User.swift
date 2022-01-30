//
//  User.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/25.
//

import Foundation
import FirebaseAuth

enum Gender: String {
    case female = "female"
    case male = "male"
    case other = "other"
    
    var getter: String {
        switch self {
        case .male: return "male"
        case .female: return "female"
        case .other: return "other"
        }
    }
}

/**
 # User
 
 ## Parameter:
 - id: 인덱스
 - email: 사용자 이메일
 - username: 앱 내 사용자 닉네임
 - gender: 성별
 - birthDate: 생년월일
 - createDate: 사용자 계정 생성일(YYYYMMDD)
 - modifiedDate: 사용자 계정 수정일
 
 ### Computed Parameter:
 - safeEmail: Firebase저장용 이메일 포맷변경
 - profilePictureURL: 프로필 사진이 저장된 URL 반환
 
 */
struct User {
    var email: String
    var username: String
    var createdDate: Date
    var modifiedDate: Date
    var gender: Gender?
    var birthDate: Date

    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureURL: String {
        guard let currentUser = Auth.auth().currentUser else {
            return ""
        }
        return "\(currentUser.uid)_profile_picture.png"
    }
    
    var birthDateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString: String = dateFormatter.string(from: birthDate)
        
        return dateString
    }
    
    var createdDateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString: String = dateFormatter.string(from: createdDate)
        
        return dateString
    }
    
    var modifiedDateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString: String = dateFormatter.string(from: modifiedDate)
        
        return dateString
    }
    
}
