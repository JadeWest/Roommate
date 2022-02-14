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
    private let genderArr = ["남", "여"]
    private var userGender: Gender? = nil
    private let auth = Auth.auth()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

//    TODO: IamgeView에 addtarget을 뮷넣음. TapGestureRecognizer 집어넣고, 터치이벤트(사진고르기 function연결)추가
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.tintColor = UIColor(named: "IdColor")
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        return imageView
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
    
    private let maleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("♂\n남", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 45, weight: .medium)
        button.setTitleColor(UIColor.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let femaleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("♀\n여", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 45, weight: .medium)
        button.setTitleColor(UIColor.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let genderButtonsHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private let birthdatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.timeZone = NSTimeZone.local
        picker.preferredDatePickerStyle = .wheels
        return picker
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
        
        /**
         제스쳐 설정
         */
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.isEnabled = true
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        registerButton.addTarget(self,
                                 action: #selector(didTapRegisterButton),
                                 for: .touchUpInside)
        
        cameraButton.addTarget(self,
                               action: #selector(didTapCameraButton),
                               for: .touchUpInside)
        maleButton.addTarget(self, action: #selector(didTapMaleButton), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(didTapFemaleButton), for: .touchUpInside)
        
        
        genderButtonsHorizontalStackView.insertArrangedSubview(maleButton, at: 0)
        genderButtonsHorizontalStackView.insertArrangedSubview(femaleButton, at: 1)
        
        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraButton.layer.cornerRadius = cameraButton.frame.height/2.0
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2.0
        usernameField.layer.cornerRadius = usernameField.frame.height/2.0
        emailField.layer.cornerRadius = emailField.frame.height/2.0
        passwordField.layer.cornerRadius = passwordField.frame.height/2.0
        registerButton.layer.cornerRadius = registerButton.frame.height/2.0
        
        /**
         set Gender Button corner radius
         */
        maleButton.layer.cornerRadius = 6
        maleButton.layer.masksToBounds = true
        femaleButton.layer.cornerRadius = 6
        femaleButton.layer.masksToBounds = true
        
        let registerButtonFrame:CGRect = self.registerButton.frame
        
        let height:CGFloat = self.profileImageView.frame.origin.y + registerButtonFrame.origin.y + registerButtonFrame.height * 2
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
    }
    
//    MARK: - functions
    
    private func viewAddSubView() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(cameraButton)
        containerView.addSubview(usernameField)
        containerView.addSubview(emailField)
        containerView.addSubview(passwordField)
        containerView.addSubview(genderButtonsHorizontalStackView)
        containerView.addSubview(birthdatePicker)
        containerView.addSubview(registerButton)
    }
    
    
    /**
     로그인에러 경고알림
     */
    private func loginError(message: String = "빈칸의 모든 정보와 성별을 입력해주세요.") {
        let alert = UIAlertController(title: "오류",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    /**
     이미지 downsamlpling
     - Parameter image: 원본 이미지
     - Parameter targetSize: 원하는 복제본 사이즈
     
     - Returns: 원본이미지의 사이즈를 변경한 `newImage`
     */
    private func downSample(imageURL: URL, size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
//        let data = image.pngData()! as CFData
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOption)!
        let maxPixel = max(size.width, size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel ] as CFDictionary
        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!
        let newImage = UIImage(cgImage: downSampledImage)
        
        return newImage
        
    }
    
    //    MARK: - Objc functions
    
    
    /**
     화면클릭 키보드 숨기기
     
     - Parameter sender: 이벤트 전달자
     */
    @objc private func didTapScrollView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc private func didTapProfilePhotoButton() {
        presentPhotoActionSheet()
    }
    
    @objc private func didTapCameraButton() {
        presentPhotoActionSheet()
    }
    
    @objc private func didTapMaleButton() {
        print("male button tapped")
        
        self.userGender = .male
        if maleButton.state == .highlighted {
            maleButton.backgroundColor = UIColor(named: "IdColor")
            femaleButton.backgroundColor = .secondarySystemBackground
            femaleButton.isHighlighted = false
        }
    }
    
    @objc private func didTapFemaleButton() {
        print("female button tapped")
        
        self.userGender = .female
        if femaleButton.state == .highlighted {
            femaleButton.backgroundColor = UIColor(named: "IdColor")
            maleButton.backgroundColor = .secondarySystemBackground
            maleButton.isHighlighted = false
        }
    }
    
    @objc private func onDidChangedDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let selectedDate: String = dateFormatter.string(from: sender.date)
        // TODO: DB에 저장할 변수에다가 포맷변경한 위 selectedDate넘겨주기
    }
    
    /**
    회원가입시 정보를 저장하고 회원가입을 실행 및 화면 로그인화면으로 이동
     */
    @objc private func didTapRegisterButton() {
        
        profileImageView.resignFirstResponder()
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
        
        guard userGender != nil else {
            loginError()
            return
        }
        
        spinner.show(in: view, animated: true)
        
        print("gender button state: \(maleButton.isHighlighted) female Button: \(femaleButton.isHighlighted)")
        
        /**
         # Progress
         1. 동일유저 존재여부체크
         2. Firebase Auth의 createUser
         3. email, password 유효성체크
         4. Firebase Realtime Database에 신규유저 데이터 추가
         5. Firebase Storage에 이미지 추가
         */
        DatabaseManager.shared.userExists(with: email) { [weak self] exist in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true) 
            }
            
            FirebaseAuth.Auth.auth().createUser(
                withEmail: email,
                password: password,
                completion: { [weak self] authResult, error in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if let authError = error as NSError? {
                        strongSelf.emailField.layer.borderWidth = 0
                        strongSelf.passwordField.layer.borderWidth = 0
                        switch  AuthErrorCode(rawValue: authError.code) {
                        case .invalidEmail:
                            let alert = UIAlertController(title: "이메일 에러", message: "이메일 형식이 올바르지 않습니다.(예시: example@example.com)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default))
                            strongSelf.emailField.layer.borderColor = UIColor.systemRed.cgColor
                            strongSelf.emailField.layer.borderWidth = 1
                            strongSelf.emailField.becomeFirstResponder()
                            strongSelf.present(alert, animated: true)
                        case .emailAlreadyInUse:
                            let alert = UIAlertController(title: "이메일 중복", message: "이미 사용중인 이메일입니다. 다른이메일을 사용해주세요.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default))
                            strongSelf.emailField.layer.borderColor = UIColor.systemRed.cgColor
                            strongSelf.emailField.layer.borderWidth = 1
                            strongSelf.emailField.becomeFirstResponder()
                            strongSelf.present(alert, animated: true)
                        case .operationNotAllowed:
                            let alert = UIAlertController(title: "허가되지 않은 작업", message: "내부문제로 인해 사용이 중단되었습니다. 다음에 다시 이용해주세요.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default))
                            strongSelf.present(alert, animated: true)
                        case .weakPassword:
                            let alert = UIAlertController(title: "보안이 약한 비밀번호", message: "보안이 약한 비밀번호입니다. 비밀번호는 6자리 이상의 문자열을 사용해주세요.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default))
                            strongSelf.passwordField.layer.borderColor = UIColor.systemRed.cgColor
                            strongSelf.passwordField.layer.borderWidth = 1
                            strongSelf.passwordField.becomeFirstResponder()
                            strongSelf.present(alert, animated: true)
                        default:
                            print("에러발생: \(String(describing: error?.localizedDescription))")
                        }
                    }
                    let serialQueue = DispatchQueue(label: "my queue")
                    guard let gender = strongSelf.userGender else {
                        return
                    }
                    
                    let newUser = User(email: email,
                                       username: username,
                                       createdDate: Date(),
                                       modifiedDate: Date(),
                                       gender: gender,
                                       birthDate: Date())
                    
                    DatabaseManager.shared.insertUser(with: newUser, completion: { success in
                        if success {
                            guard let image = strongSelf.profileImageView.image,
                                  var data = image.pngData() else {
                                      return
                                  }
                            let filename = newUser.profilePictureURL
                            
                            StorageManager.shared.uploadProfilePicture(data: data, fileName: filename) { result in
                                
                                switch result {
                                case .success(let url):
                                    print("!!!!!!!!!!!! success !!!!!!!!!!!!")
                                    guard let resource = URL(string: url) else {
                                        return
                                    }
                                    let profileViewImageCompression = strongSelf.downSample(imageURL: resource, size: CGSize(width: 150, height: 150))
                                    let newsfeedProfileViewImageCompression = strongSelf.downSample(imageURL: resource, size: CGSize(width: 66, height: 66))
                                    let compressedProfilePictureFilename = newUser.compressedProfilePictureURL
                                    let compressedNewsfeedProfilePictureFilename = newUser.compressedNewsfeedProfilePictureURL
                                    // TODO: - profile 이미지 (size: 150X150), newsfeed용 프로필이미지 저장(size: 66)
                                    
                                    guard let profileViewImageData = profileViewImageCompression.pngData(),
                                          let newsfeedProfileViewImageData = newsfeedProfileViewImageCompression.pngData() else {
                                        return
                                    }
                                    
                                    StorageManager.shared.uploadProfilePicture(data: profileViewImageData, fileName: compressedProfilePictureFilename) { result in
                                        switch result {
                                        case .success(let url):
                                            print("@150X150 compression image upload success!")
                                            print(url)
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                    
                                    StorageManager.shared.uploadProfilePicture(data: newsfeedProfileViewImageData, fileName: compressedNewsfeedProfilePictureFilename) { result in
                                        switch result {
                                        case .success(let url):
                                            print("@66X66 compression image upload success!")
                                            print(url)
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        } else {
                            print("회원가입 실패")
                            return
                        }
                    })
                    
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            )
        }
    }
//    MARK: - Setup Layout
    private func setupLayout() {
        
        let profileButtonSize:CGFloat = 150
        let cameraButtonSize:CGFloat = 35
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            
            
            containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50),
            
            profileImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            profileImageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: profileButtonSize),
            profileImageView.widthAnchor.constraint(equalToConstant: profileButtonSize),
            
            
            cameraButton.bottomAnchor.constraint(equalTo: self.profileImageView.bottomAnchor,
                                                constant: -10),
            cameraButton.trailingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor,
                                                  constant: -10),
            cameraButton.heightAnchor.constraint(equalToConstant: cameraButtonSize),
            cameraButton.widthAnchor.constraint(equalToConstant: cameraButtonSize),
            
            
            usernameField.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor,
                                               constant: 30),
            usernameField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                   constant: 30),
            usernameField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                    constant: -30),
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            
            
            emailField.topAnchor.constraint(equalTo: self.usernameField.bottomAnchor,
                                            constant: 10),
            emailField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                constant: 30),
            emailField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                 constant: -30),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            
            passwordField.topAnchor.constraint(equalTo: self.emailField.bottomAnchor,
                                               constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                   constant: 30),
            passwordField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                    constant: -30),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            
            genderButtonsHorizontalStackView.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 25),
            genderButtonsHorizontalStackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 30),
            genderButtonsHorizontalStackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -30),
            genderButtonsHorizontalStackView.heightAnchor.constraint(equalToConstant: 100),
            
            
            birthdatePicker.topAnchor.constraint(equalTo: self.genderButtonsHorizontalStackView.bottomAnchor, constant: 25),
            birthdatePicker.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,constant: 30),
            birthdatePicker.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -30),
            
            registerButton.topAnchor.constraint(equalTo: self.birthdatePicker.bottomAnchor,
                                                constant: 40),
            registerButton.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                    constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
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
    
    /**
     사진을 찍거나 이미지 선택 후 처리
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        // 선택한 이미지 = edit한 이미지 UIImage타입으로 캐스팅
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.profileImageView.image = selectedImage
    }
    
    /**
     촬영 및 선택 취소 선택
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 30))

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        label.text = genderArr[row]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor(named: "IdColor")
        
        
        view.backgroundColor = .clear
        view.addSubview(label)

        return view

    }
}
