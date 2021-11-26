//
//  BaseTextField.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/18.
//

import UIKit

class BaseTextField: UITextField {

    init(placeholder: String, isSecret: Bool = false) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = placeholder
        self.backgroundColor = .secondarySystemBackground
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.isSecureTextEntry = isSecret
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
