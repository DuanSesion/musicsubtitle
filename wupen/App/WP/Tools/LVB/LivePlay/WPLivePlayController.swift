//
//  WPLivePlayController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/23.
//

import UIKit
/**
 RtmpPlay,
 FlvPlay,
 HlsPlay,
 RTCPlay,
 */
enum WPLivePlayMode {
    case RtmpPlay
    case FlvPlay
    case HlsPlay
    case RTCPlay
}

class WPLivePlayController: UIViewController {
    
    private var streamId:String!
    private var livePlayMode:WPLivePlayMode!
    private var livePlayer:V2TXLivePlayer!
    
    init(streamId:String, livePlayMode:WPLivePlayMode=WPLivePlayMode.RtmpPlay) {
        super.init(nibName: nil, bundle: nil)
        self.streamId = streamId
        self.livePlayMode = livePlayMode
        self.livePlayer = V2TXLivePlayer()
        self.livePlayer.setObserver(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startPlay()
        self.livePlayer.setPlayoutVolume(100)
    }
}

extension WPLivePlayController {
    func startPlay() -> Void {
        self.livePlayer.setRenderView(self.view)
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
        case .none:
            break
        }
        
        self.livePlayer.startLivePlay(url)
    }
}

extension WPLivePlayController:V2TXLivePlayerObserver {
    func onVideoResolutionChanged(_ player: V2TXLivePlayerProtocol, width: Int, height: Int) {
         
    }
}

