//
//  NewsFeedHeaderTableViewCell.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/22.
//

import UIKit
import SDWebImage

protocol NewsFeedHeaderTableViewCellDelegate: AnyObject {
    func didTapMoreButton()
}

// 프로필 사진영역 Cell
class NewsFeedHeaderTableViewCell: UITableViewCell {

//    MARK: - Properties
    
    weak var delegate: NewsFeedHeaderTableViewCellDelegate?
    static let identifier = "NewsFeedHeaderTableViewCell"
    
    private let profilePhotoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.tintColor = UIColor(named: "IdColor")
        image.image = UIImage(systemName: "person.crop.circle.fill")
        return image
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(profilePhotoImage)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profilePhotoImage.layer.cornerRadius = profilePhotoImage.frame.height / 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profilePhotoImage.image = nil
        
    }
    
    public func configure(with model: User) {
        usernameLabel.text = model.username
        profilePhotoImage.image = UIImage(systemName: "person.circle")
    }
    
    @objc private func didTapMoreButton() {
        print("more button clicked")
        delegate?.didTapMoreButton()
    }
    
    private func setupLayout() {
        let size = contentView.frame.height - 4
        NSLayoutConstraint.activate([
            profilePhotoImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            profilePhotoImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            profilePhotoImage.trailingAnchor.constraint(equalTo: self.usernameLabel.leadingAnchor, constant: -10),
            profilePhotoImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            profilePhotoImage.heightAnchor.constraint(equalToConstant: 50),
            profilePhotoImage.widthAnchor.constraint(equalToConstant: 50),
            
            usernameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            usernameLabel.leadingAnchor.constraint(equalTo: self.profilePhotoImage.trailingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: self.moreButton.leadingAnchor, constant: -10),
            usernameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 2),
            
            moreButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            moreButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            moreButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 2)
        ])
    }
}
