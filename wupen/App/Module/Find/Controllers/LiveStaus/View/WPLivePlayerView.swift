//
//  WPLivePlayerView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

//MARK: 直播播放器
class WPLivePlayerView: UIStackView {
    private var fullScreenController: WPFullScreenLeftController?
    private var animationTransitioning: WPLiveAnimationTransitioning?
    
    
    private var streamId:String!
    private var livePlayMode:WPLivePlayMode = .RtmpPlay
    private var livePlayer:V2TXLivePlayer? = V2TXLivePlayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        makeSubviews()
        makeConstraints()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        makeSubviews()
        makeConstraints()
    }
    
    deinit {
        stopPlay()
    }
    
    lazy var effect : UIBlurEffect = {
        var effect : UIBlurEffect = .init(style: .light)
        return effect
    }()
    
    lazy var effectView : UIVisualEffectView = {
        var effectView : UIVisualEffectView = UIVisualEffectView(effect: effect)
        effectView.alpha = 0.925
        addSubview(effectView)
        return effectView
    }()
    
    lazy var contentView: WPLivePlayerContentView = {
        var contentView: WPLivePlayerContentView = WPLivePlayerContentView(frame: .zero)
        contentView.delegate = self
        addSubview(contentView)
        return contentView
    }()
    
    lazy var animationView: WPRotateAnimationView = {
        var animationView: WPRotateAnimationView = WPRotateAnimationView()
        addSubview(animationView)
        return animationView
    }()
    
    private let keyWindow: UIWindow? = {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.last
        } else {
            return UIApplication.shared.keyWindow
        }
    }()
    
    var screenState: WPPlayerContentView.WPPlayerScreenState = .small {
        didSet {
            guard screenState != oldValue else { return }
            switch screenState {
            case .small:
                break
            case .animating:
                break
            case .fullScreen:
                break
            }
        }
    }

    var detail:WPLiveDetailModel? {
        didSet {
            if let model = detail {
                initLive(detail: model)
                contentView.detail = model
            }
        }
    }
}

extension WPLivePlayerView {
    func makeSubviews() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true

        addSubview(contentView)
        
        contentView.insertSubview(effectView, at: 0)
        contentView.addSubview(animationView)
        
        effectView.isHidden = true
    }

    func makeConstraints() -> Void {
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension WPLivePlayerView:WPLivePlayerContentDelegate {
    func livePlayerContentDidFull(in contentView: WPLivePlayerContentView) {
        presentWithOrientation(.fullRight)
    }
    
    func livePlayerContentDidBack(in contentView: WPLivePlayerContentView) {
         dismiss()
    }
}

extension WPLivePlayerView {
    public func animationLayout(safeAreaInsets: UIEdgeInsets, to screenState: WPPlayerContentView.WPPlayerScreenState) {
        contentView.animationLayout(safeAreaInsets: safeAreaInsets, to: screenState)
    }
}

private extension WPLivePlayerView {
    func dismiss() {
        guard screenState == .fullScreen else { return }
        guard let controller = fullScreenController else { return }
        screenState = .animating
        controller.dismiss(animated: true, completion: {
            self.screenState = .small
        })
        UIViewController.attemptRotationToDeviceOrientation()
        fullScreenController = nil
    }

    func presentWithOrientation(_ orientation: WPAnimationTransitioning.WPAnimationOrientation) {
        guard superview != nil else { return }
        guard fullScreenController == nil else { return }
        guard screenState == .small else { return }
        guard let rootViewController = keyWindow?.rootViewController else { return }
        screenState = .animating

        animationTransitioning = WPLiveAnimationTransitioning(playView: self.contentView, parentView: self, orientation: orientation)
        fullScreenController = WPFullScreenLeftController()
        fullScreenController?.transitioningDelegate = self
        fullScreenController?.modalPresentationStyle = .fullScreen
        rootViewController.present(fullScreenController!, animated: true, completion: {
            self.screenState = .fullScreen
            UIViewController.attemptRotationToDeviceOrientation()
        })
    }
}


extension WPLivePlayerView:UIViewControllerTransitioningDelegate {
    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransitioning?.animationType = .present
        return animationTransitioning
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransitioning?.animationType = .dismiss
        return animationTransitioning
    }
}


extension WPLivePlayerView:V2TXLivePlayerObserver {
    func onConnected(_ player: V2TXLivePlayerProtocol, extraInfo: [AnyHashable : Any]) {
         
    }
    
    func onSnapshotComplete(_ player: V2TXLivePlayerProtocol, image: UIImage?) {
        debugPrint(image as Any)
        if let img = image {
            self.contentView.image = img
        }
    }
    
    func onStatisticsUpdate(_ player: V2TXLivePlayerProtocol, statistics: V2TXLivePlayerStatistics) {
        debugPrint(player,statistics)
    }
    
    func onAudioLoading(_ player: V2TXLivePlayerProtocol, extraInfo: [AnyHashable : Any]) {
        animationView.startAnimation()
    }
    
    func onRenderVideoFrame(_ player: V2TXLivePlayerProtocol, frame videoFrame: V2TXLiveVideoFrame) {
         
    }
    
    func onVideoLoading(_ player: V2TXLivePlayerProtocol, extraInfo: [AnyHashable : Any]) {
        animationView.startAnimation()
    }
    
    func onPlayoutVolumeUpdate(_ player: V2TXLivePlayerProtocol, volume: Int) {
         
    }
    
    func onPlayoutAudioFrame(_ player: V2TXLivePlayerProtocol, frame audioFrame: V2TXLiveAudioFrame) {
         
    }
    
    func onStreamSwitched(_ player: V2TXLivePlayerProtocol, url: String, code: Int) {
         
    }
    
    func onError(_ player: V2TXLivePlayerProtocol, code: V2TXLiveCode, message msg: String, extraInfo: [AnyHashable : Any]) {
        debugPrint(msg,code)
        animationView.stopAnimation()
        if detail?.isLive == true {
            self.contentView.showMessage(msg)
            self.contentView.isShowLiveState = true
        }
    }
    
    func onVideoResolutionChanged(_ player: V2TXLivePlayerProtocol, width: Int, height: Int) {
         
    }
    
    func onWarning(_ player: V2TXLivePlayerProtocol, code: V2TXLiveCode, message msg: String, extraInfo: [AnyHashable : Any]) {
         
    }
    
    func onAudioPlaying(_ player: V2TXLivePlayerProtocol, firstPlay: Bool, extraInfo: [AnyHashable : Any]) {
        animationView.stopAnimation()
        self.contentView.isShowLiveState = false
    }
    
    func onVideoPlaying(_ player: V2TXLivePlayerProtocol, firstPlay: Bool, extraInfo: [AnyHashable : Any]) {
        animationView.stopAnimation()
        self.contentView.isShowLiveState = false
    }
    
    func onReceiveSeiMessage(_ player: V2TXLivePlayerProtocol, payloadType: Int32, data: Data) {
        animationView.stopAnimation()
        self.contentView.isShowLiveState = false
    }
    
    func onPicture(inPictureStateUpdate player: V2TXLivePlayerProtocol, state: V2TXLivePictureInPictureState, message msg: String, extraInfo: [AnyHashable : Any]) {
         debugPrint(state,msg,extraInfo)
        
        if state == .willStart || state == .didStart {
            animationView.stopAnimation()
            effectView.isHidden = true
            self.contentView.isShowLiveState = false
            
        } else {
            effectView.isHidden = false
            animationView.startAnimation()
            self.contentView.isShowLiveState = true
        }
        self.contentView.showMessage(msg)
    }
}

extension WPLivePlayerView {
    func initLive(detail:WPLiveDetailModel) -> Void {
        if detail.isLive == true {
            animationView.startAnimation()
            effectView.isHidden = false
            contentView.sd_setImage(with: .init(string: detail.coverUrl ?? ""))
        }
        
        guard let streamId = detail.id else { return  }
        self.streamId = streamId
 
        self.livePlayer?.setObserver(self)
        self.livePlayer?.setRenderView(self.contentView)
        self.livePlayer?.setPlayoutVolume(100)
        self.livePlayer?.setRenderFillMode(.fit)
        
        startPlay()
    }
    
    func startPlay() -> Void {
        self.livePlayer?.setRenderView(self.contentView)
        self.contentView.addSubview(self.contentView.topView)
        self.contentView.addSubview(self.contentView.bottomView)
        
        var url = ""
        switch (self.livePlayMode) {
        case .RtmpPlay:
            url = URLUtils.generateRtmpPlayUrl(self.streamId)
                break;
        case .FlvPlay:
            url = URLUtils.generateFlvPlayUrl(self.streamId)
                break;
        case .HlsPlay:
            url = URLUtils.generateHlsPlayUrl(self.streamId)
                break;
        case .RTCPlay:
            url = URLUtils.generateTRTCPlayUrl(self.streamId)
                break;
        }
        
        self.livePlayer?.startLivePlay(url)
    }
    
    func stopPlay() -> Void {
        if self.livePlayer?.isPlaying() == 1 {
            self.livePlayer?.stopPlay()
        }
        self.livePlayer = nil
    }
}

 
