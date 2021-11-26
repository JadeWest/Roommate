//
//  ProfileViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/12.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ProfileViewController: UIViewController {

//    MARK: - Properties
    let auth = Auth.auth()
    let spinner = JGProgressHUD()
    
    private let profilePhoto: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.tintColor = UIColor(named: "IdColor")
        image.image = UIImage(systemName: "person.crop.circle.fill")
        return image
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "John@gmail.com"
        label.textColor = UIColor.label
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "John"
        label.textColor = UIColor.label
        return label
    }()
    
    private let editProfileButton: BaseButton = {
        let button = BaseButton(text: "프로필 편집")
        button.backgroundColor = UIColor.systemBackground
        button.setTitleColor(UIColor.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let logoutButton: BaseButton = {
        let button = BaseButton(text: "로그아웃")
        button.backgroundColor = UIColor.systemRed
        return button
    }()
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
        addSubViews()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2.0
        editProfileButton.layer.cornerRadius = editProfileButton.frame.height/2.0
        logoutButton.layer.cornerRadius = logoutButton.frame.height/2.0
    }
    
//    MARK: - Functions
    private func addSubViews() {
        view.addSubview(profilePhoto)
        view.addSubview(emailLabel)
        view.addSubview(usernameLabel)
        view.addSubview(editProfileButton)
        view.addSubview(logoutButton)
    }
    
    private func initProfile() {
        guard let user = auth.currentUser as? User else {
            return
        }
        
        self.emailLabel.text = user.email
        self.usernameLabel.text = user.username
    }
//    MARK: - Objc functions
    @objc private func didTapEditProfileButton() {
        let editVC = EditProfileViewController()
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: true)
    }
    
    @objc private func didTapLogOutButton() {
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self]_ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.spinner.show(in: strongSelf.view)
            do {
                try strongSelf.auth.signOut()
            } catch let signOutError as NSError {
                print("로그아웃에 실패했습니다\n Error Code:\(signOutError)")
            }
            if strongSelf.auth.currentUser == nil {
                let loginVC = LoginViewController()
                let nav = UINavigationController(rootViewController: loginVC)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.spinner.dismiss(animated: true)
                strongSelf.present(nav, animated: true) {
                    strongSelf.navigationController?.popToRootViewController(animated: false)
                    strongSelf.tabBarController?.selectedIndex = 0
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
//    MARK: - Setup Layout
    private func setupLayout() {
        let profileButtonSize:CGFloat = 150
        let margin: CGFloat = 50.0
        NSLayoutConstraint.activate([
            profilePhoto.topAnchor.constraint(equalTo: self.view.topAnchor,
                                                    constant: self.view.frame.height/4.0),
            profilePhoto.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profilePhoto.heightAnchor.constraint(equalToConstant: profileButtonSize),
            profilePhoto.widthAnchor.constraint(equalToConstant: profileButtonSize),
            
            emailLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 5),
            emailLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: self.profilePhoto.bottomAnchor),
            usernameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            editProfileButton.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 100),
            editProfileButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: margin),
            editProfileButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -margin),
            editProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoutButton.topAnchor.constraint(equalTo: self.editProfileButton.bottomAnchor, constant: 20),
            logoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: margin),
            logoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -margin),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
