//
//  WPPlayRouteView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/13.
//

import UIKit

class WPPlayRouteView: UIView {
    
    public var rate:Float = 1
    private var screenState: WPPlayerContentView.WPPlayerScreenState = .small
    var didSelectedBlock:((_ rate:Float)->Void)?

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
    
    lazy var cancel: UIButton = {
        var cancel: UIButton = UIButton()
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(rgba(136, 136, 136, 1), for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 14)
        cancel.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(cancel)
        return cancel
    }()
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(245, 245, 245)
        contentView.addSubview(line)
        return line
    }()
    
    lazy var rate1: UIButton = {
        var rate: UIButton = createButtn("1.0X", rate: 1.0)
        rate.isSelected = true
        return rate
    }()
    
    lazy var rate2: UIButton = {
        var rate: UIButton = createButtn("1.25X", rate: 1.25)
        return rate
    }()
    
    lazy var rate3: UIButton = {
        var rate: UIButton = createButtn("1.5X", rate: 1.5)
        return rate
    }()
    
    lazy var rate4: UIButton = {
        var rate: UIButton = createButtn("1.75X", rate: 1.75)
        return rate
    }()
    
    lazy var rate5: UIButton = {
        var rate: UIButton = createButtn("2.0X", rate: 2.0)
        return rate
    }()
}

extension WPPlayRouteView {
    func createButtn(_ text:String, rate:Float) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(rgba(51, 51, 51, 1), for: .normal)
        button.setTitleColor(rgba(254, 143, 11, 1), for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.rate = rate
            
            weakSelf.rate1.isSelected = false
            weakSelf.rate2.isSelected = false
            weakSelf.rate3.isSelected = false
            weakSelf.rate4.isSelected = false
            weakSelf.rate5.isSelected = false
            
            button.isSelected = true
            weakSelf.didSelectedBlock?(rate)
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(button)
        return button
    }
}

extension WPPlayRouteView {
    func show(screenState: WPPlayerContentView.WPPlayerScreenState = .small) -> Void {
        WPKeyWindowDev?.addSubview(self)
        self.alpha = 1
        self.screenState = screenState
        updateUI(screenState:screenState)
        
        if screenState == .small {
            let h = 332 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
            contentView.y = WPScreenHeight
            UIView.animate(withDuration: 0.25) {
                self.contentView.y = WPScreenHeight - h
            }
            
        } else {
            UIView.animate(withDuration: 0.25) {
                self.contentView.x = WPScreenWidth - 200
            }
        }
    }
    
    func hidden() -> Void {
        if screenState == .small {
            UIView.animate(withDuration: 0.25) {
                self.contentView.y = WPScreenHeight
                self.alpha = 0
                
            } completion: { r in
                self.removeFromSuperview()
            }
            
        } else {
            UIView.animate(withDuration: 0.25) {
                self.contentView.x = WPScreenWidth
                self.alpha = 0
                
            } completion: { r in
                self.removeFromSuperview()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self {
            hidden()
        }
    }
}

extension WPPlayRouteView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.5)
        updateUI()
    }
    
    func updateUI(screenState: WPPlayerContentView.WPPlayerScreenState = .small) -> Void {
        self.frame = UIScreen.main.bounds
        if screenState == .small {
            let h = 332 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
            contentView.frame = .init(x: 0, y: WPScreenHeight - h, width: WPScreenWidth, height: h)
            contentView.setCorners([.topLeft,.topRight], cornerRadius: 8)
            
        } else {
            let h = WPScreenHeight
            contentView.frame = .init(x: WPScreenWidth, y: 0, width: 200, height: h)
            contentView.setCorners([.topLeft,.topRight], cornerRadius: 0)
        }
    }
    
    func makeConstraints () {
        line.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-66)
        }
        cancel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(line.snp.bottom)
            make.width.equalTo(166)
            make.height.equalTo(50)
        }
        rate1.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        rate2.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(rate1)
            make.top.equalTo(rate1.snp.bottom).offset(28)
        }
        rate3.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(rate1)
            make.top.equalTo(rate2.snp.bottom).offset(28)
        }
        rate4.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(rate1)
            make.top.equalTo(rate3.snp.bottom).offset(28)
        }
        rate5.snp.makeConstraints { make in
            make.width.height.centerX.equalTo(rate1)
            make.top.equalTo(rate4.snp.bottom).offset(28)
        }
    }
}
