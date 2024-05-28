//
//  WPPlayer.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

class WPPlayer: UIStackView {
    
    public var updateIndexBlock:((_ index:Int)->Void)?
    public var playEndBlock:((_ video:WPLectureVideosModel)->Void)?
   
    lazy var playerView: WPPlayerView = {
        var playerView: WPPlayerView = WPPlayerView()
        playerView.didSelectedBlock = .some({[weak self] video in
            guard let weakSelf = self else {return}
            weakSelf.model = video
            
            if let videos = weakSelf.videos {
                let index = videos.firstIndex { s in
                    return video.video?.id == s.video?.id
                }
                // 播放视频
                guard let i = index, (i) < videos.count else { return  }
                let nextIndex:Int = i
                weakSelf.updateIndexBlock?(i)
            }
        })
        addSubview(playerView)
        return playerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
         debugPrint("====> WPPlayer")
    }
    
    var model:WPLectureVideosModel?{
        didSet {
            playerView.model = model
            if let videoURL = model?.video?.video {
                self.setPlayerURL(videoURL)
                
            } else if let audioURL = model?.video?.audio {
                self.setPlayerURL(audioURL)
            }
            addPlayEndBlock()
        }
    }
    
    var videos:[WPLectureVideosModel]?{
        didSet {
            playerView.videos = videos
        }
    }
    
    func player(_ current:WPLectureVideosModel?, videos:[WPLectureVideosModel]?) -> Void {
        self.model = current
        self.videos = videos
        addPlayEndBlock()
    }
    
    func obserInvalidate() -> Void {
        playerView.obserInvalidate()
    }
    
    func addPlayEndBlock() -> Void {
        self.model?.playEndBlock = .some({[weak self] in
            guard let weakSelf = self,let model = weakSelf.model else { return  }
            weakSelf.playEndBlock?(model)
        })
    }
}

extension WPPlayer {
    func setup() -> Void {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        initSubViews()
    }
}

private extension WPPlayer {
    func initSubViews() {
        insetsLayoutMarginsFromSafeArea = false
        distribution = .fill
        alignment = .fill
        addArrangedSubview(playerView)
    }

    func makeConstraints() {}
}


extension WPPlayer {
   public func setPlayerURL(_ url:String?) -> Void {
       guard let urlStr = url , let url = URL(string: urlStr) else { return  }
       debugPrint("播地址: ", urlStr)
       //WPPlayerManager.default.weakPlayerview = self
       
       if WPPlayerManager.default.playerURL != urlStr {
           playerView.setPlayerURL(url)
           WPPlayerManager.default.playerURL = urlStr
           self.model?.playerURL = urlStr
           
       } else {
           self.model?.player?.play()
       }
   }
    
   public func setSRTURL(_ url:String?) -> Void {
       guard let urlStr = url else { return  }
       let url = URL(fileURLWithPath: urlStr)
       playerView.setSRTURL(url)
   }
    
    public func play() {
        playerView.play()
    }
    
    public func pause() {
        playerView.pause()
    }
    
    public func stop() {
        playerView.stop()
    }
}
