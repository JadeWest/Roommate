//
//  NewsFeedFooterTableViewCell.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/22.
//

import UIKit

protocol NewsFeedGeneralTableViewCellDelegate: AnyObject {
    
}

// 댓글 미리보기 영역
class NewsFeedGeneralTableViewCell: UITableViewCell {

    static let identifier = "NewsFeedGeneralTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemOrange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
