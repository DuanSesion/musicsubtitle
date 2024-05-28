//
//  WPMeLiveStatusCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/26.
//

import UIKit

enum WPMeLiveStatusCellType {
    case first
    case end
    case one
    case none
}

class WPMeLiveStatusCell: WPMeBaseCell {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjust()
    }
    
    override class func collectionViewWithCell(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[WPLiveModel],updateBlock:@escaping(_ :Bool)->Void)->WPMeLiveStatusCell {
        let cell:WPMeLiveStatusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WPMeLiveStatusCell", for: indexPath) as! WPMeLiveStatusCell
        if indexPath.row == 1 && datas.count == 1  {
            cell.cellType = .one
            
        } else if indexPath.row == 1 {
            cell.cellType = .first
        } else if indexPath.row == 4 {
            cell.cellType = .end
        } else {
            cell.cellType = .none
        }

        let index = indexPath.row - 1
        if datas.count > index && index >= 0 {
            cell.model = datas[index]
        }
        return cell
    }
    
    override class func didSelectItemAt(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[WPLiveModel])->Void {
        if collectionView.cellForItem(at: indexPath) is WPMeLiveStatusCell {
            let index = indexPath.row - 1
            if datas.count > index && index >= 0 {
                let model = datas[index]
                let vc:WPLiveStatusController = WPLiveStatusController()
                vc.model = model
                collectionView.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func adjust() -> Void {
        if cellType == .first {
            line.isHidden = false
            shadowView.setCorners([.topLeft,.topRight],cornerRadius:12)
            
        } else if cellType == .none {
            line.isHidden = false
            shadowView.layer.mask = nil
            
        }else if cellType == .one {
            line.isHidden = true
            shadowView.setCorners([.allCorners],cornerRadius:12)
            
        } else {
            line.isHidden = true
            shadowView.setCorners([.bottomRight,.bottomLeft],cornerRadius:12)
        }
    }
    
    lazy var meLiveButton: UIButton = {
        var meLiveButton: UIButton = UIButton()
        meLiveButton.isUserInteractionEnabled = false
        let img:UIImage? = UIImage.wp.createColorImage(rgba(254, 143, 11, 1), size: CGSize(width: 60, height: 26)).wp.roundCorner(13)
        meLiveButton.setBackgroundImage(img, for: .normal)
        meLiveButton.setTitle("进入", for: .normal)
        meLiveButton.setTitleColor(rgba(255, 255, 255, 1), for: .normal)
        
        let img1:UIImage? = UIImage.wp.createColorImage(rgba(211, 211, 211, 1), size: CGSize(width: 60, height: 26)).wp.roundCorner(13)
        meLiveButton.setBackgroundImage(img1, for: .selected)
        meLiveButton.setTitle("已预约", for: .selected)
        meLiveButton.setTitleColor(rgba(255, 255, 255, 1), for: .selected)
        
        let img2:UIImage? = UIImage.wp.createColorImage(rgba(242, 242, 242, 1), size: CGSize(width: 60, height: 26)).wp.roundCorner(13)
        meLiveButton.setBackgroundImage(img2, for: .disabled)
        meLiveButton.setTitle("已结束", for: .disabled)
        meLiveButton.setTitleColor(rgba(168, 171, 181, 1), for: .disabled)
 
        meLiveButton.titleLabel?.font = .systemFont(ofSize: 12)
        
        meLiveButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.conllect()
 
        }).disposed(by: disposeBag)
        
        shadowView.addSubview(meLiveButton)
        return meLiveButton
    }()
    
    lazy var imageView: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.backgroundColor = rgba(0, 0, 0, 0.35)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        shadowView.addSubview(imageView)
        return imageView
    }()
    
    lazy var effect : UIBlurEffect = {
        var effect : UIBlurEffect = .init(style: .extraLight)
        return effect
    }()
    
    lazy var effectView : UIVisualEffectView = {
        var effectView : UIVisualEffectView = UIVisualEffectView(effect: effect)
        imageView.addSubview(effectView)
        return effectView
    }()
    
    lazy var timeLabel: UILabel = {
        var timeLabel: UILabel = UILabel()
        timeLabel.font = .systemFont(ofSize: 11)
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.text = "4月4日 14:00开播"
        timeLabel.textColor = .white
        effectView.contentView.addSubview(timeLabel)
        return timeLabel
    }()
    
    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = "第一讲｜当前国土空间规划的编制问题"
        titleLabel.textColor = rgba(51, 51, 51, 1)
        titleLabel.numberOfLines = 2
        shadowView.addSubview(titleLabel)
        return titleLabel
    }()
    
    lazy var icon: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.backgroundColor = rgba(199, 199, 199, 0.5)
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 8.5
        icon.clipsToBounds = true
        shadowView.addSubview(icon)
        return icon
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.font = .systemFont(ofSize: 12)
        textLabel.textAlignment = .left
        textLabel.text = "机构名字在这…"
        textLabel.textColor = rgba(102, 102, 102, 1)
        shadowView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(230, 230, 230, 1)
        shadowView.addSubview(line)
        return line
    }()
    

    var cellType:WPMeLiveStatusCellType = .none {
        didSet {
            adjust()
        }
    }
    
    var model:WPLiveModel!{
        didSet {
            model.checkUpdateState()
            
            imageView.sd_setImage(with: .init(string: model.coverUrl ?? ""))
            titleLabel.text = model.name
            
            icon.sd_setImage(with: .init(string: model.userAvatar ?? ""))
            textLabel.text = model.username
            
            timeLabel.text = model.startTime
            
            update()
        }
    }
}


extension WPMeLiveStatusCell {
    func update() -> Void {

        timeLabel.isHidden = false
        effectView.isHidden = false
        
        let img = UIImage.wp.createColorImage(rgba(255, 237, 211, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//"预约"
        let img1 = UIImage.wp.createColorImage(rgba(211, 211, 211, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//已预约
        let img2 = UIImage.wp.createColorImage(rgba(254, 143, 11, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//去上课
        let img3 = UIImage.wp.createColorImage(rgba(245, 245, 245, 1),size: CGSize(width: 66, height: 29)).wp.roundCorner(14.5)//已结束
        
        let button = meLiveButton
        if model.isLive {
            button.setTitle("进入", for: .normal)
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
            timeLabel.isHidden = true
            effectView.isHidden = true
        }
    }
}

extension WPMeLiveStatusCell {
    func makeSubviews() -> Void {
        self.backgroundColor = .clear
        shadowView.layer.shadowOpacity = 0
        shadowView.layer.cornerRadius = 0
    }
    
    func makeConstraints() -> Void {
        shadowView.snp.makeConstraints { make in
            make.centerY.centerX.height.equalTo(contentView)
            make.width.equalTo(WPScreenWidth-32)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(125)
            make.left.equalToSuperview().offset(11)
        }
        
        effectView.snp.makeConstraints { make in
            make.left.width.bottom.equalToSuperview()
            make.height.equalTo(25)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.width.centerX.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(12)
            make.right.lessThanOrEqualTo(shadowView).offset(-11)
            make.top.equalTo(imageView).offset(3)
        }
        
        meLiveButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 26))
            make.right.equalToSuperview().offset(-11)
            make.bottom.equalToSuperview().offset(-9)
        }
        
        icon.snp.makeConstraints { make in
            make.bottom.equalTo(imageView).offset(-1)
            make.height.width.equalTo(17)
            make.left.equalTo(titleLabel)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(2)
            make.right.lessThanOrEqualTo(meLiveButton.snp.left).offset(5)
        }
        
        line.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-22)
            make.height.equalTo(1)
        }
    }
    
 
}

extension WPMeLiveStatusCell {
    func presentToLoginController() -> Void {
        if let vc:WPBaseController = self.yy_viewController as? WPBaseController {
            vc.presentToLoginController()
        }
    }
}


extension WPMeLiveStatusCell {
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
