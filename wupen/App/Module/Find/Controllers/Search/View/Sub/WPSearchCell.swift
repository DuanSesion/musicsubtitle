//
//  WPSearchCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPSearchCell: UICollectionViewCell {
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
        icon.addSubview(effectView)
        return effectView
    }()
    
 
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "03-04 09:00开播"
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 11)
        label.adjustsFontSizeToFitWidth = true
        effectView.contentView.addSubview(label)
        return label
    }()
    
    lazy var stateIcon: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.backgroundColor = .clear
        icon.clipsToBounds = true
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "建设可持续智慧城市的新加坡实践限制在..."
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
        label.text = "优胜教育"
        label.textColor = rgba(102, 102, 102, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
       contentView.addSubview(label)
        return label
    }()
    
    let img = UIImage.wp.createColorImage(rgba(255, 237, 211, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//"预约"
    let img1 = UIImage.wp.createColorImage(rgba(211, 211, 211, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//已预约
    let img2 = UIImage.wp.createColorImage(rgba(254, 143, 11, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//去上课
    let img3 = UIImage.wp.createColorImage(rgba(245, 245, 245, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//已结束
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.setTitleColor(rgba(254, 143, 11, 1), for: .normal)
        button.setTitleColor(rgba(255, 255, 255, 1), for: .disabled)
        button.setTitleColor(rgba(255, 255, 255, 1), for: .selected)
        button.setTitle("预约", for: .normal)
        button.setTitle("去上课", for: .selected)
        button.setTitle("已结束", for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.conllect()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(button)
        return button
    }()
    
    lazy var userNumLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "900人已预约"
        label.textColor = rgba(168, 171, 181, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
       contentView.addSubview(label)
        return label
    }()
    
    lazy var liveStateIcon: UIButton = {
        var liveStateIcon: UIButton = UIButton()
        liveStateIcon.isUserInteractionEnabled = false
        liveStateIcon.setTitleColor(rgba(255, 255, 255, 1), for: .normal)
        liveStateIcon.titleLabel?.font = .systemFont(ofSize: 12)
        liveStateIcon.setTitle("直播课", for: .normal)
        liveStateIcon.setBackgroundImage(.init(named: "search_live_icon"), for: .normal)
        icon.addSubview(liveStateIcon)
        return liveStateIcon
    }()
    
    var model:WPLiveModel!{
        didSet {
            model.checkUpdateState()
            
            nameLabel.text = model.scholarName
            userIcon.sd_setImage(with: .init(string: model.scholarAvatar ?? ""))
            titleLabel.text = model.title
            
            update()
        }
    }
    
    func update() -> Void {
        label.text = model.startTime
        icon.sd_setImage(with: .init(string: model.coverUrl ?? ""))
        
        userNumLabel.text = "\(model.countSubscribe)人已预约"
        if model.isLive {
            button.setTitle("去上课", for: .normal)
            button.setBackgroundImage(img2, for: .normal)
            button.setTitleColor(.white, for: .normal)
            
            button.isSelected = false
            button.isEnabled = true
            button.isUserInteractionEnabled = false
            
        } else  if model.status == 0 && model.isConlllect == false {//预约 未结束
            button.setBackgroundImage(img, for: .normal)
            button.setTitleColor(rgba(254, 143, 11, 1), for: .normal)
            button.isEnabled = true
            button.isSelected = false
            button.isUserInteractionEnabled = true
            
        } else if model.status == 0 && model.isConlllect == true {//已预约 未结束
            button.setTitle("已预约", for: .selected)
            button.setTitleColor(rgba(255, 255, 255, 1), for: .selected)
            button.setBackgroundImage(img1, for: .selected)
            
            button.isSelected = true
            button.isEnabled = true
            button.isUserInteractionEnabled = true
            
            
        } else if model.status == 1 {//已结束
            button.setTitle("已结束", for: .disabled)
            button.setTitleColor(rgba(168, 171, 181, 1), for: .disabled)
            button.setBackgroundImage(img3, for: .disabled)
            
            button.isSelected = false
            button.isEnabled = false
            button.isUserInteractionEnabled = false
        }
    }
}

extension WPSearchCell {
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
            make.left.bottom.width.equalToSuperview()
            make.height.equalTo(25)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-9)
            make.left.greaterThanOrEqualTo(stateIcon.snp.right)
        }
        
        stateIcon.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 66, height: 29))
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
        
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 66, height: 29))
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(userIcon.snp.bottom).offset(13)
        }
        
        userNumLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.lessThanOrEqualTo(button.snp.left)
            make.centerY.equalTo(button)
        }
        
        liveStateIcon.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(66)
            make.height.equalTo(29)
        }
    }
}


extension WPSearchCell {
    func conllect() -> Void {
        if model.isConlllect == false {
            model.userCollect {[weak self] model in
                guard let weakSelf = self else { return  }
                
                let result:Bool = (model.jsonModel?.data as? Bool) ?? false
                if result {
                    weakSelf.model.isConlllect = true
                    weakSelf.model.countSubscribe += 1
                    weakSelf.update()
                    
                } else {
                    let ss = model.jsonModel?.msg ?? model.msg
                    weakSelf.yy_viewController?.view.showMessage(ss)
                }
            }
            
        } else {
            model.userDeCollect {[weak self] model in
                guard let weakSelf = self else { return  }
                
                let result:Bool = (model.jsonModel?.data as? Bool) ?? false
                if result {
                    weakSelf.model.isConlllect = false
                    if weakSelf.model.countSubscribe >= 1 {weakSelf.model.countSubscribe -= 1}
                    weakSelf.update()
                    
                } else {
                    let ss = model.jsonModel?.msg ?? model.msg
                    weakSelf.yy_viewController?.view.showMessage(ss)
                }
            }
        }
    }
}
