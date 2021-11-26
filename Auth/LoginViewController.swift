//
//  LoginViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/12.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {

//    MARK: - Properties
    let spinner = JGProgressHUD()
    let auth = Auth.auth()
    
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "Logo")
        return image
    }()
    
    private let emailField: BaseTextField = {
        let field = BaseTextField(placeholder: "이메일(예:MyRoommate123@email.com)", isSecret: false)
        field.returnKeyType = .next
        return field
    }()
    
    private let passwordField: BaseTextField = {
        let field = BaseTextField(placeholder: "비밀번호", isSecret: true)
        field.returnKeyType = .continue
        return field
    }()
    
    private let loginButton: BaseButton = {
        let button = BaseButton(text: "로그인")
        return button
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("비밀번호가 기억나지 않으신가요?", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setupLayout()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(didTapResetPWButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoImageView.layer.cornerRadius = logoImageView.frame.height/2.0
        emailField.layer.cornerRadius = emailField.frame.height/2.0
        passwordField.layer.cornerRadius = passwordField.frame.height/2.0
        loginButton.layer.cornerRadius = loginButton.frame.height/2.0
    }
    
    //    MARK: - Objc functions
    @objc private func didTapLoginButton() {
        self.spinner.show(in: self.view, animated: true)
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
                  let alert = UIAlertController(title: "로그인 실패", message: "이메일과 비밀번호를 올바르게 입력했는지 확인해주세요.\n (비밀번호는 6자리 이상의 문자와 숫자의 조합입니다.)", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self]alert in
                      guard let strongSelf = self else {
                          return
                      }
                      strongSelf.emailField.becomeFirstResponder()
                  }))
                  present(alert, animated: true)
                  return
        }
        auth.signIn(withEmail: email, password: password, completion: { [weak self]result, err in
            guard let strongSelf = self else {
                return
            }
            
            // 로그인 성공
            if err == nil {
                DispatchQueue.main.async {
                    strongSelf.dismiss(animated: true, completion: {
                        strongSelf.spinner.dismiss(animated: true)
                        let tabVC = TabBarViewController()
                        let navVC = UINavigationController(rootViewController: tabVC)
                        navVC.modalPresentationStyle = .fullScreen
                        strongSelf.present(navVC, animated: true)
                    })
                }
            }
        })
    }
    
    @objc private func didTapResetPWButton() {
        let findPwVC = FindPasswordViewController()
        self.navigationController?.pushViewController(findPwVC, animated: true)
    }
    
    @objc private func didTapRegisterButton() {
        let registerVC = RegistrationViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
//    MARK: - Functions
    
    private func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(resetPasswordButton)
        view.addSubview(registerButton)
    }
    
    
//    MARK: - Setup Layout
    private func setupLayout() {
        let margin:CGFloat = 50.0
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: view.frame.height/4.0),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            emailField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 30),
            emailField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: margin),
            emailField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -margin),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: margin),
            passwordField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -margin),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: margin),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -margin),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            resetPasswordButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            resetPasswordButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            resetPasswordButton.bottomAnchor.constraint(equalTo: self.registerButton.topAnchor, constant: -5),
            
            registerButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            registerButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.safeAreaInsets.bottom-70)
        ])
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
}
