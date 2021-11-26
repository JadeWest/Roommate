//
//  UserPost.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/25.
//

import Foundation

public enum UserPostType: String {
    case photo = "Photo"
//    case video = "Video"
}

public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL
    let caption: String?
    let linkCount: [PostLikes]
    let comments: [PostComment]
    let createdDate: Date
    let owner: User
}

struct PostLikes {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}
