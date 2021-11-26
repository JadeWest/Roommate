//
//  EditProfileViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/11/14.
//

import UIKit

class EditProfileViewController: UIViewController {

//    MARK: - Properties
    private let profilePhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.tintColor = UIColor(named: "IdColor")
        button.setBackgroundImage(UIImage(systemName: "person.crop.circle.fill"),
                                  for: .normal)
        return button
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.tintColor = .label
        button.backgroundColor = .systemBackground
        button.setBackgroundImage(UIImage(systemName: "camera.circle.fill"),
                                  for: .normal)
        return button
    }()
    
    private let usernameField: BaseTextField = {
        let field = BaseTextField(placeholder: "닉네임",
                                  isSecret: false)
        field.returnKeyType = .continue
        return field
    }()
    
    private let emailField: BaseTextField = {
        let field = BaseTextField(placeholder: "이메일",
                                  isSecret: false)
        field.isEnabled = false
        return field
    }()
    
    private let changePasswordButton: BaseButton = {
        let button = BaseButton(text: "비밀번호변경")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "프로필 수정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.label
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapDone))
        addSubviews()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profilePhotoButton.layer.cornerRadius = profilePhotoButton.frame.height/2.0
        cameraButton.layer.cornerRadius = cameraButton.frame.height/2.0
        usernameField.layer.cornerRadius = usernameField.frame.height/2.0
        emailField.layer.cornerRadius = emailField.frame.height/2.0
        changePasswordButton.layer.cornerRadius = changePasswordButton.frame.height/2.0
    }
//    MARK: - Functions
    private func addSubviews() {
        view.addSubview(profilePhotoButton)
        view.addSubview(cameraButton)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(changePasswordButton)
    }
//    MARK: - Objc Functions
    @objc private func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapDone() {
        print("프로필 수정 완료")
        self.dismiss(animated: true, completion: nil)
    }
//    MARK: - Setup Layout
    func setupLayout() {
        let profileButtonSize:CGFloat = 150
        let cameraButtonSize:CGFloat = 35
        let margin: CGFloat = 30.0
        let contentHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            profilePhotoButton.topAnchor.constraint(equalTo: self.view.topAnchor,
                                                    constant: self.view.frame.height/4.0),
            profilePhotoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profilePhotoButton.heightAnchor.constraint(equalToConstant: profileButtonSize),
            profilePhotoButton.widthAnchor.constraint(equalToConstant: profileButtonSize),
            
            cameraButton.bottomAnchor.constraint(equalTo: self.profilePhotoButton.bottomAnchor,
                                                 constant: -10),
            cameraButton.trailingAnchor.constraint(equalTo: self.profilePhotoButton.trailingAnchor,
                                                   constant: -10),
            cameraButton.heightAnchor.constraint(equalToConstant: cameraButtonSize),
            cameraButton.widthAnchor.constraint(equalToConstant: cameraButtonSize),
            
            usernameField.topAnchor.constraint(equalTo: self.profilePhotoButton.bottomAnchor,
                                               constant: 50),
            usernameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                  constant: margin),
            usernameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                   constant: -margin),
            usernameField.heightAnchor.constraint(equalToConstant: contentHeight),
            
            emailField.topAnchor.constraint(equalTo: self.usernameField.bottomAnchor,
                                            constant: 20),
            emailField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                               constant: margin),
            emailField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                constant: -margin),
            emailField.heightAnchor.constraint(equalToConstant: contentHeight),
            
            changePasswordButton.topAnchor.constraint(equalTo: self.emailField.bottomAnchor,
                                                     constant: 60),
            changePasswordButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                         constant: margin),
            changePasswordButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                          constant: -margin),
            changePasswordButton.heightAnchor.constraint(equalToConstant: contentHeight)
        ])
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "프로필 사진",
                                            message: "사진을 가져올 곳을 선택해주세요.",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "취소",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "카메라",
                                            style: .default,
                                            handler: {[weak self] _ in
            self?.presentCamera()
        }))
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,
                animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,
                animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true,
                       completion: nil)
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.profilePhotoButton.setBackgroundImage(selectedImage,
                                                   for: .normal)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,
                       completion: nil)
    }
    
}
