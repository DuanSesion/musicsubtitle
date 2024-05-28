//
//  WPBannerCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/29.
//

import UIKit

class WPBannerCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubViews()
    }
    
    lazy var imageView: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        return imageView
    }()
}


extension WPBannerCell {
    public func makeSubViews() -> Void {
        self.backgroundColor = rgba(245, 245, 245)
        imageView.snp.makeConstraints { make in
            make.height.centerY.equalTo(contentView)
            make.width.equalTo(WPScreenWidth-32)
            make.left.equalToSuperview().offset(16)
        }
    }
}

