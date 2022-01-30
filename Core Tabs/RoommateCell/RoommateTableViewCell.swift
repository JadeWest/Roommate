//
//  RoommateTableViewCell.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/26.
//

import UIKit
import SDWebImage

class RoommateTableViewCell: UITableViewCell {

//    MARK: - Properties
    
    static let identifier = "RoommateTableViewCell"
    
    private let profilePhotoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .label
        label.text = "John"
        return label
    }()
    
    private let targetLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.text = "부산"
        return label
    }()
    
    private let desc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 2
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        return label
    }()
    
//    MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(profilePhotoImage)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(targetLocation)
        contentView.addSubview(desc)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePhotoImage.layer.cornerRadius = profilePhotoImage.frame.height/2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: RoomatePost) {
        usernameLabel.text = model.owner.username
        profilePhotoImage.sd_setImage(with: URL(string: "https://www,google.com"), completed: nil)
        targetLocation.text = model.targetLocation
        desc.text = model.desc
    }
    
//    MARK: - Functions
    private func configure(with model: User) {
        profilePhotoImage.sd_setImage(with: URL(string: model.profilePictureURL), placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
    }
//    MARK: - SetupLayout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            profilePhotoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            profilePhotoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profilePhotoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            usernameLabel.leadingAnchor.constraint(equalTo: profilePhotoImage.trailingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo: targetLocation.topAnchor),
            
            targetLocation.leadingAnchor.constraint(equalTo: profilePhotoImage.trailingAnchor, constant: 10),
            targetLocation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            targetLocation.bottomAnchor.constraint(equalTo: desc.bottomAnchor),
            
            desc.leadingAnchor.constraint(equalTo: profilePhotoImage.trailingAnchor, constant: 10),
            desc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            desc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
}
