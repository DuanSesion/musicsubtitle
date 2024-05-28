//
//  WPFindeCell4.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPFindeCell4: UICollectionViewCell {
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
        icon.clipsToBounds = true
        icon.backgroundColor = .gray
        icon.layer.cornerRadius = 8
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "xxxxxxxxxxxxxxxxxxxxsasdsfdsfdsfdsfdsfdsfdsfdsfdsfdsf"
        textLabel.numberOfLines = 2
        textLabel.textColor = rgba(55, 55, 55)
        textLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var numberLabel: UILabel = {
        var numberLabel: UILabel = UILabel()
        numberLabel.text = "1111节课"
        numberLabel.textColor = rgba(165, 165, 165)
        numberLabel.font = .systemFont(ofSize: 12)
        numberLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(numberLabel)
        return numberLabel
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.isUserInteractionEnabled = false
        button.setTitle("学习", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 13)
        let bgimg = UIImage.wp.createColorImage(rgba(254, 143, 11, 1), size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)
        button.setBackgroundImage(bgimg, for: .normal)
        contentView.addSubview(button)
        return button
    }()
    
    var model:WPCouserModel? {
        didSet {
            icon.sd_setImage(with: .init(string: model?.coverImage ?? ""))
            if WPLanguage.chinessLanguage() {
                textLabel.text = model?.chineseName
                numberLabel.text = "\(model?.lectureCount ?? 0)节课程"
                
            } else {
                textLabel.text = model?.englishName
                numberLabel.text = "\(model?.lectureCount ?? 0) subject"
            }
        }
    }
}


extension WPFindeCell4 {
    func makeSubviews() {
        self.isUserInteractionEnabled = true
 
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = .init(width: -5, height: 5)
        self.layer.opacity = 1
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.shadowColor = rgba(0, 0, 0, 0.01).cgColor
        
        self.contentView.backgroundColor = .white
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 8
    }
    
    func makeConstraints() -> Void {
        icon.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(92)
            make.width.equalTo((WPScreenWidth-45)/2)
        }
        
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 66, height: 29))
        }
        
        textLabel.snp.makeConstraints { make in
            make.right.lessThanOrEqualTo(contentView).offset(-8)
            make.left.equalTo(contentView).offset(8)
            make.top.equalTo(icon.snp.bottom).offset(5)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.right.lessThanOrEqualTo(button.snp.left).offset(-3)
            make.left.equalTo(textLabel)
            make.centerY.equalTo(button)
        }
    }
}
