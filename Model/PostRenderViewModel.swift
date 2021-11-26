//
//  PostRenderViewModel.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/25.
//

import Foundation

enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost)
    case actions(provider: String)
    case comments(comments: [PostComment])
}

struct PostRenderViewModel {
    let renderType: PostRenderType
}
