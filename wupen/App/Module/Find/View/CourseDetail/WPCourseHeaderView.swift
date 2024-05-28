//
//  WPCourseHeaderView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/7.
//

import UIKit

class WPCourseHeaderView: UICollectionReusableView {
    class func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView  {
        if kind == UICollectionView.elementKindSectionHeader  {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            if let headerView:WPCourseHeaderView = reusableView as? WPCourseHeaderView {
                 debugPrint(headerView)
            }
            return reusableView
        } else {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            return reusableView
        }
    }
    
    let statusBarHeight:CGFloat = kStatusBarHeight // 状态栏高度
    let playerViewHeight:CGFloat = 212.0 // 播放器高度
    let zsHeight:CGFloat = 148.0 // 知识栏高度
    let kcHeight:CGFloat = 65.0 // 课程推荐标题高度
    let infoHeight:CGFloat = 71.0 // 信息栏高度
    var masHeight:CGFloat = 44.0 // 课程标题详细高度 spaTo：17 最低  44.
    
    
    public var updateHeigtBlock:((_ height:CGFloat)->Void)?
    
    deinit {
        debugPrint("---init---", self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        makeConstraints()
    }
    
    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        return contentView
    }()
    
    lazy var player: WPPlayer = {
        var player: WPPlayer = WPPlayer()
        player.backgroundColor = .clear
        player.updateIndexBlock = .some({[weak self] index in
            guard let weakSelf = self else {return}
            weakSelf.knowledgeView.currentIndex = index
        })
        contentView.addSubview(player)
        return player
    }()
    
    lazy var titleLabel: YYLabel = {
        var titleLabel: YYLabel = YYLabel()
        titleLabel.numberOfLines = 0
        titleLabel.isUserInteractionEnabled = true
        titleLabel.preferredMaxLayoutWidth = WPScreenWidth - 32
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    lazy var moreImageView: UIImageView = {//显示简介按键
        let size = CGSize(width: 40, height: 21)
        var image:UIImage = UIImage.wp.createColorImage(rgba(255, 234, 192, 1), size:size).wp.roundCorner(8)
        if let arrow = UIImage(named: "更多")?.wp.tintImage(rgba(241, 116, 0, 1)) {
            image = image.addImagePoint(logoImg: arrow, logoPoint: CGPoint(x: 28, y: 3))
        }
        
        if let img = image.addTitle(title: "简介", font: .systemFont(ofSize: 11), point: .init(x: 6, y: 3), textColor: rgba(241, 116, 0, 1)) {
            image = img
        }
        var moreImageView: UIImageView = UIImageView(image: image)
        moreImageView.isUserInteractionEnabled = true
        moreImageView.layer.cornerRadius = 10
        moreImageView.layer.masksToBounds = true
        moreImageView.contentMode = .scaleAspectFill
        
        let tap:UITapGestureRecognizer = .init()
        tap.rx.event.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self,let couser:WPCouserDetailModel = weakSelf.couserDetail else { return  }
            debugPrint("简介")
            let courseDetailView:WPCourseDetailView = WPCourseDetailView()
            courseDetailView.show(couser)
            
        }).disposed(by: disposeBag)
        moreImageView.addGestureRecognizer(tap)
        moreImageView.size = size
        return moreImageView
    }()
    
    lazy var bottomView: UIView = {
        var bottomView: UIView =  UIView()
        bottomView.backgroundColor = rgba(245, 245, 245)
        var textLabel: UILabel = UILabel()
        textLabel.text = "课程推荐"
        textLabel.textColor = rgba(51, 51, 51, 1)
        textLabel.font = .boldSystemFont(ofSize: 18)
        bottomView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(24)
        }
        contentView.addSubview(bottomView)
        return bottomView
    }()
    
    lazy var knowledgeView: WPKnowledgeView = {
        var knowledgeView: WPKnowledgeView = WPKnowledgeView()
        contentView.addSubview(knowledgeView)
        return knowledgeView
    }()
    
    lazy var headeInfoView: WPCourseHeadeInfoView = {
        var headeInfoView: WPCourseHeadeInfoView = WPCourseHeadeInfoView()
        contentView.addSubview(headeInfoView)
        return headeInfoView
    }()
    
    var couserDetail:WPCouserDetailModel?{
        didSet {
            knowledgeView.couserDetail = couserDetail
            headeInfoView.couserDetail = couserDetail
            self.player.videos = couserDetail?.videos
            if WPLanguage.chinessLanguage() {
                updateLabel(couserDetail?.lecture?.chineseTitle ?? "-")
            } else {
                updateLabel(couserDetail?.lecture?.englishTitle ?? "-")
            }
            
            // 点击知识区播放视屏
            couserDetail?.currentDidIndexBlock = .some({[weak self] video in
                guard let weakSelf = self else { return  }
                weakSelf.playerVideo(video)
            })
        
            // 自动播放第一个视频
            if let video = couserDetail?.videos.first {
                video.playerURL = video.video?.video
                if video.playerURL == nil {
                    video.playerURL = video.video?.audio
                }
                if WPPlayerManager.default.video?.playerURL == video.playerURL && WPPlayerManager.default.video != nil {  return }
                playerVideo(video)
            }
        }
    }
}

extension WPCourseHeaderView {
    func playerVideo(_ video:WPLectureVideosModel) -> Void {
        self.player.model = video
        addPlayEndBlock(video)
    }
    
    func addPlayEndBlock(_ video:WPLectureVideosModel) -> Void {// 播放结束
        self.player.playEndBlock = .some({[weak self] video in
            guard let weakSelf = self else { return  }
            video.playEnd = true
            if let videos = weakSelf.couserDetail?.videos {
                let index = videos.firstIndex { s in
                    return video.video?.id == s.video?.id
                }

                // 自动播放下一个视频
                guard let i = index, (i + 1) < videos.count else { return  }
                let nextIndex:Int = i + 1
                let video = videos[nextIndex]
                weakSelf.playerVideo(video)
                weakSelf.knowledgeView.currentIndex = nextIndex
            }
        })
    }
}

extension WPCourseHeaderView {
    func updateLabel(_ text:String) -> Void {

        let content:UIImageView = self.moreImageView
        let color = rgba(51, 51, 51, 1)
        let font = UIFont.systemFont(ofSize: 18)
        let size = CGSize(width: 40, height: 21)
        let img:NSMutableAttributedString = NSMutableAttributedString.yy_attachmentString(withContent: content, contentMode: UIView.ContentMode.scaleAspectFill, attachmentSize: size, alignTo: font, alignment: YYTextVerticalAlignment.center)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.append(img)
        attributedString.yy_font = font
        attributedString.yy_color = color
   
        titleLabel.attributedText = attributedString
        
        let sizeX = CGSize(width: WPScreenWidth - 32, height: CGFloat.greatestFiniteMagnitude)
        let container = YYTextContainer.init(size: sizeX)
        let loayout = YYTextLayout(container: container, text: attributedString)
        titleLabel.textLayout = loayout
        titleLabel.sizeToFit()
        
        let height = statusBarHeight + playerViewHeight + zsHeight + kcHeight + infoHeight + titleLabel.height + 17.0
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {[weak self]in
            self?.updateHeigtBlock?(height)
        }
    }
}

extension WPCourseHeaderView {
    func setup (){
        self.backgroundColor = .black
       
    }
    
    func makeConstraints() -> Void {
        contentView.snp.makeConstraints { make in
            make.left.width.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
        
        player.snp.makeConstraints { make in
            make.left.width.top.equalToSuperview()
            make.height.equalTo(playerViewHeight)
        }
        
        titleLabel.frame = .init(x: 16, y: playerViewHeight+17, width: WPScreenWidth - 32, height: 28)
        
        headeInfoView.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(infoHeight)
        }
        
        knowledgeView.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalTo(headeInfoView.snp.bottom)
            make.height.equalTo(zsHeight)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(knowledgeView.snp.bottom)
            make.height.equalTo(kcHeight)
        }
        
        updateLabel("")
    }
}


 


