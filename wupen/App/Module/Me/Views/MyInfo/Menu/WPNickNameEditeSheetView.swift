//
//  WPNickNameEditeSheetView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/11.
//

import UIKit

class WPNickNameEditeSheetView: UIView {
    var didSelectedBlock:((_ name:String)->Void)?
 

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubviews()
        makeConstraints()
    }
    
    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        return contentView
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "修改昵称"
        label.textColor = rgba(51, 51, 51, 1)
        label.font = .systemFont(ofSize: 18)
        contentView.addSubview(label)
        return label
    }()
    
    lazy var cancel: UIButton = {
        var cancel: UIButton = UIButton()
        let img = UIImage.wp.createColorImage(rgba(245, 245, 245, 1), size: CGSize(width: 165, height: 48)).wp.roundCorner(12)
        cancel.setBackgroundImage(img, for: .normal)
        
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(rgba(102, 102, 102, 1), for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 16)
        
        cancel.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(cancel)
        return cancel
    }()
   
    lazy var saveButton: UIButton = {
        var sender: UIButton = UIButton()
        let img = UIImage.wp.createColorImage(rgba(254, 143, 11, 1), size: CGSize(width: 165, height: 48)).wp.roundCorner(12)
        sender.setBackgroundImage(img, for: .normal)
        sender.setTitle("保存", for: .normal)
        sender.setTitleColor(rgba(255, 255, 255, 1), for: .normal)
        sender.titleLabel?.font = .systemFont(ofSize: 16)
    
        sender.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            let text:String = weakSelf.textField.text?.wp.trim() ?? ""
            if text.count > 0 {
                weakSelf.didSelectedBlock?(text)
            }
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(sender)
        return sender
    }()

    lazy var textField: WPEditeNickeNameTextField = {
        var textField: WPEditeNickeNameTextField = WPEditeNickeNameTextField()
        contentView.addSubview(textField)
        return textField
    }()
}


extension WPNickNameEditeSheetView {
    func show() -> Void {
        WPKeyWindowDev?.addSubview(self)
        let h = 212 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
        self.alpha = 1
        
        contentView.y = WPScreenHeight
        UIView.animate(withDuration: 0.25) {
            self.contentView.y = WPScreenHeight - h
        }
    }
    
    func hidden() -> Void {
        self.endEditing(true)
        UIView.animate(withDuration: 0.25) {
            self.contentView.y = WPScreenHeight
            self.alpha = 0
            
        } completion: { r in
            NotificationCenter.default.removeObserver(self)
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self {
            hidden()
        }
    }
}

extension WPNickNameEditeSheetView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.5)
        let h = 212 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
        contentView.frame = .init(x: 0, y: WPScreenHeight - h, width: WPScreenWidth, height: h)
        contentView.setCorners([.topLeft,.topRight], cornerRadius: 8)
        IQKeyboardManager.shared.enable = false
        
        // 添加键盘弹出的通知观察者
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        // 添加键盘隐藏的通知观察者
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        self.textField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            weakSelf.textField.limitInputWithPattern(pattern: "", 10)//"[^A-Za-z0-9_\\u4E00-\\u9FA5]"
            
            let text:String = weakSelf.textField.text?.wp.trim() ?? ""
            weakSelf.textField.label.text = "\(text.count)/10"
            weakSelf.saveButton.isEnabled = (text.count > 0)
            
        }).disposed(by: disposeBag)
        
        self.textField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            weakSelf.textField.resignFirstResponder()
        }).disposed(by: disposeBag)

        guard let username = WPUser.user()?.userInfo?.username else { return }
        self.textField.text = username
        let text:String = username.wp.trim()
        self.textField.label.text = "\(text.count)/10"
        self.saveButton.isEnabled = (text.count > 0)
    }
    
    func makeConstraints () {
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
        }
        
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(label.snp.bottom).offset(26)
        }
        
        cancel.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.centerX).offset(-6.5)
            make.top.equalTo(textField.snp.bottom).offset(36)
            make.size.equalTo(CGSize(width: 165, height: 48))
        }
        
        saveButton.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(6.5)
            make.size.centerY.equalTo(cancel)
        }
    }
}

extension WPNickNameEditeSheetView {
    @objc func keyboardWillShow(notification: Notification) {
            // 从通知中获取键盘的frame
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                // 转换为CGRect并获取高度
                let keyboardRectangle = keyboardFrame.cgRectValue
                let height = keyboardRectangle.height
                
                let h = 212.0 //+ (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
                let y = WPScreenHeight - h - height
                UIView.animate(withDuration: 0.25) {
                    self.contentView.y = y
                }
            }
        }

        @objc func keyboardWillHide(notification: Notification) {
            let h = 212 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
            let y = WPScreenHeight - h
            UIView.animate(withDuration: 0.25) {
                self.contentView.y = y
            }
        }

}
