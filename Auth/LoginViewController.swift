//
//  LoginViewController.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/12.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class LoginViewController: UIViewController {
    
    //    MARK: - Properties
    let spinner = JGProgressHUD()
    let auth = Auth.auth()
    let db = Database.database().reference()
    
    /**
     # Logo Image (로고이미지뷰)
     */
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "Logo")
        return image
    }()
    
    /**
     # emailField (이메일입력필드)
     */
    private let emailField: BaseTextField = {
        let field = BaseTextField(placeholder: "이메일(예:MyRoommate123@email.com)",
                                  isSecret: false)
        field.returnKeyType = .next
        return field
    }()
    
    /**
     # passwordField (비밀번호입력필드)
     */
    private let passwordField: BaseTextField = {
        let field = BaseTextField(placeholder: "비밀번호",
                                  isSecret: true)
        field.returnKeyType = .continue
        return field
    }()
    
    /**
     # loginButton (로그인버튼)
     */
    private let loginButton: BaseButton = {
        let button = BaseButton(text: "로그인")
        return button
    }()
    
    /**
     # changePasswordButton (비밀번호변경버튼)
     */
    private let changePasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("비밀번호가 기억나지 않으신가요?",
                        for: .normal)
        button.setTitleColor(.secondaryLabel,
                             for: .normal)
        return button
    }()
    
    /**
     # registerButton (회원가입화면 이동버튼)
     */
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("회원가입",
                        for: .normal)
        button.setTitleColor(.secondaryLabel,
                             for: .normal)
        return button
    }()
    
    //    MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        auth.languageCode = "kr"
        emailField.delegate = self
        passwordField.delegate = self
        addSubviews()
        setupLayout()
        
        loginButton.addTarget(
            self,
            action: #selector(didTapLoginButton),
            for: .touchUpInside
        )
        changePasswordButton.addTarget(
            self,
            action: #selector(didTapResetPWButton),
            for: .touchUpInside
        )
        registerButton.addTarget(
            self,
            action: #selector(didTapRegisterButton),
            for: .touchUpInside
        )
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        logoImageView.layer.cornerRadius = logoImageView.frame.height/2.0
        emailField.layer.cornerRadius = emailField.frame.height/2.0
        passwordField.layer.cornerRadius = passwordField.frame.height/2.0
        loginButton.layer.cornerRadius = loginButton.frame.height/2.0
    }
    
    //    MARK: - Objc functions
    
    /**
     # didTapLoginButton
     
     ## TODO
     - 데이터 처리 Business Logic 을 ViewModel로 분리
     
     */
    @objc private func didTapLoginButton() {
        
        self.spinner.show(in: self.view,
                          animated: true)
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
                  spinner.dismiss(animated: false)
                  let alert = UIAlertController(
                    title: "로그인 실패",
                    message: "이메일과 비밀번호를 올바르게 입력했는지 확인해주세요.\n (비밀번호는 6자리 이상의 문자와 숫자의 조합입니다.)",
                    preferredStyle: .alert
                  )
                  alert.addAction(
                    UIAlertAction(
                        title: "확인",
                        style: .default,
                        handler: { [weak self] alert in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.emailField.becomeFirstResponder()
                        }
                    )
                  )
                  
                  present(alert,
                          animated: true)
                  
                  return
              }
        
        auth.signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            
            if let authError = error as NSError? {
                strongSelf.spinner.dismiss(animated: true)
                strongSelf.emailField.layer.borderWidth = 0
                strongSelf.passwordField.layer.borderWidth = 0
                switch  AuthErrorCode(rawValue: authError.code) {
                case .operationNotAllowed:
                    let alert = UIAlertController(title: "로그인이 비활성화됨",
                                                  message: "현재 내부문제로 인해 로그인이 중지된 상태입니다.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인",
                                                  style: .default))
                    strongSelf.present(alert,
                                       animated: true)
                case .userDisabled:
                    let alert = UIAlertController(title: "사용이 중지됨",
                                                  message: "사용이 중지된 계정입니다. 앱스토어를 통해 문의해주시기 바랍니다.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인",
                                                  style: .default))
                    strongSelf.present(alert,
                                       animated: true)
                case .wrongPassword:
                    let alert = UIAlertController(title: "비밀번호 불일치",
                                                  message: "비밀번호가 일치하지 않습니다. 다시 시도해주세요.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인",
                                                  style: .default,
                                                  handler: {(action) in strongSelf.passwordField.layer.borderColor = UIColor.systemRed.cgColor
                        strongSelf.passwordField.layer.borderWidth = 1
                    }))
                    strongSelf.passwordField.layer.borderColor = UIColor.systemRed.cgColor
                    strongSelf.passwordField.becomeFirstResponder()
                    strongSelf.present(alert,
                                       animated: true)
                case .invalidEmail:
                    let alert = UIAlertController(title: "이메일 불일치",
                                                  message: "등록되지 않은 E-mail입니다. 다시 시도해주세요.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인",
                                                  style: .default,
                                                  handler: {(action) in strongSelf.emailField.layer.borderColor = UIColor.systemRed.cgColor
                        strongSelf.emailField.layer.borderWidth = 1
                    }))
                    strongSelf.present(alert,
                                       animated: true)
                case .userNotFound:
                    let alert = UIAlertController(title: "로그인 에러",
                                                  message: "존재하지않는 계정입니다.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인",
                                                  style: .default))
                    strongSelf.present(alert,
                                       animated: true)
                default:
                    print("에러발생: \(String(describing: error?.localizedDescription))")
                }
            } else {
                DispatchQueue.main.async {
                    strongSelf.dismiss(
                        animated: true,
                        completion: {
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
    
    /**
     # didTapResetPwButton (비밀번호초기화버튼이벤트)
     */
    @objc private func didTapResetPWButton() {
        let findPwVC = FindPasswordViewController()
        self.navigationController?.pushViewController(findPwVC,
                                                      animated: true)
    }
    
    /**
     # didTapRegisterButton (회원가입버튼이벤트)
     */
    @objc private func didTapRegisterButton() {
        let registerVC = RegistrationViewController()
        self.navigationController?.pushViewController(registerVC,
                                                      animated: true)
    }
    
    //    MARK: - Functions
    
    
    /**
     화면클릭 키보드 숨기기
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /**
     # addSubViews (UI subview 추가모음)
     */
    private func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(changePasswordButton)
        view.addSubview(registerButton)
    }
    
    
    //    MARK: - Setup Layout
    private func setupLayout() {
        let margin:CGFloat = 50.0
        
        NSLayoutConstraint.activate([
            
            logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor,
                                               constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            emailField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor,
                                            constant: 30),
            emailField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                constant: margin),
            emailField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                 constant: -margin),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            
            passwordField.topAnchor.constraint(equalTo: self.emailField.bottomAnchor,
                                               constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                   constant: margin),
            passwordField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                    constant: -margin),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            
            loginButton.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor,
                                             constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                 constant: margin),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                  constant: -margin),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            changePasswordButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 30),
            changePasswordButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                         constant: 30),
            changePasswordButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                          constant: -30),
            changePasswordButton.bottomAnchor.constraint(equalTo: self.registerButton.topAnchor,
                                                        constant: 0),
            
            
            registerButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                     constant: -30),
            
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
