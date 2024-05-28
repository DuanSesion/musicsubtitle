//
//  WPMeHeaderView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

class WPMeHeaderView: UICollectionReusableView {
    class func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView  {
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            if let headerView:WPMeHeaderView = reusableView as? WPMeHeaderView {
                headerView.reloadData()
            }
            return reusableView
        } else {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            return reusableView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    lazy var userHeder: UIImageView = {
        var userHeder: UIImageView = UIImageView()
        userHeder.contentMode = .scaleAspectFill
        userHeder.isUserInteractionEnabled = true
        userHeder.cornerRadius = 33.0
        userHeder.clipsToBounds = true
        userHeder.borderColor = .white
        userHeder.borderWidth = 2
        userHeder.backgroundColor = .clear
        let tap:UITapGestureRecognizer = .init()
        tap.rx.event.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            if WPUser.user() == nil {
                weakSelf.presentToLoginController()
            } else {
                weakSelf.presentToMyInfoController()
            }
            
        }).disposed(by: disposeBag)
        userHeder.addGestureRecognizer(tap)
        addSubview(userHeder)
        return userHeder
    }()
    
    lazy var colorAlphaView: WPColorAlphaView = {
        var colorAlphaView: WPColorAlphaView = WPColorAlphaView()
        colorAlphaView.isUserInteractionEnabled = true
        let tap:UITapGestureRecognizer = .init()
        tap.rx.event.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            debugPrint("点击等级...")
      
        }).disposed(by: disposeBag)
        colorAlphaView.addGestureRecognizer(tap)
        addSubview(colorAlphaView)
        return colorAlphaView
    }()
    
    lazy var leveLabel: UILabel = {
        var leveLabel: UILabel =  UILabel()
        leveLabel.text = "LV.0"
        leveLabel.textColor = .white
        leveLabel.font = .systemFont(ofSize: 13)
        colorAlphaView.addSubview(leveLabel)
        return leveLabel
    }()
    
    lazy var line: UIImageView = {
        var line: UIImageView = UIImageView()
        let img = UIImage.wp.createColorImage(.white, size: CGSize(width: 1, height: 9))
        line.image = img
        colorAlphaView.addSubview(line)
        return line
    }()
    
    lazy var leveTextLabel: UILabel = {
        var leveTextLabel: UILabel =  UILabel()
        leveTextLabel.text = "小卡拉咪"
        leveTextLabel.textColor = .white
        leveTextLabel.font = .systemFont(ofSize: 13)
        colorAlphaView.addSubview(leveTextLabel)
        return leveTextLabel
    }()
    
    lazy var nickNameLabel: UILabel = {
        var nickNameLabel: UILabel =  UILabel()
        nickNameLabel.text = "Little Apple"
        nickNameLabel.textColor = rgba(51, 51, 51, 1)
        nickNameLabel.font = .systemFont(ofSize: 20)
        nickNameLabel.isUserInteractionEnabled = true
        nickNameLabel.numberOfLines = 2
        let tap:UITapGestureRecognizer = .init()
        tap.rx.event.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            if WPUser.user() == nil {
                weakSelf.presentToLoginController()
            } else {
                weakSelf.presentToMyInfoController()
            }
        }).disposed(by: disposeBag)
        nickNameLabel.addGestureRecognizer(tap)
        addSubview(nickNameLabel)
        return nickNameLabel
    }()
    
    lazy var messageButton: UIButton = {
        let img:UIImage? = .init(named: "通知icon") //UIImage(systemName: "bell")
        var messageButton: UIButton = createButton(img,tag: 11)
        messageButton.tintColor = rgba(54, 63, 94, 1)
        return messageButton
    }()
    
    lazy var messageBade: UIImageView = {
        var messageBade: UIImageView = UIImageView()
        let img = UIImage.wp.createColorImage(rgba(248, 75, 1, 1), size: CGSize(width: 8, height: 8)).wp.roundCorner(4)
        messageBade.image = img
        addSubview(messageBade)
        return messageBade
    }()

    lazy var learnNoLabel: UILabel = {
        var learnNoLabel: UILabel =  UILabel()
        learnNoLabel.text = "学号：NO.23878"
        learnNoLabel.textColor = rgba(102, 102, 102, 1)
        learnNoLabel.font = .systemFont(ofSize: 13)
        addSubview(learnNoLabel)
        return learnNoLabel
    }()
    
    lazy var creditFeiView: UIButton = {
        let img = UIImage(named: "学分icon")
        var creditFeiView: UIButton = createButton(img, text: "学分")
        return creditFeiView
    }()
    
    lazy var studyTimeView: UIButton = {
        let img = UIImage(named: "时长icon")
        var studyTimeView: UIButton = createButton(img, text: "累计时长")
        return studyTimeView
    }()
     
}
extension WPMeHeaderView {
    func presentToLoginController() -> Void {
        if let vc:WPBaseController = self.yy_viewController as? WPBaseController {
            vc.presentToLoginController()
        }
    }
    
    func presentToMyInfoController() -> Void {
        if let vc:WPBaseController = self.yy_viewController as? WPBaseController {
            let myInfoController = WPMyInfoController()
            vc.navigationController?.pushViewController(myInfoController, animated: true)
        }
    }
    
    func presentToNoticeController() -> Void {
        if let vc:WPBaseController = self.yy_viewController as? WPBaseController {
            let noticeController = WPNoticeController()
            vc.navigationController?.pushViewController(noticeController, animated: true)
        }
    }
    
    
    func createButton(_ img:UIImage?,tag:Int) -> UIButton {
        let button: UIButton = UIButton()
        button.tag = tag
        button.setImage(img, for: .normal)
        button.backgroundColor = .clear
        button.clipsToBounds = true
        button.layer.cornerRadius = 20.0
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.presentToNoticeController()
      
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }
    
    func createButton(_ img:UIImage?,text:String) -> UIButton {
        let button: UIButton = UIButton()
        button.tag = tag
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12.0
        button.layer.shadowOffset = .init(width: -1, height: -2)
        button.layer.shadowColor = rgba(225, 241, 255, 0.50).cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1
        button.layer.backgroundColor = UIColor.white.cgColor
        
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }

            if let user = WPUser.user() {
                if weakSelf.creditFeiView == button {
                    let vc:WPMYScoreController = WPMYScoreController()
                    weakSelf.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc:WPCalculateTimeController = WPCalculateTimeController()
                    weakSelf.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                weakSelf.presentToLoginController()
            }
      
        }).disposed(by: disposeBag)
        
        
        let label: UILabel =  UILabel()
        label.tag = 100
        label.text = ""
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "DIN Alternate", size: 24)
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(17)
            make.right.lessThanOrEqualTo(button).offset(-10)
        }
        
        let rightImg = UIImage(named: "更多")
        let rightIcon = UIImageView(image: rightImg)
        rightIcon.contentMode = .scaleAspectFit
        button.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-18)
        }
        
        let leftIcon = UIImageView(image: img)
        leftIcon.contentMode = .scaleAspectFit
        button.addSubview(leftIcon)
        leftIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalToSuperview().offset(17)
            make.centerY.equalTo(rightIcon)
        }
        
        let textLabel: UILabel =  UILabel()
        textLabel.text = text
        textLabel.textColor = rgba(153, 153, 153, 1)
        textLabel.textAlignment = .left
        textLabel.font = UIFont(name: "DIN", size: 14)
        button.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerY.equalTo(leftIcon)
            make.left.equalTo(leftIcon.snp.right).offset(2)
        }

        addSubview(button)
        return button
    }
}

extension WPMeHeaderView {
    func setup() -> Void {
        self.backgroundColor = .clear

        userHeder.snp.makeConstraints { make in
            make.width.height.equalTo(66)
            make.left.equalTo(15)
            make.top.equalTo(kNavigationBarHeight+15)
        }
        
        colorAlphaView.snp.makeConstraints { make in
            make.left.equalTo(userHeder)
            make.top.equalTo(userHeder.snp.bottom).offset(15)
            make.height.equalTo(26)
        }
        
        leveLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        line.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(leveLabel.snp.right).offset(8)
        }
        
        leveTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(line.snp.left).offset(8)
            make.right.equalToSuperview().offset(-10)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(userHeder.snp.right).offset(10)
            make.right.lessThanOrEqualTo(messageButton.snp.left)
            make.top.equalTo(userHeder).offset(9)
        }
        
        messageButton.snp.makeConstraints { make in
            make.width.height.equalTo(29)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(userHeder)
        }
        
        messageBade.snp.makeConstraints { make in
            make.top.equalTo(messageButton).offset(5)
            make.right.equalTo(messageButton).offset(-5)
        }
        
        learnNoLabel.snp.makeConstraints { make in
            make.left.equalTo(nickNameLabel)
            make.right.lessThanOrEqualTo(self).offset(-15)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(9)
        }
        
        creditFeiView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(self.snp.centerX).offset(-4.5)
            make.height.equalTo(85)
            make.top.equalTo(colorAlphaView.snp.bottom).offset(18)
        }
        
        studyTimeView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(4.5)
            make.size.centerY.equalTo(creditFeiView)
        }
    }
}

extension WPMeHeaderView {

    func getLongTime(hour:Int=0, min:Int=0)->NSAttributedString {
        var str = "\(hour)时\(min)分"
        if hour <= 0 {
            str = "\(min)分"
        }
        
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.yy_font = UIFont(name: "DIN Alternate", size: 24)
        attributedString.yy_color = rgba(51, 51, 51, 1)
        
        let font = UIFont(name: "DIN Alternate", size: 12)
        
        if let position:Range<String.Index> = str.range(of: "时"),
            let range = str.nsRange(from: position) {
            attributedString.yy_setFont(font, range: range)
        }
        
        if let position:Range = str.range(of: "分"),
           let range = str.nsRange(from: position) {
            attributedString.yy_setFont(font, range: range)
        }
        return attributedString
    }
}

extension WPMeHeaderView {
    func reloadData() -> Void {
        let user = WPUser.user()
        nickNameLabel.text = user?.userInfo?.username ?? "未登录"
        learnNoLabel.text = "学号：\(user?.userInfo?.userId ?? "-")"
        updateData(user?.userInfo)
        
        let result = (user == nil)
        messageButton.isHidden = result
        messageBade.isHidden = result
        
        let img:UIImage? = .init(systemName: "person.crop.circle")?.sd_resizedImage(with: CGSize(width: 66, height: 66), scaleMode: .aspectFill)?.withTintColor(rgba(188, 188, 188, 0.66), renderingMode: .alwaysOriginal).wp.roundCorner(33)
        userHeder.sd_setImage(with:URL(string: user?.userInfo?.profilePhoto ?? ""), placeholderImage: img)
    }
    
    func updateData(_ userInfo:WPUserInfo?) -> Void {
        if let label:UILabel = studyTimeView.viewWithTag(100) as? UILabel {
            let creditDuration:Int = userInfo?.creditDuration ?? 0
            if userInfo != nil {
                let  hour = creditDuration / 60 / 60
                let  min = (creditDuration - hour * 3600) % 60
                label.attributedText = getLongTime(hour: hour, min:min)
                
            } else {
                label.attributedText = .init(string: "-")
            }
        }
        
        if let label:UILabel = creditFeiView.viewWithTag(100) as? UILabel {
            if userInfo == nil {
                label.text = "-"
            } else {
                label.text = "\(userInfo?.credit ?? 0)"
            }
        }
    }
}
