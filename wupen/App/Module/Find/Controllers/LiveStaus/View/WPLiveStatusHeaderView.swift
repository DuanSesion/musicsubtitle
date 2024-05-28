//
//  WPLiveStatusHeaderView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPLiveStatusHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        makeSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
        makeSubviews()
    }
    
    deinit {
        stopPlay()
    }
    

    
    lazy var imageView: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        return imageView
    }()
    
    lazy var liveStateLabel: UILabel = {
        var liveStateLabel: UILabel = UILabel()
        liveStateLabel.text = "直播已结束"
        liveStateLabel.font = .boldSystemFont(ofSize: 16)
        liveStateLabel.textColor = .white
        addSubview(liveStateLabel)
        return liveStateLabel
    }()
    
    lazy var countLookLabel: UILabel = {
        var countLookLabel: UILabel = UILabel()
        countLookLabel.text = ""
        countLookLabel.font = .systemFont(ofSize: 16)
        addSubview(countLookLabel)
        return countLookLabel
    }()
    
    lazy var liveTitleLabel: UILabel = {
        var liveTitleLabel: UILabel = UILabel()
        liveTitleLabel.text = "直播活动名直播活动名直播活动名"
        liveTitleLabel.font = .systemFont(ofSize: 18)
        liveTitleLabel.textColor = rgba(51, 51, 51)
        self.addSubview(liveTitleLabel)
        return liveTitleLabel
    }()
    
    lazy var icon: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 8.5
        icon.backgroundColor = .lightGray
        addSubview(icon)
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        var nameLabel: UILabel = UILabel()
        nameLabel.text = "优胜教育"
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = rgba(102, 102, 102)
        self.addSubview(nameLabel)
        return nameLabel
    }()
 
    lazy var countLabel: UILabel = {
        var countLabel: UILabel = UILabel()
        countLabel.text = "1200人已预约"
        countLabel.font = .systemFont(ofSize: 11)
        countLabel.textColor = rgba(168, 171, 181, 1)
        self.addSubview(countLabel)
        return countLabel
    }()
    
    lazy var playerView: WPLivePlayerView = {
        var playerView: WPLivePlayerView = WPLivePlayerView()
        addSubview(playerView)
        return playerView
    }()
    
    var model:WPLiveModel!{
        didSet {
            updateLiveState(model)
        }
    }
    
    var detail:WPLiveDetailModel? {
        didSet {
            updateLiveDetail(detail)
        }
    }
}

extension WPLiveStatusHeaderView {
    func makeSubviews() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        let height = kNavigationBarHeight + 168 + 90
        self.frame = CGRect(origin: .zero, size: CGSize(width: WPScreenWidth, height: height))
        playerView.frame = .init(origin: .zero, size: CGSize(width: WPScreenWidth, height: height-90))
        updateCount(count: 0)
    }
    
    func makeConstraints() -> Void {
        imageView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        playerView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }

        liveTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualTo(self).offset(-16)
            make.top.equalTo(imageView.snp.bottom).offset(17)
        }
        
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(liveTitleLabel.snp.bottom).offset(10)
            make.width.height.equalTo(17)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(4)
            make.right.lessThanOrEqualTo(countLabel.snp.left)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(self).offset(-16)
        }
        

        //MARK: live
        liveStateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(kNavigationBarHeight+39)
            make.centerX.equalToSuperview()
        }
        
        countLookLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(liveStateLabel.snp.bottom).offset(2)
        }
   
    }
    
    func updateCount(count:Int) -> Void {
         let countS = "\(count)"
         let str = "累\(countS)人次观看"
        let atr:NSMutableAttributedString = .init(string: str)
        atr.yy_font = .systemFont(ofSize: 16)
        atr.yy_color = .white
        atr.yy_setColor(rgba(239, 137, 35), range: NSRange(location: 1, length: countS.count))
        countLookLabel.attributedText = atr
    }
}


extension WPLiveStatusHeaderView {
    func stopPlay() -> Void {
        playerView.stopPlay()
    }
        
    func updateLiveState(_ model:WPLiveModel) -> Void {
        updateCount(count: model.countSubscribe)
        liveTitleLabel.text = model.title
        nameLabel.text = model.scholarName ?? "-"
        countLabel.text = "\(model.countSubscribe)人已预约"
        countLookLabel.isHidden = true
        liveStateLabel.isHidden = true
//        playerView.countLabel.text = "\(model.countSubscribe)人正在观看"
//        playerView.countLabel.text = ""
//        playerView.countLabel.isHidden = true
        liveStateLabel.text = "直播已结束"
//        effectView.isHidden = false
        
        if let url = URL(string: model.coverUrl ?? "") {
            imageView.sd_setImage(with: url)
        }
        
        if model.isLive {
//            effectView.isHidden = true
       
        } else  if model.status == 0 && model.isConlllect == false {//预约 未结束
            liveStateLabel.text = "主播即将上线..."
            liveStateLabel.isHidden = false
         
        } else if model.status == 0 && model.isConlllect == true {//已预约 未结束
            liveStateLabel.text = "主播即将上线..."
            liveStateLabel.isHidden = false
            
        } else if model.status == 1 {//已结束
            liveStateLabel.isHidden = false
            countLookLabel.isHidden = false
            self.playerView.contentView.bottomView.isHidden = true
            self.playerView.effectView.isHidden = false
        }
    }
}

extension WPLiveStatusHeaderView {
    func updateLiveDetail(_ model:WPLiveDetailModel?) -> Void {
        model?.checkUpdateState()
        self.playerView.detail = model
        
        countLabel.text = "\(model?.countSubscribe ?? 0)人已预约"
        icon.sd_setImage(with: .init(string: model?.userAvatar ?? ""))
        imageView.sd_setImage(with: .init(string: model?.coverUrl ?? ""))
        liveTitleLabel.text = model?.name
        nameLabel.text = model?.username ?? "-"
    }
}
