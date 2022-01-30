//
//  NewsFeedActionTableViewCell.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/22.
//

import UIKit

protocol NewsFeedActionTableViewCellDelegate: AnyObject {
    func didTapLikeButton()
    func didTapCommentButton()
    func didTapSendButton()
}

// 좋아요 댓글 공유버튼
class NewsFeedActionTableViewCell: UITableViewCell {
    
//    MARK: - Properties
    weak var delegate: NewsFeedActionTableViewCellDelegate?
    static let identifier = "NewsFeedActionTableViewCell"
    
    private let likeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "hand.thumbsup", withConfiguration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "message", withConfiguration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "paperplane", withConfiguration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
//    MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(sendButton)
        
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - objc function
    @objc private func didTapLikeButton() {
        print("Like button tapped")
        delegate?.didTapLikeButton()
    }
    
    @objc private func didTapCommentButton() {
        print("Comment button tapped")
        delegate?.didTapCommentButton()
    }
    
    @objc private func didTapSendButton() {
        print("Send button tapped")
        delegate?.didTapSendButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            commentButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            commentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sendButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            sendButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 10),
            sendButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
