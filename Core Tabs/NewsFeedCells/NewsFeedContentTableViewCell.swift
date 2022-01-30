//
//  NewsFeedContentTableViewCell.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/22.
//

import UIKit
import SDWebImage

// 뉴스피드 컨텐츠(이미지, 링크, 텍스트 등)
class NewsFeedContentTableViewCell: UITableViewCell {

//    MARK: - Properties
    static let identifier = "NewsFeedContentTableViewCell"
    
    private let postImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = nil
        image.clipsToBounds = true
        return image
    }()
    
//    MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(postImageView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: UserPost) {
        postImageView.image = UIImage(named: "test")
        
        switch post.postType {
        case .photo:
            postImageView.sd_setImage(with: post.postURL, completed: nil)
//        case .video:
//            player = AVPlayer(url: post.postURL)
//            playerLayer.player = player
//            playerLayer.player?.volume = 0
//            playerLayer.player?.play()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
