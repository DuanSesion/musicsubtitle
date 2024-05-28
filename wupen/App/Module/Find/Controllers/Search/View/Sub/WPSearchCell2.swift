//
//  WPSearchCell2.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPSearchCell2: UICollectionViewCell {

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
    
    lazy var icon: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.layer.cornerRadius = 8
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = .lightGray
        icon.clipsToBounds = true
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var effect : UIBlurEffect = {
        var effect : UIBlurEffect = .init(style: .light)
        return effect
    }()
    
    lazy var effectView : UIVisualEffectView = {
        var effectView : UIVisualEffectView = UIVisualEffectView(effect: effect)
        effectView.layer.cornerRadius = 12.5
        effectView.clipsToBounds = true
        icon.addSubview(effectView)
        return effectView
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(.init(named: "look_icon"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("0万", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        effectView.contentView.addSubview(button)
        return button
    }()
    
    
    lazy var titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "..."
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        contentView.addSubview(label)
        return label
    }()
    
    
    lazy var userIcon: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.layer.cornerRadius = 8.5
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = .lightGray
        icon.clipsToBounds = true
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = ""
        label.textColor = rgba(102, 102, 102, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
       contentView.addSubview(label)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = ""
        label.textColor = rgba(168, 171, 181, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        contentView.addSubview(label)
        return label
    }()
    
    var model:WPCouserModel!{
        didSet {
            timeLabel.text = model.duration
            
            userIcon.sd_setImage(with: .init(string: model.scholarAvatar ?? ""))
            icon.sd_setImage(with: .init(string: model.coverImage ?? ""))
            
            let text:String = (model.learnNums >= 10000) ? String(format: ".1fw", Float(model.learnNums)/1000) : "\(model.learnNums)"
            button.setTitle(text, for: .normal)
            
            if WPLanguage.chinessLanguage() {
                titleLabel.text = model.title
                nameLabel.text  = model.scholarName ?? (model.universityName ?? "-")
                
            } else {
                titleLabel.text = model.titleEn
                nameLabel.text  = model.scholarNameEn ?? (model.universityNameEn ?? "-")
            }
        }
    }
}

extension WPSearchCell2 {
    func makeSubviews() -> Void {
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    func makeConstraints() -> Void {
        let size = CGSize(width: (WPScreenWidth - 45)/2, height: 165.0)
        
        icon.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.width.equalTo(size.width)
            make.height.equalTo(92)
        }
        
        effectView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(25)
            make.width.greaterThanOrEqualTo(55)
        }
        
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.centerY.equalToSuperview()
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-8)
            make.top.equalTo(icon.snp.bottom).offset(8)
        }
        
        userIcon.snp.makeConstraints { make in
            make.width.height.equalTo(17)
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userIcon)
            make.left.equalTo(userIcon.snp.right).offset(4)
            make.right.lessThanOrEqualToSuperview().offset(-8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.lessThanOrEqualToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-15)
            make.top.equalTo(userIcon.snp.bottom).offset(12)
        }
    }
}
