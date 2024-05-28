//
//  WPLivePushCameraController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/23.
//

import UIKit

class WPLivePushCameraController: UIViewController {
    
    private var streamId:String!
    private var liveMode:V2TXLiveMode!
    private var quality:V2TXLiveAudioQuality!
    private var livePusher:V2TXLivePusher!
 
    
    init(streamId:String,isRTCPush:Bool=false,quality:V2TXLiveAudioQuality=V2TXLiveAudioQuality.default) {
        super.init(nibName: nil, bundle: nil)
        self.streamId = streamId
        self.quality  = quality
        self.liveMode = isRTCPush ? V2TXLiveMode.RTC : V2TXLiveMode.RTMP
        self.livePusher = V2TXLivePusher.init(liveMode: self.liveMode)
        self.livePusher.setObserver(self)
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
    
    deinit {
        stopLive()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLive()
    }
}

extension WPLivePushCameraController {
    
    func startLive() -> Void {
        if self.livePusher.isPushing() == 0 {
            self.livePusher.setRenderMirror(.auto)
            
            let videoEncoderParam = V2TXLiveVideoEncoderParam.init(.resolution1920x1080)
            self.livePusher.setVideoQuality(videoEncoderParam)
            self.livePusher.setRenderView(self.view)
            self.livePusher.setAudioQuality(self.quality)
            
            self.livePusher.startMicrophone()
            self.livePusher.startCamera(false)
            
            var url = URLUtils.generateRtmpPushUrl(self.streamId)
            if (self.liveMode == V2TXLiveMode.RTC) {
                url = URLUtils.generateTRTCPushUrl(self.streamId)
            }
            
            debugPrint("=========> ", url, URLUtils.generateRtmpPlayUrl(self.streamId))
            
            let code = self.livePusher.startPush(url)
            if code != V2TXLiveCode.TXLIVE_OK {
                self.livePusher.stopCamera()
                self.livePusher.stopMicrophone()
            }
        }
    }
    
    func stopLive() -> Void {
        self.livePusher.stopCamera()
        self.livePusher.stopMicrophone()
        self.livePusher.stopPush()
    }
}

extension WPLivePushCameraController:V2TXLivePusherObserver {
    
    func onError(_ code: V2TXLiveCode, message msg: String, extraInfo: [AnyHashable : Any]) {
         
    }
    
    func onMicrophoneVolumeUpdate(_ volume: Int) {
         
    }
    
    func onPushStatusUpdate(_ status: V2TXLivePushStatus, message msg: String, extraInfo: [AnyHashable : Any]) {
         
    }
}


