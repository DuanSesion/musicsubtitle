//
//  WPAIUserCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/5.
//

import UIKit

class WPAIUserCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubViews()
        makeConstraints()
    }
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.isUserInteractionEnabled = false
        let bg = UIImage.wp.createColorImage(rgba(255, 255, 255, 1), size: CGSize(width: 166, height: 78)).wp.roundCorner(12)
        let blueBg = UIImage.wp.createColorImage(rgba(111, 176, 255, 1), size: CGSize(width: 166, height: 78)).wp.roundCorner(12)
        button.setBackgroundImage(bg, for: .normal)
        button.setBackgroundImage(blueBg, for: .selected)
        contentView.addSubview(button)
        return button
    }()
    
    lazy var icon: UIImageView = {
        var icon: UIImageView =  UIImageView()
        icon.layer.cornerRadius = 12
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        icon.backgroundColor = rgba(217, 217, 217, 1)
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var name: UILabel = {
        var name: UILabel = UILabel()
        name.textColor = .white
        name.font = .boldSystemFont(ofSize: 14)
        name.text = "教授名字"
        contentView.addSubview(name)
        return name
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.text = "教授title"
        contentView.addSubview(label)
        return label
    }()
}


extension WPAIUserCell {
    func makeSubViews() -> Void {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
    }
    
    func makeConstraints() -> Void {
        button.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.size.equalTo(CGSize(width: 166, height: 78))
        }
        
        icon.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(78)
        }
        
        name.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalTo(16)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(name)
            make.top.equalTo(name.snp.bottom).offset(8)
        }
    }
}
