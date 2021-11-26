//
//  RegistrationViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/12.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegistrationViewController: UIViewController {

//    MARK: - Properties
    
    private let spinner = JGProgressHUD()
    
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
        field.returnKeyType = .continue
        return field
    }()
    
    private let passwordField: BaseTextField = {
        let field = BaseTextField(placeholder: "비밀번호",
                                  isSecret: true)
        field.returnKeyType = .done
        return field
    }()
    
    private let registerButton: BaseButton = {
        let button = BaseButton(text: "회원가입")
        return button
    }()
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "회원가입"
        self.viewAddSubView()
        registerButton.addTarget(self,
                                 action: #selector(didTapRegisterButton),
                                 for: .touchUpInside)
        profilePhotoButton.addTarget(self,
                                     action: #selector(didTapProfilePhotoButton),
                                     for: .touchUpInside)
        cameraButton.addTarget(self,
                               action: #selector(didTapCameraButton),
                               for: .touchUpInside)
        
        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraButton.layer.cornerRadius = cameraButton.frame.height/2.0
        profilePhotoButton.layer.cornerRadius = profilePhotoButton.frame.height/2.0
        usernameField.layer.cornerRadius = usernameField.frame.height/2.0
        emailField.layer.cornerRadius = emailField.frame.height/2.0
        passwordField.layer.cornerRadius = passwordField.frame.height/2.0
        registerButton.layer.cornerRadius = registerButton.frame.height/2.0
    }
    
//    MARK: - functions
    
    private func viewAddSubView() {
        view.addSubview(profilePhotoButton)
        view.addSubview(cameraButton)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
    }
    
    private func loginError(message: String = "빈칸의 모든 정보를 입력해주세요. 또는 다른 이메일을 사용해주세요.") {
        let alert = UIAlertController(title: "오류",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
//    MARK: - Objc functions
    
    @objc private func didTapProfilePhotoButton() {
        presentPhotoActionSheet()
    }
    
    @objc private func didTapCameraButton() {
        presentPhotoActionSheet()
    }
    
    @objc private func didTapRegisterButton() {
        profilePhotoButton.resignFirstResponder()
        cameraButton.resignFirstResponder()
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let username = usernameField.text,
              !email.isEmpty,
              !password.isEmpty,
              !username.isEmpty,
              password.count >= 6 else {
                  loginError()
                  return
              }
        
        spinner.show(in: view, animated: true)
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exist in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true)
            }
            
            guard !exist else {
                strongSelf.loginError(message: "이미 존재하는 계정입니다.")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    print("createUser() 에러발생")
                    return
                }
                
                let newUser = User(email: email, username: username, createdDate: Date(), modifiedDate: Date(), gender: .male, birthDate: Date())
                
                DatabaseManager.shared.insertUser(with: newUser, completion: { success in
                    if success {
                        guard let image = strongSelf.profilePhotoButton.currentBackgroundImage,
                              let data = image.pngData() else {
                            return
                        }
                        let filename = newUser.profilePictureURL
                    }
                })
                
                strongSelf.navigationController?.popViewController(animated: true)
            })
        }
        
        
        
    }
//    MARK: - Setup Layout
    private func setupLayout() {
        let profileButtonSize:CGFloat = 150
        let cameraButtonSize:CGFloat = 35
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
                                               constant: 30),
            usernameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                   constant: 30),
            usernameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                    constant: -30),
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            
            emailField.topAnchor.constraint(equalTo: self.usernameField.bottomAnchor,
                                            constant: 10),
            emailField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                constant: 30),
            emailField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                 constant: -30),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: self.emailField.bottomAnchor,
                                               constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                   constant: 30),
            passwordField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                    constant: -30),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor,
                                                constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                     constant: -30),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            resignFirstResponder()
        }
        return true
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(
            title: "프로필 사진",
            message: "프로필 사진을 가져올 곳을 선택해주세요.",
            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil))
        actionSheet.addAction(UIAlertAction(
            title: "카메라",
            style: .default,
            handler: { [weak self] _ in
                self?.presentCamera()
            }))
        actionSheet.addAction(UIAlertAction(
            title: "라이브러리",
            style: .default,
            handler: { [weak self] _ in
                self?.presentPhotoPicker()
            }))
        present(
            actionSheet,
            animated: true
        )
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(
            vc,
            animated: true
        )
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(
            vc,
            animated: true
        )
    }
    
    // 사진찍기 및 이미지 선택시
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        // 선택한 이미지 = edit한 이미지 UIImage타입으로 캐스팅
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.profilePhotoButton.setBackgroundImage(selectedImage, for: .normal)
    }
    
    // 사진찍기 및 이미지 선택 '취소'했을경우
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
