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
        return label
    }()
//    MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePhotoImage.layer.cornerRadius = profilePhotoImage.frame.height/2.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Functions
    private func configure(with model: User) {
        profilePhotoImage.sd_setImage(with: model.profilePictureURL, placeholderImage: UIImage(systemName: "person.crop.circle.fill"))
    }
//    MARK: - SetupLayout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
