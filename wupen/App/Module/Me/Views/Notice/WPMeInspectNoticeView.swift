//
//  WPMeInspectNoticeView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

class WPMeInspectNoticeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        makeSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubViews()
        makeConstraints()
    }
    
    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        addSubview(contentView)
        return contentView
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        let img = UIImage.wp.createColorImage(rgba(255, 145, 16, 1), size: CGSize(width: 176, height: 40)).wp.roundCorner(20)
        button.setBackgroundImage(img, for: .normal)
        button.setTitle("确定", for: .normal)
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            self?.dismiss {
                self?.contentView.transformMini()
            }
        }).disposed(by: disposeBag)
        contentView.addSubview(button)
        return button
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "公告通知"
        label.textColor = rgba(51, 51, 51, 1)
        label.font = .systemFont(ofSize: 16)
        contentView.addSubview(label)
        return label
    }()
    
    
    lazy var textView: UITextView = {
        var textView: UITextView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 13)
        textView.textColor = rgba(51, 51, 51, 1)
        contentView.addSubview(textView)
        return textView
    }()
    
    func show() {
        self.show {[weak self] in
            self?.contentView.transformMax()
        }
    }
    
    var model:WPUserNoticeModel!{
        didSet {
            label.text = model.title?.wp.trim()
            textView.text = model.content?.wp.trim()
        }
    }
}


extension WPMeInspectNoticeView {
    func makeSubViews() -> Void {
        self.backgroundColor = rgba(0, 0, 0, 0.6)
        self.isUserInteractionEnabled = true
        textView.text = " "
    }
    
    func makeConstraints() -> Void {
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 296, height: 338))
        }
        
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 176, height: 40))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(label.snp.bottom).offset(8)
            make.bottom.equalTo(button.snp.top).offset(-14)
        }

        contentView.transformMini()
    }
}
