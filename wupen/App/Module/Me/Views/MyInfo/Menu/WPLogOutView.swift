//
//  WPLogOutView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/11.
//

import UIKit

enum WPLogOutViewType:Int {
    case  logout
    case  resiginAcount
}

class WPLogOutView: UIView {
    var didSelectedBlock:(()->Void)?
    private var type:WPLogOutViewType = .logout

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
    
    init(_ type:WPLogOutViewType = .logout) {
        super.init(frame: UIScreen.main.bounds)
        self.type = type
        makeSubviews()
        makeConstraints()
    }
    
    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        return contentView
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "登出确认"
        label.textColor = rgba(51, 51, 51, 1)
        label.font = .systemFont(ofSize: 16)
        contentView.addSubview(label)
        return label
    }()
    
    lazy var textLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "一经注销，所有个人信息将被抹去无法\n找回，是否确认注销？"
        label.textColor = rgba(136, 136, 136, 1)
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 2
        label.textAlignment = .center
        contentView.addSubview(label)
        return label
    }()


    lazy var sender: UIButton = {
        var sender: UIButton = UIButton()
        let img = UIImage.wp.createColorImage(.white, size: CGSize(width: 110, height: 40)).wp.roundCorner(20)
        sender.setBackgroundImage(img, for: .normal)
        sender.setTitle("注销", for: .normal)
        sender.setTitleColor(rgba(51, 51, 51, 1), for: .normal)
        sender.titleLabel?.font = .systemFont(ofSize: 14)
        sender.layer.borderWidth = 0.5
        sender.layer.borderColor = rgba(168, 171, 181, 1).cgColor
        sender.layer.cornerRadius = 20
        sender.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            if weakSelf.type == .resiginAcount {
               weakSelf.didSelectedBlock?()
            }
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(sender)
        return sender
    }()
    
    lazy var cancel: UIButton = {
        var cancel: UIButton = UIButton()
        let img = UIImage.wp.createColorImage(rgba(254, 143, 11, 1), size: CGSize(width: 110, height: 40)).wp.roundCorner(20)
        cancel.setBackgroundImage(img, for: .normal)
        
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(rgba(255, 255, 255, 1), for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 16)
        cancel.layer.cornerRadius = 20
        
        cancel.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            if weakSelf.type == .logout {
                weakSelf.didSelectedBlock?()
            }
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(cancel)
        return cancel
    }()
}


extension WPLogOutView {
    func show() {
        WPKeyWindowDev?.addSubview(self)
        self.alpha = 1
        self.show {
            self.contentView.transformMax()
        }
    }
    
    func hidden() {
        self.dismiss {
            self.contentView.transformMini()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self {
            hidden()
        }
    }
}

extension WPLogOutView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.5)
        if self.type == .logout {
            label.text = "登出确认"
            sender.setTitle("取消", for: .normal)
            cancel.setTitle("确定", for: .normal)
            textLabel.text = "是否确认登出？"
            
        } else {
            label.text = "注销确认"
            sender.setTitle("注销", for: .normal)
            cancel.setTitle("取消", for: .normal)
            textLabel.text = "一经注销，所有个人信息将被抹去无法\n找回，是否确认注销？"
        }
    }
    
    func makeConstraints () {
        contentView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 264, height: 176.0))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(17)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.top.equalTo(label.snp.bottom).offset(14)
        }
        
        sender.snp.makeConstraints { make in
            make.size.equalTo( CGSize(width: 110, height: 40))
            make.bottom.equalToSuperview().offset(-23)
            make.right.equalTo(contentView.snp.centerX).offset(-6.5)
        }
        
        cancel.snp.makeConstraints { make in
            make.size.centerY.equalTo(sender)
            make.left.equalTo(contentView.snp.centerX).offset(6.5)
        }
        
        self.contentView.transformMini()
    }
}
