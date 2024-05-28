//
//  WPLoginView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit
import AuthenticationServices

class WPLoginView: UIImageView {
    public var logionBlock:(()->Void)?
    public var closeBlock:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    lazy var loginButton: UIButton = {
        var loginButton: UIButton = UIButton()
        loginButton.setTitle("登录/注册", for: .normal)
        loginButton.backgroundColor = rgba(254, 143, 11, 1)
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 25.0
        loginButton.isEnabled = false
        loginButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.endEditing(true)
            if weakSelf.checkButton.isSelected {
                let phone = weakSelf.phoneField.text?.wp.trim()
                let code = weakSelf.codeField.text?.wp.trim()
                weakSelf.login(code: code, phone: phone)
                
            } else {
                self?.showMessage("请先阅读用户协议和隐私政策")
            }
        }).disposed(by: disposeBag)
        addSubview(loginButton)
        return loginButton
    }()
    
    lazy var closeButton: UIButton = {
        var closeButton: UIButton = UIButton()
        closeButton.setTitle("关闭", for: .normal)
        closeButton.backgroundColor = .systemGray
        closeButton.clipsToBounds = true
        closeButton.layer.cornerRadius = 23.0
        closeButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.closeBlock?()
        }).disposed(by: disposeBag)
        addSubview(closeButton)
        return closeButton
    }()
    
    lazy var phoneField: WPLoginPhoneField = {
        var phoneField: WPLoginPhoneField = WPLoginPhoneField()
        phoneField.editeChangeBlock = .some({ [weak self] in
            self?.inputChangeState()
        })
        addSubview(phoneField)
        return phoneField
    }()
    
    lazy var codeField : WPLoginCodeField = {
        var codeField: WPLoginCodeField = WPLoginCodeField()
        codeField.editeChangeBlock = .some({ [weak self] in
            self?.inputChangeState()
        })
        codeField.getCodeBlock = .some({ [weak self] in
            self?.endEditing(true)
            
            let phone:String = self?.phoneField.text?.wp.trim() ?? ""
            if phone.count >= 11 {
               
                codeField.getPhoneCode(mobile: phone)
            } else {
                self?.showMessage("手机号码有误")
            }
        })
        addSubview(codeField)
        return codeField
    }()
    
    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        return contentView
    }()
    
    lazy var checkButton: UIButton = {
        var checkButton: UIButton = UIButton()
        checkButton.setImage(.init(named: "login_un_check_icon"), for: .normal)
        checkButton.setImage(.init(named: "login_check_icon"), for: .selected)
        checkButton.backgroundColor = .clear
        checkButton.clipsToBounds = true
        checkButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            checkButton.isSelected = !checkButton.isSelected
        }).disposed(by: disposeBag)
        contentView.addSubview(checkButton)
        return checkButton
    }()
    
    lazy var textLabel: YYLabel = {
        var label: YYLabel = YYLabel()
        //label.isOpaque = true
        label.font = .systemFont(ofSize: 11)
        label.textColor = rgba(136, 136, 136, 1)
        label.isUserInteractionEnabled = true
        let text = "我已经详细阅读并同意《用户服务协议》和《隐私政策》"
        var attributedText:NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributedText.yy_font = .systemFont(ofSize: 11)
        attributedText.yy_color = rgba(136, 136, 136, 1)
        attributedText.yy_alignment = .left
    
        attributedText.yy_setTextHighlight(NSRange(location: 10, length: 8),
                                color: rgba(254, 143, 11, 1),
                                backgroundColor: .gray, tapAction: {(containerView, text, range, rect) in
            //UIApplication.shared.open(URL(string: AgreementURL)!)
            debugPrint(text.string)
        }) { v, s, r, rect in
             
        }
        
        attributedText.yy_setTextHighlight(NSRange(location: text.count-6, length: 6),
                                           color: rgba(254, 143, 11, 1),
                                backgroundColor: .gray, tapAction: {(containerView, text, range, rect) in
            //UIApplication.shared.open(URL(string: PolicyURL)!)
            debugPrint(text.string)
        })
        
        label.textAlignment = .left
        label.attributedText = attributedText
        label.sizeToFit()
        contentView.addSubview(label)
        return label
    }()
    
    lazy var line: UIImageView = {
        var contentView: UIImageView = UIImageView(image: .init(named: "login_other_icon"))
        contentView.backgroundColor = .clear
        addSubview(contentView)
        return contentView
    }()
    
    lazy var appleLoginButton: UIButton = {
        var loginButton: UIButton = UIButton()
        loginButton.setImage(.init(named: "login_apple_icon"), for: .normal)
        loginButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.endEditing(true)
            if weakSelf.checkButton.isSelected {
                weakSelf.appleAuthorization()
            } else {
                self?.showMessage("请先阅读用户协议和隐私政策")
            }
        }).disposed(by: disposeBag)
        addSubview(loginButton)
        return loginButton
    }()
}

extension WPLoginView {
    func inputChangeState() -> Void {
        let phone:String = phoneField.text?.wp.trim() ?? ""
        let phoneCount = phone.count
        let codeCount = codeField.text?.wp.trim().count ?? 0
        if phoneCount >= 11 && codeCount >= 4 {
            loginButton.isEnabled = true

        } else {
            loginButton.isEnabled = false
        }

        if "获取验证码" == self.codeField.button.currentTitle {
            self.codeField.button.isEnabled = (phoneCount >= 11)
        } else {
            self.codeField.button.isEnabled = true
        }
    }
}

extension WPLoginView {
    func initSubViews() -> Void {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        self.contentMode = .scaleToFill
        self.image = .init(named: "login_bg_icon")
        IQKeyboardManager.shared.enable = true
        
        loginButton.snp.makeConstraints { make in
            make.size.equalTo(phoneField)
            make.centerX.equalTo(self)
            make.top.equalTo(codeField.snp.bottom).offset(67)
        }
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 46, height: 46))
            make.top.equalTo(self).offset(kStatusBarHeight)
            make.left.equalTo(self).offset(15)
        }
        
        phoneField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: WPScreenWidth-72, height: 50))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(320.0)
        }
        
        codeField.snp.makeConstraints { make in
            make.size.equalTo(phoneField)
            make.centerX.equalTo(self)
            make.top.equalTo(phoneField.snp.bottom).offset(15.0)
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.centerX.equalTo(self)
            make.top.equalTo(codeField.snp.bottom).offset(18)
        }
        
        checkButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(10)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerY.height.equalTo(contentView)
            make.left.equalTo(checkButton.snp.right)
            make.right.equalTo(contentView).offset(-10)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-54)
        }
        
        line.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-20)
        }
        
        line.isHidden = true
        appleLoginButton.isHidden = true
        self.closeButton.isHidden = true
        
//        self.showUnityNetActivity()
    }
}

extension WPLoginView {
    func appleAuthorization() -> Void {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        //request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func login(appleCode:String?=nil,code:String?=nil,phone:String?=nil) -> Void {
        self.showUnityNetActivity()
        WPUser.userAuth(phone: phone, validCode: code, appleCode: appleCode) {[weak self] model in
            self?.removeNetActivity()
            if model.jsonModel?.code == 200 {
                self?.logionBlock?()
            } else if let msg = model.jsonModel?.msg {
                self?.showError(msg)
            } else {
                self?.showError(model.msg)
            }
        }
    }
}

extension WPLoginView:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor { return WPKeyWindowDev! }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            self.login(appleCode: userIdentifier)
            break

        case let passwordCredential as ASPasswordCredential:
//            let username = passwordCredential.user
//            let password = passwordCredential.password
            break
        default:
            break
        }
    }
}
