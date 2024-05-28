//
//  WPCollectionViewCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/7.
//

import UIKit

class WPKnowledgeCell: UICollectionViewCell {
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

    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "第一讲｜当前国土空间规划的编制问题"
        textLabel.textColor = rgba(254, 143, 11, 1)
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.numberOfLines = 2
        contentView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var timeLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "00:10:57"
        textLabel.textColor = rgba(254, 143, 11, 1)
        textLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var progressLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "90%"
        textLabel.textColor = rgba(254, 143, 11, 1)
        textLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(textLabel)
        return textLabel
    }()
    
    
    var model:WPLectureVideosModel!{
        didSet {
 
            textLabel.text = model.video?.title
            timeLabel.text = model.video?.duration.durationStr()
            progressLabel.text = "\(Int(model.progress*100))%"
            updateSelected(model.isSelected)
            
            model.updateProgressBlock = .some({[weak self] in
                guard let weakSelf = self else { return  }
                weakSelf.progressLabel.text = "\(Int(weakSelf.model.progress*100))%"
            })
        }
    }
    
    func updateSelected(_ isSelected:Bool) -> Void {
        if isSelected {
            self.backgroundColor = rgba(255, 251, 242, 1)
            self.layer.borderColor = rgba(254, 176, 83, 1).cgColor
            textLabel.textColor = rgba(254, 143, 11, 1)
            timeLabel.textColor = rgba(254, 143, 11, 1)
            progressLabel.textColor = rgba(254, 143, 11, 1)
            
        } else {
            self.backgroundColor = rgba(245, 245, 245, 1)
            self.layer.borderColor = UIColor.clear.cgColor
            textLabel.textColor = rgba(136, 136, 136, 1)
            timeLabel.textColor = rgba(168, 171, 181, 1)
            progressLabel.textColor = rgba(168, 171, 181, 1)
        }
    }
}

extension WPKnowledgeCell {
    func makeSubviews() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderColor = rgba(254, 176, 83, 1).cgColor
        self.layer.borderWidth = 1
    }
    
    func makeConstraints() -> Void {
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-11)
            make.top.equalToSuperview().offset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(textLabel)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-11)
            make.centerY.equalTo(timeLabel)
        }
    }
    
    
}
