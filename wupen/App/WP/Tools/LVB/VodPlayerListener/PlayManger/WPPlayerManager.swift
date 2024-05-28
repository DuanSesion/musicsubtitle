//
//  WPPlayerManager.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/8.
//

import UIKit

class WPPlayerManager: NSObject {
    public static let `default` = WPPlayerManager()
    private var sessionVolumObserve: NSKeyValueObservation?
    override init() {
        super.init()
        //addVolumObserve()
    }
    
    var playerURL:String?
    public var updateCurrentIndexBlock:(()->Void)?
    public var playEndBlock:((_ video:WPLectureVideosModel)->Void)?
    
    // MARK: 播放器
    var video:WPLectureVideosModel?{
        didSet {
            oldValue?.pause()
            self.updateCurrentIndexBlock?()
        }
    }
 
    func resume() {
        video?.play()
    }
    
    func pause() {
        video?.pause()
    }
    
    func stop() -> Void {
        removeObserve ()
        video?.stop()
        
        playerURL = nil
        video = nil
    }
}

extension WPPlayerManager {
    private func addVolumObserve() -> Void {
        self.sessionVolumObserve?.invalidate()
        self.sessionVolumObserve = nil
        
        let session = AVAudioSession.sharedInstance()
        let sessionVolumObserve = session.observe(\.outputVolume, options: [.new]) { [weak self] sesion, value in
            guard let weakSelf = self  else { return  }
            if let volumeNum = value.newValue {
                let volume = volumeNum
                weakSelf.video?.playVolumeChangeBlock?(volume)
                debugPrint("音量变化===》",volume)
            }
        }
        self.sessionVolumObserve = sessionVolumObserve
    }
    
    public func getOutputVolume()->Float{
        return AVAudioSession.sharedInstance().outputVolume
    }
}

extension WPPlayerManager {
    func removeObserve () -> Void {
        video?.updateProgressBlock = nil
        video?.playEndBlock = nil
        video?.playVolumeChangeBlock = nil
    }
}
