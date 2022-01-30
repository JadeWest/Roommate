//
//  RoomatePost.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/27.
//

import Foundation

public struct RoomatePost {
    let identifier: String
    let profileImage: URL
    let targetLocation: String
    let desc: String
    let owner: User
}
