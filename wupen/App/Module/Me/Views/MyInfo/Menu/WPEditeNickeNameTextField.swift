//
//  WPEditeNickeNameTextField.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/11.
//

import UIKit

class WPEditeNickeNameTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "0/10"
        label.textColor = rgba(136, 136, 136, 1)
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
}


extension WPEditeNickeNameTextField {
    func setup()-> Void {
        self.backgroundColor = rgba(245, 245, 245, 1)
        self.layer.cornerRadius = 8
        self.layer.shadowColor = rgba(225, 235, 246, 0.40).cgColor
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 1
        self.clearButtonMode = .whileEditing
        self.font = .systemFont(ofSize: 14)
        self.layer.shadowOffset = .init(width: 0, height: 4)
        self.textColor = rgba(51, 51, 51, 1)
        self.returnKeyType = .done
       
        let attributedPlaceholder:NSMutableAttributedString = NSMutableAttributedString(string: "昵称")
        attributedPlaceholder.yy_font = .systemFont(ofSize: 14)
        attributedPlaceholder.yy_color = rgba(193, 195, 197, 1)
        self.attributedPlaceholder = attributedPlaceholder
        
        self.textAlignment = .left
        
        self.leftViewMode = .always
        self.rightViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 50))
        
        let rightViewS = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 50))
        self.rightView = rightViewS
        
        label.frame = CGRect(x: 11, y: 0, width: 30, height: 50)
        rightViewS.addSubview(label)
    }
}
