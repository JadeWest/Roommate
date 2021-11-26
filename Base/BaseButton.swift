//
//  BaseButton.swift
//  MyRoommate
//
//  Created by 서현규 on 2021/10/18.
//

import UIKit

class BaseButton: UIButton {

    init(text: String) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(text, for: .normal)
        self.backgroundColor = UIColor(named: "IdColor")
        self.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
