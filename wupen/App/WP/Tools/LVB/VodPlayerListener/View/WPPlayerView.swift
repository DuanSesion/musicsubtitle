//
//  WPWPPlayerView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit
import AVFoundation
import AVFAudio
import AVKit

class WPPlayerView: UIView {
    //MARK: 字幕管理器
//    private var subtitleManager:WPSubtitleManager?
    //MARK: 视频播放
    private var playerLayer:AVPlayerLayer?
    private var fullScreenController: WPFullScreenLeftController?
    private var animationTransitioning: WPAnimationTransitioning?
    
    private var currentTime:Int = 0
    private var totalTime:Double = 0
    private var autoTime:Bool = true
    
    public var didSelectedBlock:((_ video:WPLectureVideosModel)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.classForCoder()
    }
    
    lazy var contentView: WPPlayerContentView = {
        var contentView: WPPlayerContentView = WPPlayerContentView(frame: .zero)
        contentView.contentMode = .scaleAspectFit
        contentView.isUserInteractionEnabled = true
        contentView.delegate = self
        addSubview(contentView)
        return contentView
    }()
    
    private let keyWindow: UIWindow? = {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.last
        } else {
            return UIApplication.shared.keyWindow
        }
    }()
    
    var model:WPLectureVideosModel?{
        didSet {
            contentView.model = model
        }
    }
    
    var videos:[WPLectureVideosModel]?{
        didSet {
            
        }
    }
    
    deinit {
        stop()
        NotificationCenter.default.removeObserver(self)
        
        debugPrint("====> WPPlayerView")
    }
}

extension WPPlayerView {
    func setup() -> Void {
        self.backgroundColor = .black
        self.isUserInteractionEnabled = true
        self.playerLayer = (self.layer as? AVPlayerLayer)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}

extension WPPlayerView :WPPlayerContentViewDelegate{
    func didClickNextAction(in contentView: WPPlayerContentView) {
        if let videos = self.videos {
            let index = videos.firstIndex { s in
                return self.model?.video?.id == s.video?.id
            }

            // 下一个视频
            guard let i = index, (i + 1) < videos.count else {
                self.showMessage("当前没有更多视频了")
                return
            }
            
            let nextIndex:Int = i + 1
            let video = videos[nextIndex]
            WPUmeng.um_event_course_Click_Navigation(self.model?.video, to: video.video)
            
            didSelectedBlock?(video)
        }
    }
    
    func didClickMoreAction(in contentView: WPPlayerContentView) {
        let courseVideosView:WPCourseVideosView = WPCourseVideosView()
        courseVideosView.didSelectedBlock = .some({[weak self] video in
            guard let weakSelf = self else {return }
            weakSelf.didSelectedBlock?(video)
        })
        courseVideosView.show(screenState: self.contentView.screenState, videos: self.videos ?? [])
    }
    
     // 字幕切换
    func contentView(_ contentView: WPPlayerContentView, changeLanguage fileURL: String) {
        setSRTURL(URL(fileURLWithPath: fileURL))
    }
    
    func didClickFailButton(in contentView: WPPlayerContentView) {
         
    }
    
    func didClickBackButton(in contentView: WPPlayerContentView) {
         dismiss()
    }
    
    func contentView(_ contentView: WPPlayerContentView, didClickPlayButton isPlay: Bool) {
        guard let status: AVPlayer.TimeControlStatus = self.playerLayer?.player?.timeControlStatus else { return }
        switch status {
        case .paused:
            self.playerLayer?.player?.play()
            self.contentView.playState = .playing
            
            let current:Double = self.playerLayer?.player?.currentItem?.currentTime().seconds ?? 0
            WPUmeng.um_event_course_Click_PlayPause(true,current:current)
            
            break
        case .playing:
            self.playerLayer?.player?.pause()
            self.contentView.playState = .pause
            
            let current:Double = self.playerLayer?.player?.currentItem?.currentTime().seconds ?? 0
            WPUmeng.um_event_course_Click_PlayPause(false,current:current)
            
            break
        case .waitingToPlayAtSpecifiedRate:
            self.playerLayer?.player?.play()
            self.contentView.playState = .playing
            break
        default:
            self.playerLayer?.player?.play()
            self.contentView.playState = .playing
             break
        }
    }
    
    func contentView(_ contentView: WPPlayerContentView, didClickFullButton isFull: Bool) {
        isFull ? dismiss() : presentWithOrientation(.fullRight)
        WPUmeng.um_event_course_FullscreenToggle(isFull,video: self.model)
    }
    
    func contentView(_ contentView: WPPlayerContentView, didChangeRate rate: Float) {
        WPUmeng.um_event_course_speed_change(self.playerLayer?.player?.rate ?? 1.0, rate: rate)
        self.setRate(rate)
    }
    
    func contentView(_ contentView: WPPlayerContentView, didChangeVideoGravity videoGravity: AVLayerVideoGravity) {
         
    }
    
    func contentView(_ contentView: WPPlayerContentView, sliderTouchBegan slider: WPSlider) {
        self.model?.pause()
        self.autoTime = false
    }
    
    func contentView(_ contentView: WPPlayerContentView, sliderValueChanged slider: WPSlider) {//滑动进度条
        self.autoTime = false
        
        if let duration = self.model?.video?.duration {
            self.model?.subtitleManager?.reset()
            
            if  (duration > 0)  {
                let currentDuration = Double(Float(duration) * slider.value)
                let dragedCMTime = CMTimeMake(value: Int64(ceil(currentDuration)), timescale: 1)
                self.model?.player?.seek(to: dragedCMTime, toleranceBefore: .zero, toleranceAfter: .zero)
            }
        }
    }
    
    func contentView(_ contentView: WPPlayerContentView, sliderTouchEnded slider: WPSlider) {
        self.autoTime = true
        guard (self.model?.player?.currentItem) != nil else { return }
        self.model?.player?.play()
        self.model?.subtitleManager?.reset()
    }
}

private extension WPPlayerView {
    func dismiss() {
        guard contentView.screenState == .fullScreen else { return }
        guard let controller = fullScreenController else { return }
        contentView.screenState = .animating
        controller.dismiss(animated: true, completion: {
            self.contentView.screenState = .small
        })
        UIViewController.attemptRotationToDeviceOrientation()
        fullScreenController = nil
    }

    func presentWithOrientation(_ orientation: WPAnimationTransitioning.WPAnimationOrientation) {
        guard superview != nil else { return }
        guard fullScreenController == nil else { return }
        guard contentView.screenState == .small else { return }
        guard let rootViewController = keyWindow?.rootViewController else { return }
        contentView.screenState = .animating

        animationTransitioning = WPAnimationTransitioning(playView: self, orientation: orientation)

        fullScreenController = WPFullScreenLeftController()
        fullScreenController?.transitioningDelegate = self
        fullScreenController?.modalPresentationStyle = .fullScreen
        rootViewController.present(fullScreenController!, animated: true, completion: {[weak self] in
            UIViewController.attemptRotationToDeviceOrientation()
            
            guard let weakSelf = self else {return}
            weakSelf.contentView.screenState = .fullScreen
            
            weakSelf.model?.player?.play()
            weakSelf.setRate(weakSelf.contentView.rate)
            weakSelf.playerLayer?.videoGravity = .resizeAspect
        })
    }
}


extension WPPlayerView:UIViewControllerTransitioningDelegate {
    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransitioning?.animationType = .present
        return animationTransitioning
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransitioning?.animationType = .dismiss
        return animationTransitioning
    }
}

extension WPPlayerView {
    func observeAlloc(player:AVPlayer,currentItem:AVPlayerItem) -> Void {
//        if let player = self.playerLayer?.player, let currentItem = self.playerLayer?.player?.currentItem {
            //NotificationCenter.default.addObserver(self, selector: #selector(didPlaybackEnds), name: .AVPlayerItemDidPlayToEndTime, object: currentItem)
            
            let loadedTimeRangesObserve = currentItem.observe(\.loadedTimeRanges, options: [.new]) { [weak self] _, _ in
                self?.observeLoadedTimeRangesAction()
            }
            
            let statusObserve = currentItem.observe(\.status, options: [.new]) { [weak self] (item, change) in
                self?.observeStatusAction()
                
                if let value = change.newValue {
                    print("Buffer is empty, may need to wait for more data.")
                } else {
                    print("Buffer has data, ready to play or already playing.")
                }
            }
            
            let playbackBufferEmptyObserve = currentItem.observe(\.isPlaybackBufferEmpty, options: [.new]) { [weak self] _, _ in
                self?.observePlaybackBufferEmptyAction()
            }
        
            let playbackLikelyToKeepUpObserver = currentItem.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (item, change) in
                if change.newValue ?? false {
                    print("Playback is likely to keep up, buffering is sufficient.")
                } else {
                    print("Playback may stall, buffering is insufficient.")
                    self?.contentView.playState = .pause
                }
            }
        
            let playerStatusObserve = player.observe(\.timeControlStatus, options: [.new]) { [weak self] _, _ in
                self?.playerStatusObserveAction()
            }

            self.model?.loadedTimeRangesObserve = loadedTimeRangesObserve
            self.model?.statusObserve = statusObserve
            self.model?.playbackBufferEmptyObserve = playbackBufferEmptyObserve
            self.model?.playerStatusObserve = playerStatusObserve
            self.model?.playbackLikelyToKeepUpObserver = playbackLikelyToKeepUpObserver
    }
    
    func obserInvalidate() -> Void {
//        self.playerLayer?.player?.pause()
        if let model = self.model {
            model.playerStatusObserve?.invalidate()
            model.loadedTimeRangesObserve?.invalidate()
            model.statusObserve?.invalidate()
            model.playbackBufferEmptyObserve?.invalidate()
            model.playbackLikelyToKeepUpObserver?.invalidate()
            
            model.playerStatusObserve = nil
            model.loadedTimeRangesObserve = nil
            model.statusObserve = nil
            model.playbackBufferEmptyObserve = nil
            model.playbackLikelyToKeepUpObserver = nil
    
//            self.playerLayer?.player?.replaceCurrentItem(with: nil)
        }
                                                                
        self.model?.obserInvalidate()
    }
}

extension WPPlayerView {
    func observeLoadedTimeRangesAction() {
        guard let status = self.playerLayer?.player?.currentItem?.status else { return }
        switch status {
        case .readyToPlay:
            contentView.playState = .readyToPlay
            break
        case .failed:
            contentView.playState = .failed
            break
        case .unknown:
            contentView.playState = .unknow
            break
        default:
            contentView.playState = .ended
             break
        }
    }
    
    func observeStatusAction() {

    }
    
    func observePlaybackBufferEmptyAction() {
        contentView.playState = .failed
    }
    
    func playerStatusObserveAction() {
        guard let status: AVPlayer.TimeControlStatus = self.playerLayer?.player?.timeControlStatus else { return }
        switch status {
        case .paused:
            contentView.playState = .pause
            debugPrint("暂停..")
            break
        case .playing:
            contentView.playState = .playing
            debugPrint("播放..")
            break
        case .waitingToPlayAtSpecifiedRate:
            contentView.playState = .buffering
            debugPrint("缓冲...")
            break
        default:
            contentView.playState = .ended
            debugPrint("结束..")
             break
        }
    }
}

extension WPPlayerView {
    public func getPlayer()->AVPlayer? {
        return self.playerLayer?.player
    }
 
    public func setPlayerURL(_ url:URL) -> Void {
        obserInvalidate()
        if WPPlayerManager.default.video != nil {
            WPPlayerManager.default.pause()
        }
        
        self.playerLayer?.player?.pause()
        let currentItem = AVPlayerItem.init(url:url )
        //// 例如设置为3秒
        currentItem.preferredForwardBufferDuration = 3
        
        
        let player = AVPlayer.init(playerItem: currentItem)
        self.playerLayer?.player = player
        player.automaticallyWaitsToMinimizeStalling = false
        
        self.playerLayer?.player?.rate = self.contentView.rate
        self.playerLayer?.player?.volume = 1.0
        
        self.model?.player = player
        observeAlloc(player: player, currentItem: currentItem)
        // 添加播放结束的观察者
        self.model?.addObserverPlayerItemDidReachEnd(currentItem)
        addObserverPlayerProgress(player: player)
        WPPlayerManager.default.video = self.model
        
        contentView.playState = .playing
        currentTime = 0
        totalTime = 0
        self.contentView.resetTextViews()
        self.playerLayer?.videoGravity = .resizeAspectFill
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            guard let weakSelf = self else {return}
            if let mo = weakSelf.model,
               let video = weakSelf.model?.video  {
                if mo.progress > 0 && video.duration > 0 && mo.progress < 1.0 {
                    let send = Double(video.duration) * mo.progress
                    if mo.playEnd == false {
                        weakSelf.seek(send)
                    }
                }
            }
        }
    }
     
    public func setSRTURL(_ url:URL) -> Void {
        self.model?.subtitleManager?.srtURL = url
    }
    
    // 监听播放进度
    func addObserverPlayerProgress(player: AVPlayer) -> Void {
        self.model?.subtitleManager?.removePeriodicTimeObserver()
        self.model?.subtitleManager = nil
        
        let subtitleManager:WPSubtitleManager = .init(player: player) {[weak self] text in
            guard let weakSelf = self else { return  }
            weakSelf.contentView.setCurrentSrtText(text)
        }
        addUpdateProgressBlock(subtitleManager: subtitleManager)
        self.model?.subtitleManager = subtitleManager
    }
    
    //播放进度回掉
    func addUpdateProgressBlock(subtitleManager:WPSubtitleManager) -> Void {
        subtitleManager.updateProgressBlock = .some({[weak self] currentTime, duration, progress in
            guard let weakSelf = self else { return  }
            if weakSelf.autoTime {weakSelf.model?.autoAcountTime()}
            
            weakSelf.model?.progress = CGFloat(progress)
            weakSelf.model?.updateProgressBlock?()
            
            if weakSelf.currentTime != Int(currentTime) {
                weakSelf.currentTime = Int(currentTime)
                weakSelf.contentView.setCurrentDuration(TimeInterval(currentTime))
                weakSelf.contentView.setSliderProgress(progress, animated: true)
                
            } else if Int(currentTime) == 0 {
                weakSelf.contentView.setCurrentDuration(0)
                weakSelf.contentView.setSliderProgress(0, animated: true)
            }

            if weakSelf.totalTime != Double(duration) {
                weakSelf.totalTime = Double(duration)
                weakSelf.contentView.setTotalDuration(weakSelf.totalTime)
                weakSelf.model?.video?.duration = Int(duration)
            }
        })
    }
     
     public func play() {
         self.playerLayer?.player?.play()
         contentView.playState = .readyToPlay
         WPPlayerManager.default.video = self.model
         WPPlayerManager.default.playerURL = self.model?.playerURL

         //self.playerLayer?.player?.rate = 0.1
     }
     
     public func pause() {
         self.playerLayer?.player?.pause()
         contentView.playState = .pause
     }
     
     public func stop() {
         self.playerLayer?.player?.pause()
         obserInvalidate()
         contentView.playState = .ended
         currentTime = 0
         totalTime = 0
         NotificationCenter.default.removeObserver(self)
         self.model?.stop()
     }
}

extension WPPlayerView {
    private func setRate(_ rate:Float) {
        self.playerLayer?.player?.rate = rate
    }
    
    private func seek(_ seconds:Double) {
        if let aVplayer = self.playerLayer?.player {
            let positionTime = seconds
            aVplayer.seek(to: CMTime(seconds: positionTime, preferredTimescale: 1),
                               toleranceBefore: CMTime(seconds: 0, preferredTimescale: 1),
                         toleranceAfter: CMTime(seconds: 0, preferredTimescale: 1))
        }
    }
}
