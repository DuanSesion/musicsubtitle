//
//  WPSearCacheCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPSearCacheCell: UICollectionViewCell {
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
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "xxxxxxx"
        label.textColor = rgba(51, 51, 51, 1)
        label.font = .systemFont(ofSize: 14)
        contentView.addSubview(label)
        return label
    }()
}

extension WPSearCacheCell {
    func makeSubviews() -> Void {
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }
    
    func makeConstraints() -> Void {
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo((WPScreenWidth - 42)/2 - 5)
            make.centerY.height.equalToSuperview()
        }
    }
}
