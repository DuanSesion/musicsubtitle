//
//  WPBirthdayView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/10.
//

import UIKit

class WPBirthdayView: UIView {
    var didSelectedBlock:((_ date:Date)->Void)?

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
    
    lazy var datePicker: UIDatePicker = {
        var datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.maximumDate = Date.jk.currentDate
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        contentView.addSubview(datePicker)
        return datePicker
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "选择你的生日"
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
            weakSelf.didSelectedBlock?(weakSelf.datePicker.date)
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(sender)
        return sender
    }()
}

extension WPBirthdayView {
    func show() -> Void {
        WPKeyWindowDev?.addSubview(self)
        let h = 70.0 + 48.0*3 + 64.0 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
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

extension WPBirthdayView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        WPKeyWindowDev?.addSubview(self)
    
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.5)
        let h = 70.0 + 48.0*3 + 64.0 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
        contentView.frame = .init(x: 0, y: WPScreenHeight - h, width: WPScreenWidth, height: h)
        contentView.setCorners([.topLeft,.topRight], cornerRadius: 8)
    }
    
    func makeConstraints () {
        let stackView = UIStackView(arrangedSubviews: [datePicker])
        stackView.axis = .vertical // 或者.horizontal 根据需求调整
        stackView.spacing = 8 // 子视图间的间距
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        // 设置StackView的约束
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 70),
            stackView.heightAnchor.constraint(equalToConstant: 48*3)
        ])
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(17)
        }
        
        cancel.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.centerX).offset(-6.5)
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 165, height: 48))
        }
        
        sender.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(6.5)
            make.size.centerY.equalTo(cancel)
        }
    }
}
