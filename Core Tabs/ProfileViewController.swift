//
//  ProfileViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/12.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class ProfileViewController: UIViewController {

//    MARK: - Properties
    let auth = Auth.auth()
    let db = Database.database().reference()
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
        label.text = ""
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.textAlignment = .center
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
        initProfile()
    }
    
//    MARK: - Functions
    private func addSubViews() {
        view.addSubview(profilePhoto)
        view.addSubview(emailLabel)
        view.addSubview(usernameLabel)
        view.addSubview(editProfileButton)
        view.addSubview(logoutButton)
    }
    
//    TODO: safeEmail을 User의 safeEmail 연산변수로 바꿔줄것
    private func initProfile() {
        auth.addStateDidChangeListener { [weak self] auth, user in
            guard let currentUser = user else {
                return
            }
            guard let email = currentUser.email else {
                return
            }
            
            guard let strongSelf = self else {
                return
            }
            
            let safeEmail = strongSelf.convertSafeEmail(email: email)
            
            strongSelf.db.child(safeEmail).child("username").getData { err, snapshot in
                DispatchQueue.main.async {
                    strongSelf.emailLabel.text = currentUser.email
                    strongSelf.usernameLabel.text = snapshot.value as? String
                }
            }
        }
    }
    
    private func convertSafeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
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
            
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            strongSelf.spinner.dismiss(animated: true)
            strongSelf.present(nav, animated: true) {
                strongSelf.navigationController?.popToRootViewController(animated: false)
                strongSelf.tabBarController?.selectedIndex = 0
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

            usernameLabel.topAnchor.constraint(equalTo: self.profilePhoto.bottomAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            usernameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
            emailLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            emailLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
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
