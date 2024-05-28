//
//  WPSexSheetView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/11.
//

import UIKit

class WPSexSheetView: UIView {
    var didSelectedBlock:((_ sex:Int)->Void)?
    private var sex:Int = 0

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
        label.text = "选择你的性别"
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
   
    lazy var sender: UIButton = {
        var sender: UIButton = UIButton()
        let img = UIImage.wp.createColorImage(rgba(254, 143, 11, 1), size: CGSize(width: 165, height: 48)).wp.roundCorner(12)
        sender.setBackgroundImage(img, for: .normal)
        sender.setTitle("确定", for: .normal)
        sender.setTitleColor(rgba(255, 255, 255, 1), for: .normal)
        sender.titleLabel?.font = .systemFont(ofSize: 16)
    
        sender.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.didSelectedBlock?(weakSelf.sex)
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(sender)
        return sender
    }()
    
    lazy var girlItem: UIButton = {
        var girlItem: UIButton = UIButton()
        girlItem.setBackgroundImage(.init(named: "女-灰"), for: .normal)
        girlItem.setBackgroundImage(.init(named: "女-选中"), for: .selected)
        girlItem.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.sex = 0
            girlItem.isSelected = true
            weakSelf.boyItem.isSelected = false

        }).disposed(by: disposeBag)
        contentView.addSubview(girlItem)
        return girlItem
    }()
    
    lazy var boyItem: UIButton = {
        var boyItem: UIButton = UIButton()
        boyItem.setBackgroundImage(.init(named: "男-灰"), for: .normal)
        boyItem.setBackgroundImage(.init(named: "男-选中"), for: .selected)
        boyItem.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.sex = 1
            boyItem.isSelected = true
            weakSelf.girlItem.isSelected = false
            
        }).disposed(by: disposeBag)
        contentView.addSubview(boyItem)
        return boyItem
    }()
}


extension WPSexSheetView {
    func show() -> Void {
        WPKeyWindowDev?.addSubview(self)
        let h = 312 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
        self.alpha = 1
        
        contentView.y = WPScreenHeight
        UIView.animate(withDuration: 0.25) {
            self.contentView.y = WPScreenHeight - h
        }
    }
    
    func hidden() -> Void {
        UIView.animate(withDuration: 0.25) {
            self.contentView.y = WPScreenHeight
            self.alpha = 0
            
        } completion: { r in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self {
            hidden()
        }
    }
}

extension WPSexSheetView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.5)
        let h = 312 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
        contentView.frame = .init(x: 0, y: WPScreenHeight - h, width: WPScreenWidth, height: h)
        contentView.setCorners([.topLeft,.topRight], cornerRadius: 8)
        guard let gender = WPUser.user()?.userInfo?.gender else {
            self.girlItem.isSelected = true
            return
        }
        self.sex = gender
        if gender == 0 {
            self.girlItem.isSelected = true
        } else {
            self.boyItem.isSelected = true
        }
    }
    
    func makeConstraints () {
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
        }
        
        girlItem.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 164, height: 166))
            make.top.equalTo(label.snp.bottom).offset(21)
            make.right.equalTo(contentView.snp.centerX).offset(-4.5)
        }
        
        boyItem.snp.makeConstraints { make in
            make.size.centerY.equalTo(girlItem)
            make.left.equalTo(contentView.snp.centerX).offset(4.5)
        }
        
        cancel.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.centerX).offset(-6.5)
            make.top.equalTo(girlItem.snp.bottom).offset(26)
            make.size.equalTo(CGSize(width: 165, height: 48))
        }
        
        sender.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(6.5)
            make.size.centerY.equalTo(cancel)
        }
    }
}
