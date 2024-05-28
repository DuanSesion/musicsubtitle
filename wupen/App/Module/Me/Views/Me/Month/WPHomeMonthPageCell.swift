//
//  WPHomeMonthPageCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/2.
//

import UIKit

class WPHomeMonthPageCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    lazy var backIcon: UIImageView = {
        var backIcon: UIImageView = UIImageView(image: .init(named: "me_sel_month_icon"))
        backIcon.contentMode = .scaleAspectFit
        contentView.addSubview(backIcon)
        return backIcon
    }()
    
    lazy var hotNewsTextLabel: UILabel = {
        var hotNewsTextLabel: UILabel = UILabel()
        hotNewsTextLabel.text = "九月"
        hotNewsTextLabel.font = .systemFont(ofSize: 12)
        hotNewsTextLabel.textColor = rgba(187, 187, 187, 1)
        hotNewsTextLabel.textAlignment = .center
        hotNewsTextLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(hotNewsTextLabel)
        return hotNewsTextLabel
    }()
    
    func setup() -> Void {
        self.backgroundView = backIcon
        self.backgroundView?.isHidden = true
        
        self.hotNewsTextLabel.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
            make.width.height.equalTo(self.contentView)
        }
    }
    
    var isIndex:Bool? {
        didSet {
            if isIndex == true {
                self.hotNewsTextLabel.font = .boldSystemFont(ofSize: 16)
                self.hotNewsTextLabel.textColor = rgba(51, 51, 51, 1)
                self.backgroundView?.isHidden = false
                
            } else {
                self.hotNewsTextLabel.font = .systemFont(ofSize: 13)
                self.hotNewsTextLabel.textColor = rgba(136, 136, 136, 1)
                self.backgroundView?.isHidden = true
            }
        }
    }
}
