//
//  DatabaseManager.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/22.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

final class DatabaseManager {
     
     public static let shared = DatabaseManager()
     
     private let database = Database.database().reference()
     private let auth = FirebaseAuth.Auth.auth()
     /**
      데이터베이스 저장을 위한 이메일 특수문자 처리
      
      # Returns: a new email string
      */
     static func safeEmail(emailAddress: String) -> String {
          var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
          return safeEmail
     }
}

// MARK: - Account Management
extension DatabaseManager {
     
     /**
      유저 존재여부확인
      - Parameter email: 회원가입시 기입한 email
      - Parameter completion: 회원존재여부 확인결과
      */
     public func userExists(with email: String,
                            completion: @escaping ((Bool) -> Void)) {
          var safeEmail = email.replacingOccurrences(of: ".", with: "-")
          safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
          database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
               guard let foundEmail = snapshot.value as? String else {
                    completion(false)
                    return
               }
               completion(true)
          })
     }
     
     /**
      데이터베이스에 유저 생성
      - Parameter user: 새로운 user 데이터
      - Parameter completion: DB입력 완료여부
      */
     public func insertUser(with user: User, completion: @escaping (Bool) -> Void) {
          
          /**
           ```
           safeEmail: {
               "username": user.username
           }
           ```
           */
          self.database.child(user.safeEmail).setValue([
               "username": user.username
          ], withCompletionBlock: { [weak self] error, _ in
               guard let strongSelf = self else {
                    completion(false)
                    return
               }
               
               guard error == nil else {
                    print("데이터베이스 쓰기에 실패했습니다...")
                    completion(false)
                    return
               }
               
               guard let gender = user.gender?.rawValue else {
                    print("사용자의 성별데이터가 존재하지않습니다.")
                    completion(false)
                    return
               }
               
               /**
                유저리스트 getAllUsers from Realtime Database
                */
               
               strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                    
                    
                    if var usersCollection: [[String: String]] = snapshot.value as? [[String: String]] {
                         
                         // user dictionary 추가
                         let newElement = [
                              "username": user.username,
                              "email": user.safeEmail,
                              "gender": gender,
                              "birthDate": user.birthDateFormatter,
                              "createdDate": user.createdDateFormatter,
                              "modifiedDate": user.modifiedDateFormatter
                         ]
                         
                         usersCollection.append(newElement)
                         
                         strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                              guard error == nil else {
                                   completion(false)
                                   return
                              }
                              completion(true)
                         })
                    }
                    
                    else {
                         
                         let newCollection: [[String: String]] = [
                              [
                                   "username": user.username,
                                   "email": user.safeEmail,
                                   "gender": gender,
                                   "birthDate": user.birthDateFormatter,
                                   "createdDate": user.createdDateFormatter,
                                   "modifiedDate": user.modifiedDateFormatter
                              ]
                         ]
                         
                         strongSelf.database.child("users").setValue(newCollection,
                                                                     withCompletionBlock: { error, _ in
                              guard error == nil else {
                                   completion(false)
                                   return
                              }
                              completion(true)
                         })
                    }
               })
          })
     }
     
     /**
      특정 이메일 가진 유저 가져오기
      */
     public func getUserWithEmail(with email: String, completion: @escaping (Result<String, Error>) -> Void) {
          self.database.child("\(email)").observeSingleEvent(of: .value, with: { snapshot in
               guard let value = snapshot.value as? String else {
                    completion(.failure(DatabaseError.failedToGet))
                    return
               }
               completion(.success(value))
          }) { error in
               print(error.localizedDescription)
          }
     }

     /**
      모든유저값 가져오기
      */
     public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
          self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
               guard let value = snapshot.value as? [[String: String]] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
               }
               print(value)
          }) { error in
               print(error.localizedDescription)
          }
     }

     public enum DatabaseError: Error {
          case failedToFetch
          case failedToGet
     }

}
