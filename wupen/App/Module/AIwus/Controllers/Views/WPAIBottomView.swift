//
//  WPAIBottomView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/5.
//

import UIKit

class WPAIBottomView: UIImageView {
    // 用于存储键盘高度的变量
    var keyboardHeight: CGFloat = 0.0
    public var didSendBlock:((_ text:String)->Void)?
    public var showKeyBordBlock:(()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initSubViews()
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
        initSubViews()
        
    }
    
    deinit {
        // 移除通知观察者，避免内存泄漏
        NotificationCenter.default.removeObserver(self)
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setCorners([.topLeft,.topRight],cornerRadius: 16)
    }
    
    lazy var sendButton: UIButton = {
        var button: UIButton = UIButton()
        button.setBackgroundImage(.init(named: "ai_send_icon"), for: .normal)
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            let text = weakSelf.textView.text.wp.trim()
            if text.count > 0 {
                weakSelf.textView.resignFirstResponder()
                weakSelf.didSendBlock?(text)
            }
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }()
    
    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 22
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        return contentView
    }()
    
    lazy var textView:IQTextView = {
        var textView:IQTextView = IQTextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = rgba(51, 51, 51)
        
        let atr = NSMutableAttributedString(string: "在这里输入你的问题…")
        atr.yy_font = .systemFont(ofSize: 14)
        atr.yy_color = rgba(136, 136, 136, 1)
        textView.attributedPlaceholder = atr
        contentView.addSubview(textView)
        return textView
    }()
}

extension WPAIBottomView {
    func initSubViews() -> Void {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.contentMode = .scaleToFill
        self.clipsToBounds = true
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        if let gl = (self.layer as? CAGradientLayer) {
            gl.colors = [rgba(228, 234, 255, 1).cgColor,rgba(228, 234, 255, 1).cgColor]
            gl.locations = [0,1]
            gl.startPoint = .zero;
            gl.endPoint = CGPointMake(1, 0);
        }
        
        textView.rx.didChange.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            let text = weakSelf.textView.text
            let h = text?.jk.heightAccording(width: WPScreenWidth - 38 - 12 - 44 - 32, font: .systemFont(ofSize: 14))
            if h ?? 0 <= 33 {
                UIView.animate(withDuration: 0.25) {
                    weakSelf.textView.snp.updateConstraints { make in
                        make.height.equalTo(33.0)
                    }
                }
                
            } else if let hh = h {
                var height = hh
                if height >= 17.0*4 {
                   height = 17.0*4
                }
                UIView.animate(withDuration: 0.25) {
                    weakSelf.textView.snp.updateConstraints { make in
                        make.height.equalTo(height)
                    }
                }
            }

        }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.textView.text = ""
            weakSelf.textView.snp.updateConstraints { make in
                make.height.equalTo(33.0)
            }
            
        }).disposed(by: disposeBag)
 
        
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

    }
    
    func makeConstraints() -> Void {
        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(44*1.0)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-34)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(sendButton.snp.left).offset(-12)
            make.bottom.equalTo(sendButton)
            make.top.equalToSuperview().offset(20)
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(19)
            make.right.equalTo(contentView).offset(-19)
            make.bottom.equalTo(contentView).offset(-5)
            make.top.equalTo(contentView).offset(5)
            make.height.equalTo(33.0)
        }
    }
}

extension WPAIBottomView {
    @objc func keyboardWillShow(notification: Notification) {
            // 从通知中获取键盘的frame
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                // 转换为CGRect并获取高度
                let keyboardRectangle = keyboardFrame.cgRectValue
                let height = keyboardRectangle.height
                keyboardHeight = height
                
                
                if self.superview != nil {
                    // 根据键盘高度调整textView的位置，确保它不会被键盘遮挡
                    UIView.animate(withDuration: 0.25) {
                        self.snp.updateConstraints { make in
                            make.bottom.equalToSuperview().offset(-height+25)
                        }
                    } completion: { r in
                        self.showKeyBordBlock?()
                    }
                }
      
            }
        }

        @objc func keyboardWillHide(notification: Notification) {
            if self.superview != nil {
                // 当键盘消失时，恢复textView的原始位置
                UIView.animate(withDuration: 0.25) {
                    self.snp.updateConstraints { make in
                        make.bottom.equalToSuperview()
                    }
                }
            }

            keyboardHeight = 0.0
        }

}
