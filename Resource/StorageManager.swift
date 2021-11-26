//
//  StorageManager.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/02.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPicutreCompletion = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(data: Data,
                                     fileName: String,
                                     completion: @escaping UploadPicutreCompletion) {
        storage.child("ProfileImages/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print("사진을 데이터베이스에 업로드하는데에 실패했습니다.")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self.storage.child("ProfileImages/\(fileName)").downloadURL(completion: { url, error in
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
    
    public enum StorageError: Error {
        case failedToUpload
        case failedToGetDownlaodURL
    }
}
