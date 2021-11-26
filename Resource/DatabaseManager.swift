//
//  DatabaseManager.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/22.
//

import Foundation
import FirebaseDatabase
import UIKit

final class DatabaseManager {
     
     static let shared = DatabaseManager()
     
     private let database = Database.database().reference()
     
     static func safeEmail(emailAddress: String) -> String {
          var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
          safeEmail.replacingOccurrences(of: "@", with: "-")
          return safeEmail
     }
}

// MARK: - Account Management
extension DatabaseManager {
     
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
     
     /// Inserts new user to database
     public func insertUser(with user: User, completion: @escaping (Bool) -> Void) {
          database.child(user.safeEmail).setValue([
               "username": user.username
          ], withCompletionBlock: { error, _ in
               guard error == nil else {
                    print("데이터베이스 쓰기에 실패했습니다...")
                    completion(false)
                    return
               }
               
               self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                    
                    if var usersCollection = snapshot.value as? [[String: String]] {
                         
                         // user dictionary 추가
                         let newElement = [
                              "username": user.username,
                              "email": user.safeEmail
                              
                         ]
                         
                         usersCollection.append(newElement)
                         
                         self.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                              guard error == nil else {
                                   completion(false)
                                   return
                              }
                              
                              completion(true)
                         })
                    }
                    
                    else {
                         
                         
                         // 배열만들기
                         let newCollection: [[String: String]] = [
                              [
                                   "username": user.username,
                                   "email": user.email
                                   
                              ]
                         ]
                         
                         self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
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
     
     public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
          database.child("users").observeSingleEvent(of: .value, with: { snapshot in
               guard let value = snapshot.value as? [[String: String]] else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
               }
          }) { error in
               print(error.localizedDescription)
          }
     }
     
     public enum DatabaseError: Error {
          case failedToFetch
     }
}
