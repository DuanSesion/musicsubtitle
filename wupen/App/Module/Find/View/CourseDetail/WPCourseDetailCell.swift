//
//  WPCourseDetailCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/7.
//

import UIKit

class WPCourseDetailCell: UICollectionViewCell {
    
    deinit {
        debugPrint("---init---", self)
    }
    
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
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 8
        icon.clipsToBounds = true
        icon.backgroundColor = .gray
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var userHeder: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 9
        icon.clipsToBounds = true
        icon.backgroundColor = .gray
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        var nameLabel: UILabel = UILabel()
        nameLabel.text = "吴志强"
        nameLabel.textColor = rgba(102, 102, 102, 1)
        nameLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(nameLabel)
        return nameLabel
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "建设可持续智慧城市的新加坡实践限制在..."
        textLabel.textColor = rgba(51, 51, 51, 1)
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.numberOfLines = 2
        contentView.addSubview(textLabel)
        return textLabel
    }()
    
    var model:WPCouserModel!{
        didSet {
            
            icon.sd_setImage(with: .init(string: model.coverImage ?? ""))
            userHeder.sd_setImage(with: .init(string: model.scholarAvatar ?? ""))
            if WPLanguage.chinessLanguage() {
                nameLabel.text = model.scholarName ?? "-"
                textLabel.text = model.title
            } else {
                nameLabel.text = model.scholarNameEn ?? "-"
                textLabel.text = model.titleEn
            }
        }
    }
}

extension WPCourseDetailCell {
    func makeSubviews() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    func makeConstraints() -> Void {
        icon.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(92)
            make.width.equalTo((WPScreenWidth-45)/2)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-8)
            make.top.equalTo(icon.snp.bottom).offset(8)
        }
        
        userHeder.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.height.width.equalTo(18)
            make.bottom.equalToSuperview().offset(-13)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(userHeder.snp.right).offset(4)
            make.centerY.equalTo(userHeder)
            make.right.equalToSuperview().offset(-8)
        }
        
    }
}
