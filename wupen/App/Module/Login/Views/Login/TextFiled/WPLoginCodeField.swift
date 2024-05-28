//
//  WPLoginCodeField.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

class WPLoginCodeField: UITextField {

    public var getCodeBlock:(()->Void)?
    public var editeChangeBlock:(()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton(type: .custom)
        button.setTitle("获取验证码", for: .normal)
        button.setTitleColor(rgba(254, 143, 11, 1), for: .normal)
        button.setTitleColor(rgba(254, 143, 11, 1), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .right
        button.isEnabled = false
        self.addSubview(button)
        return button
    }()
}


extension WPLoginCodeField {
    func setUI() -> Void {
        self.keyboardType = .numberPad
        self.backgroundColor = rgba(255, 255, 255, 0.70)
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        
        self.clearButtonMode = .whileEditing
        self.font = .systemFont(ofSize: 16)
        self.textColor = rgba(34, 46, 56, 1)
        
        // 验证码提示
        self.textContentType = UITextContentType.oneTimeCode
 
        let attributedPlaceholder:NSMutableAttributedString = NSMutableAttributedString(string: "请输入验证码")
        attributedPlaceholder.yy_font = .systemFont(ofSize: 14)
        attributedPlaceholder.yy_color = rgba(136, 136, 136, 1)
        self.attributedPlaceholder = attributedPlaceholder
        
        
        self.leftViewMode = .always
        self.rightViewMode = .always
        
        let leftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        self.leftView = leftView
        
        let rightView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 108+24, height: 48))
        self.rightView = rightView
 
        self.button.frame = CGRect(x: 0, y: 0.0, width: 108, height: 48.0)
        rightView.addSubview(self.button)
        
        
        button.rx.tap.subscribe(onNext: { [weak self] recognizer in
            self?.becomeFirstResponder()
            self?.getCodeBlock?()
            self?.button.jk.preventDoubleHit(3)
            
        }).disposed(by: disposeBag)
        
        self.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] recognizer in
            self?.editeChangeBlock?()
            if let textFiled:UITextField = self {
                textFiled.wp.limitInputWithPattern(pattern: "[^0-9]", 6)
            }
            
        }).disposed(by: disposeBag)
        
        if let date = getLastDate() {
            let nowDate = Date()
            let sencond:Int = 60 - Int(date.getInterval(toDate: nowDate, component: .second))
            if sencond > 1 && sencond < 60 {
                countDownTimer(sencond)
            }
        }
    }
}

extension WPLoginCodeField {
    func getPhoneCode(mobile:String) -> Void {
        button.isUserInteractionEnabled = false
        self.showUnityNetActivity()
        WPUser.sendValidPHONE_LOGIN(phone: mobile) { [weak self] model  in
            self?.button.isUserInteractionEnabled = true
            self?.removeNetActivity()
            
            if model.code == 200 {
                self?.countDownTimer()
//                self?.superview?.showMessage(model.jsonModel?.msg)
                self?.superview?.showSucceed(model.jsonModel?.msg ?? "")
                self?.becomeFirstResponder()
              
                
            } else {
//                self?.superview?.showMessage(model.msg)
                self?.superview?.showError(model.msg ?? "")
            }
        }
    }
    
    func networkGetCode(_ msg:String) -> Void {
        if msg.count > 6 {
//            let code = NSString(string: msg).substring(from: msg.count - 6)
//            self.text = code
//            self.editeChangeBlock?()
//            let textFiled:UITextField = self
//            textFiled.wp.limitInputWithPattern(pattern: "[^0-9]", 6)
        }
    }
}

extension WPLoginCodeField {
    func save() -> Void {
        UserDefaults.standard.set(Date(), forKey: "WPLoginCodeField")
        UserDefaults.standard.synchronize()
    }

    func getLastDate() -> Date? {
        return UserDefaults.standard.value(forKey: "WPLoginCodeField") as? Date
    }
    
    func countDownTimer(_ sencond:Int = 60) -> Void {
        button.countDown(sencond, timering: {[weak self]  tim in
            self?.button.contentHorizontalAlignment = .right
            let atr:NSMutableAttributedString = NSMutableAttributedString(string: "重新获取 \(tim)s")
            atr.yy_font = .systemFont(ofSize: 14)
            atr.yy_color = rgba(254, 143, 11, 1)
            atr.yy_setColor(rgba(27, 228, 133, 1), range: NSRange(location: 4, length: atr.length - 4))
            self?.button.setAttributedTitle(atr, for: .normal)
            self?.button.isUserInteractionEnabled = false
             
        },complete: {[weak self]  in
            let atr:NSMutableAttributedString = NSMutableAttributedString(string: "获取验证码")
            atr.yy_font = .systemFont(ofSize: 14)
            atr.yy_color = rgba(254, 143, 11, 1)
            
            self?.button.setAttributedTitle(atr, for: .normal)
            self?.button.contentHorizontalAlignment = .right
            self?.button.isUserInteractionEnabled = true
            self?.editeChangeBlock?()
        })
    }
}
