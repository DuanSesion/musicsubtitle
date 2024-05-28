//
//  WPFindeCell2.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPFindeCell2: UICollectionViewCell {
    let img = UIImage.wp.createColorImage(rgba(255, 237, 211, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//"预约"
    let img1 = UIImage.wp.createColorImage(rgba(211, 211, 211, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//已预约
    let img2 = UIImage.wp.createColorImage(rgba(255, 49, 49, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//去上课
    let img3 = UIImage.wp.createColorImage(rgba(245, 245, 245, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//已结束
    
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
    
    lazy var imageSubView: UIImageView = {
        var imageSubView: UIImageView = UIImageView()
        imageSubView.contentMode = .scaleAspectFill
        imageSubView.clipsToBounds = true
        imageSubView.layer.cornerRadius = 12
        imageSubView.backgroundColor = .gray
        imageSubView.isUserInteractionEnabled = true
        self.contentView.addSubview(imageSubView)
        return imageSubView
    }()
    
    lazy var shadowView: UIImageView = {
        var shadowView: UIImageView = UIImageView(image: .init(named: "find_shadow_icon"))
        shadowView.isUserInteractionEnabled = true
        imageSubView.addSubview(shadowView)
        return shadowView
    }()
    

    lazy var effect : UIBlurEffect = {
        var effect : UIBlurEffect = .init(style: .light)
        return effect
    }()
    
    lazy var effectView : UIVisualEffectView = {
        var effectView : UIVisualEffectView = UIVisualEffectView(effect: effect)
        effectView.contentView.layer.cornerRadius = 14
        effectView.contentView.clipsToBounds = true
        effectView.layer.cornerRadius = 14
        effectView.clipsToBounds = true
        imageSubView.addSubview(effectView)
        return effectView
    }()
    
    lazy var timeLogo: UIImageView = {
        let img:UIImage? = .init(systemName: "timer")?.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .fill)
        var liveStateView: UIImageView = UIImageView(image: img?.withTintColor(.white, renderingMode: .alwaysOriginal))
        liveStateView.contentMode = .scaleAspectFit
        liveStateView.backgroundColor = .clear
        liveStateView.tintColor = .white
        effectView.contentView.addSubview(liveStateView)
        return liveStateView
    }()
    
    lazy var timeLabel: UILabel = {
        var stateLabel: UILabel = UILabel()
        stateLabel.text = "2024-03-24 18:00"
        stateLabel.textColor = .white
        stateLabel.font = .systemFont(ofSize: 12)
        effectView.contentView.addSubview(stateLabel)
        return stateLabel
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "绿色发展，未来城市与规划…"
        textLabel.textColor = .white
        textLabel.font = .boldSystemFont(ofSize: 16)
        shadowView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var stateView: UIImageView = {
        var liveStateView: UIImageView = UIImageView(image: .init(systemName: "play.circle.fill"))
        liveStateView.contentMode = .scaleAspectFit
        liveStateView.backgroundColor = .clear
        liveStateView.tintColor = .white
        self.imageSubView.addSubview(liveStateView)
        return liveStateView
    }()
    
    
    lazy var button: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("已预约", for: .disabled)
        button.setTitleColor(.white, for: .disabled)
        
        button.setTitle("进入", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        let imgl = UIImage(named: "live_state_icon")
        button.setImage(imgl, for: .normal)
        
        let img = UIImage.wp.createColorImage(.clear, size: CGSize(width: 0.01, height: 0.01))
        button.setImage(img, for: .disabled)
        
        let imgNo = UIImage.wp.createColorImage( rgba(255, 49, 49, 1),size: CGSize(width: 80, height: 32)).wp.roundCorner(16)
        button.setBackgroundImage(imgNo, for: .normal)
       
        
        let imgDIS = UIImage.wp.createColorImage(rgba(168, 171, 181, 1),size: CGSize(width: 80, height: 32)).wp.roundCorner(16)
        button.setBackgroundImage(imgDIS, for: .disabled)
        
        var imgs:[UIImage] = []
        for i in 0..<8 {
            if let img = UIImage(named: "直播中_0000\(i)") {
                imgs.append(img)
            }
        }
        button.imageView?.animationImages = imgs
        button.imageView?.animationDuration = 1.5
        button.imageView?.startAnimating()
    
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.conllect()
    
        }).disposed(by: disposeBag)
        shadowView.addSubview(button)
        return button
    }()
    
    var model:WPFindeCellModel!{
        didSet {
            if let liveMoel = model.liveModel {
                updateLiveState(liveMoel)
                model.starAnimationBlock = .some({ [weak self] in
                    guard let weakSelf = self else { return  }
                    weakSelf.button.imageView?.startAnimating()
                })
                
            } else {
                self.model.starAnimationBlock = nil
                textLabel.text = ""
                timeLabel.text = ""
                button.imageView?.stopAnimating()
                button.setImage(nil, for: .normal)
            }
        }
    }
}

extension WPFindeCell2 {
    func updateLiveState(_ model:WPLiveModel) -> Void {
        model.checkUpdateState()
        
        model.updateLiveStateBlock = .some({[weak self] in
            guard let weakSelf = self else { return  }
            weakSelf.updateLiveState(model)
        })
        
        button.imageView?.stopAnimating()
        imageSubView.sd_setImage(with:.init(string: model.coverUrl ?? ""))
        textLabel.text = model.name
        timeLabel.text = model.startTime
        effectView.isHidden = false
        
        if model.isLive {
            let imgl = UIImage(named: "live_state_icon")
            button.setImage(imgl, for: .normal)
            
            button.setTitle("进入", for: .normal)
            button.setBackgroundImage(img2, for: .normal)
            button.setTitleColor(.white, for: .normal)
        
            button.isSelected = false
            button.isEnabled = true
            button.isUserInteractionEnabled = false
            button.imageView?.startAnimating()
            effectView.isHidden = true
     
        } else  if model.status == 0 && model.isConlllect == false {//预约 未结束
            button.setImage(nil, for: .normal)
            
            button.setTitle("预约", for: .normal)
            button.setBackgroundImage(img, for: .normal)
            button.setTitleColor(rgba(254, 143, 11, 1), for: .normal)
            button.isEnabled = true
            button.isSelected = false
            button.isUserInteractionEnabled = true
         
        } else if model.status == 0 && model.isConlllect == true {//已预约 未结束
            button.setImage(nil, for: .normal)
            
            button.setTitle("已预约", for: .normal)
            button.setTitleColor(rgba(255, 255, 255, 1), for: .normal)
            button.setBackgroundImage(img1, for: .normal)
        
            button.isSelected = false
            button.isEnabled = true
            button.isUserInteractionEnabled = true
            
        } else if model.status == 1 {//已结束
            button.setImage(nil, for: .normal)
            
            button.setTitle("已结束", for: .disabled)
            button.setTitleColor(rgba(168, 171, 181, 1), for: .disabled)
            button.setBackgroundImage(img3, for: .disabled)
        
            button.isSelected = false
            button.isEnabled = false
            button.isUserInteractionEnabled = false
        }
    }
}

extension WPFindeCell2 {
    func makeSubviews() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        let url = URL(string: "https://hbimg.b0.upaiyun.com/3d5b11e0b5693b6576b4e86243fbc5c7b59a732825148-16PKyA_fw658")
        imageSubView.sd_setImage(with: url)
      
    }
    
    func makeConstraints() -> Void {
        imageSubView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.height.equalTo(193)
            make.width.equalTo(WPScreenWidth-32)
        }
        
        shadowView.snp.makeConstraints { make in
            make.width.bottom.centerX.equalToSuperview()
            make.height.equalTo(84)
        }
        
        effectView.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(-25)
        }
        
        timeLogo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(36)
            make.width.height.equalTo(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.left.equalTo(timeLogo.snp.right).offset(3)
            make.right.lessThanOrEqualTo(effectView.contentView).offset(-12)
        }
        
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 32))
            make.right.bottom.equalToSuperview().offset(-12)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(button)
            make.right.lessThanOrEqualTo(button.snp.left).offset(-28)
        }
    }
}

extension WPFindeCell2 {
    func conllect() -> Void {
        guard let liveModel = self.model.liveModel else { return }
        
        if liveModel.isConlllect == false {
            liveModel.userCollect {[weak self] model in
                guard let weakSelf = self else { return  }
                
                let result:Bool = (model.jsonModel?.data as? Bool) ?? false
                if result {
                    liveModel.isConlllect = true
                    liveModel.countSubscribe += 1
                    weakSelf.updateLiveState(liveModel)
                    
                } else {
                    let ss = model.jsonModel?.msg ?? model.msg
                    weakSelf.yy_viewController?.view.showMessage(ss)
                }
            }
            
        } else {
            liveModel.userDeCollect {[weak self] model in
                guard let weakSelf = self else { return  }
                
                let result:Bool = (model.jsonModel?.data as? Bool) ?? false
                if result {
                    liveModel.isConlllect = false
                    if liveModel.countSubscribe >= 1 {liveModel.countSubscribe -= 1}
                    weakSelf.updateLiveState(liveModel)
                    
                } else {
                    let ss = model.jsonModel?.msg ?? model.msg
                    weakSelf.yy_viewController?.view.showMessage(ss)
                }
            }
        }
    }
}
