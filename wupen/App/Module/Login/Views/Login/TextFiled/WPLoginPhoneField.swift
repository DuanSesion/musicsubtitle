//
//  WPLoginPhoneField.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

class WPLoginPhoneField: UITextField {

    public var editeChangeBlock:(()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension WPLoginPhoneField {
    func setUI() -> Void {
        self.keyboardType = .numberPad
        self.backgroundColor = rgba(255, 255, 255, 0.70)
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        
        self.clearButtonMode = .whileEditing
        self.font = .systemFont(ofSize: 16)
        self.textColor = rgba(34, 46, 56, 1)
 
        let attributedPlaceholder:NSMutableAttributedString = NSMutableAttributedString(string: localize("LoginPhoneNumber"))
        attributedPlaceholder.yy_font = .systemFont(ofSize: 14)
        attributedPlaceholder.yy_color = rgba(136, 136, 136, 1)
        self.attributedPlaceholder = attributedPlaceholder
        
        
        self.leftViewMode = .always
        
        let leftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        self.leftView = leftView
        
//        if  let lefv = self.value(forKeyPath: "_clearButton") as? UIButton {
//            lefv.setImage(.init(named: "login_clearn_icon")?.tintImage(rgba(34, 46, 56, 1)), for: .normal)
//        }
      
        self.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] recognizer in
            self?.editeChangeBlock?()
            if let textFiled:UITextField = self {
                textFiled.wp.limitInputWithPattern(pattern: "[^0-9]", 11)
            }
        }).disposed(by: disposeBag)
        
    }
}
