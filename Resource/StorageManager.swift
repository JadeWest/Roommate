//
//  StorageManager.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/02.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPicutureCompletion = (Result<String, Error>) -> Void
    
}

extension StorageManager {
    
    /**
     프로필 사진 업로드
     
     - Parameter data: 프로필 사진 데이터
     - Parameter fileName: 파일명
     - Parameter completion: 콜백
     */
    public func uploadProfilePicture(data: Data,
                                     fileName: String,
                                     completion: @escaping UploadPicutureCompletion) {
        
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let currentUser = user else {
                return
            }
            guard let strongSelf = self else {
                return
            }
            // 원본처리
            // TODO: - 원본처리 이전에 원본이미지의 profile image, newsfeedprofile iamge를 저장할것.
            // TODO: - RegistrationViewController - 이미지 원본 등록, 프로필용 사진 전처리 및 원본과 같이 전송, 뉴스피드용 프로필이미지 전처리후 같이 전송
            strongSelf.storage.child("ProfileImages/\(currentUser.uid)/ProfileImage/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
                guard error == nil else {
                    print("사진을 데이터베이스에 업로드하는데에 실패했습니다.")
                    completion(.failure(StorageError.failedToUpload))
                    return
                }
                
                strongSelf.storage.child("ProfileImages/\(currentUser.uid)/ProfileImage/\(fileName)").downloadURL(completion: { url, error in
                    guard let url = url else {
                        completion(.failure(StorageError.failedToGetDownlaodURL))
                        return
                    }
                    
                    let absoluteURL = url.absoluteString
                    print("downloaded URL : \(absoluteURL)")
                    completion(.success(absoluteURL))
                })
            })
        }
        
    }
    
    public func downloadProfilePicture() {}
    public enum StorageError: Error {
        case failedToUpload
        case failedToGetDownlaodURL
    }
    
}
