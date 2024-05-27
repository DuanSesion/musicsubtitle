//
//  ViewController.swift
//  player
//
//  Created by 栾昊辰 on 2024/5/23.
//

import UIKit
import SwiftSubtitles
import AVFAudio
import AVFoundation
import SnapKit
import MusicKit
import MediaPlayer

class ViewController: UIViewController {
    private static let mediaSelectionKey = "availableMediaCharacteristicsWithMediaSelectionOptions"
    private var playerView:PlayerView?
    private var timeObserverToken:Any?
    private var subtitles:Subtitles!
    private var currentSubtitleIndex:Int = 0
    let dispatch_queue:dispatch_queue_t = .init(label: "play.progress.subtitles.cue")
    private var currentItemObserver:NSKeyValueObservation?
    
    
    lazy var label: SubtitleLabel = {
        var label: SubtitleLabel = SubtitleLabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .red
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        view.addSubview(label)
        return label
    }()
    
    lazy var oldLabel: UILabel = {
        var label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = 1.5
        label.clipsToBounds = true
        view.addSubview(label)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        view.backgroundColor = .black
//        MPNowPlayingInfoCenter.default().re
        
        
        let swSize = UIScreen.main.bounds.size
        let playerView:PlayerView = .init(frame: CGRect(x:( swSize.width - 200)/2, y: 88, width: 200, height: 200))
        playerView.playerLayer.videoGravity = .resizeAspectFill
        playerView.contentMode = .scaleAspectFill
        playerView.layer.cornerRadius = 100
        playerView.clipsToBounds = true
        playerView.backgroundColor = .red
        
        view.addSubview(playerView)
        self.playerView = playerView
        
        guard let url = Bundle.main.path(forResource: "Charlie Puth-Look At Me Now", ofType: "mp3") else { return  }
        let avsset = AVURLAsset(url: URL(fileURLWithPath: url))
        let playerItem = AVPlayerItem(asset: avsset, automaticallyLoadedAssetKeys: [ViewController.mediaSelectionKey])
        
        let avsset1 = AVURLAsset(url: URL(fileURLWithPath: url))
        let playerItem1 = AVPlayerItem(asset: avsset1, automaticallyLoadedAssetKeys: [ViewController.mediaSelectionKey])
        
        
        let player = AVQueuePlayer(items: [playerItem,playerItem1])
        playerView.playerLayer.player = player
        
        for track in playerItem.tracks {
            if track.assetTrack?.mediaType == .video {
                track.isEnabled = true
            }
        }
        
        playerItem.preferredForwardBufferDuration = 5
        player.automaticallyWaitsToMinimizeStalling = false
        
        player.preventsDisplaySleepDuringVideoPlayback = true
        player.automaticallyWaitsToMinimizeStalling = true
        player.allowsExternalPlayback = true
        
        player.play()
//        addObserverPlayerItemDidReachEnd(player)
        observeCurrentItemChanges(player)
        
        
        guard let url = Bundle.main.path(forResource: "5月23日", ofType: "srt") else { return  }
        guard let model:Subtitles = try? Subtitles.init(fileURL: URL(fileURLWithPath: url), encoding: .ascii) else { return  }
        self.subtitles = model
        addProgressObserver(player)
        
        
        oldLabel.snp.makeConstraints { make in
            make.edges.equalTo(label)
        }
        
        label.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().offset(-40)
            make.top.equalTo(playerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        let image = getImageFrom(asset: avsset, at: .zero, size: .zero)
        playerView.layer.contents = image?.cgImage
        addRotationAnimation(to: playerView.layer)
         
        setNowPlayingMetadata()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reset()
        playerView?.playerLayer.player?.seek(to: CMTime.zero, toleranceBefore: .zero, toleranceAfter: .zero)
        playerView?.playerLayer.player?.play()
    }
    
    func setNowPlayingMetadata( ) {
        guard let url = Bundle.main.path(forResource: "Charlie Puth-Look At Me Now", ofType: "mp3"),
              let asset = playerView?.playerLayer.player?.currentItem?.asset,
              let currentItem = playerView?.playerLayer.player?.currentItem,
              let image = getImageFrom(asset: asset, at: .zero, size: .zero),
              let player:AVQueuePlayer = playerView?.playerLayer.player as? AVQueuePlayer  else { return  }
        
        
        let musicInfo = MPMediaItemArtwork.init(boundsSize: image.size) { size in image }
//        let nowPlayingInfo = [
//            MPMediaItemPropertyArtist : "Artist Name",
//            MPMediaItemPropertyTitle : "Song Title",
//            MPMediaItemPropertyPlaybackDuration : 230.0,
//            MPMediaItemPropertyArtwork : musicInfo
//        ] as [String : Any]
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
      

//        let playBackInfo = [
//            MPNowPlayingInfoPropertyElapsedPlaybackTime : 150.0
//        ]
//        MPNowPlayingInfoCenter.default().nowPlayingInfo = playBackInfo
  

        let playPauseButton = MPRemoteCommandCenter.shared().togglePlayPauseCommand
        playPauseButton.addTarget { event in
            debugPrint(player.timeControlStatus == .playing, player.timeControlStatus == .paused, "暂停和播放")
            
            if (event.command == playPauseButton) {
                if (player.timeControlStatus == .paused) {
                    player.play()
                } else {
                    player.pause()
                }
                return .success
            }
            return .commandFailed
        }
        
        let nextTrackButton = MPRemoteCommandCenter.shared().nextTrackCommand
        nextTrackButton.addTarget { event in
            debugPrint(player.status, "下一首")
            
            if (event.command == nextTrackButton) {
                player.advanceToNextItem()
                return .success
            }
            return .commandFailed
        }
        
        let previousTrackButton = MPRemoteCommandCenter.shared().previousTrackCommand
        previousTrackButton.addTarget { event in
            debugPrint(player.status, "上一首")
            if (event.command == previousTrackButton) {
//                player.advanceToNextItem()
                return .success
            }
            return .commandFailed
        }

 
        let remoteCommandController =  MPRemoteCommandCenter.shared()
        remoteCommandController.previousTrackCommand.isEnabled = true
        remoteCommandController.nextTrackCommand.isEnabled = true
        remoteCommandController.seekForwardCommand.isEnabled = true
//        remoteCommandController.seekForwardCommand.preferredIntervals = [15, 30, 60]
        remoteCommandController.seekBackwardCommand.isEnabled = true
//        remoteCommandController.seekBackwardCommand.preferredIntervals = [15, 30, 60]
     

 
        
        var languageOptionGroups: [MPNowPlayingInfoLanguageOptionGroup] = []
        var currentLanguageOptions: [MPNowPlayingInfoLanguageOption] = []

        if asset.statusOfValue(forKey: ViewController.mediaSelectionKey, error: nil) == .loaded {
            
            // Examine each media selection group.
            
            for mediaCharacteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
                guard mediaCharacteristic == .audible || mediaCharacteristic == .legible,
                    let mediaSelectionGroup = asset.mediaSelectionGroup(forMediaCharacteristic: mediaCharacteristic) else { continue }
                
                // Make a corresponding language option group.
                
                let languageOptionGroup = mediaSelectionGroup.makeNowPlayingInfoLanguageOptionGroup()
                languageOptionGroups.append(languageOptionGroup)
                
                // If the media selection group has a current selection,
                // create a corresponding language option.
                
                if let selectedMediaOption = currentItem.currentMediaSelection.selectedMediaOption(in: mediaSelectionGroup),
                    let currentLanguageOption = selectedMediaOption.makeNowPlayingInfoLanguageOption() {
                    currentLanguageOptions.append(currentLanguageOption)
                }
            }
        }
        
       
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
  
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = URL(fileURLWithPath: url)
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.audio.rawValue
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = false
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Charlie Puth-Look At Me Now"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "artist"
        nowPlayingInfo[MPMediaItemPropertyArtwork] = musicInfo
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = "Artist"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "albumTitle"
        
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = 180.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] =  0.0
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyCurrentLanguageOptions] = languageOptionGroups
        nowPlayingInfo[MPNowPlayingInfoPropertyAvailableLanguageOptions] = currentLanguageOptions
        
        debugPrint(nowPlayingInfo)
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
   
}

extension ViewController {
    func addProgressObserver(_ player:AVPlayer) {// 监听播放器当前时间 - 每秒更新0.1s/次播放进度 - DispatchQueue.main
        let timeInterval:TimeInterval = 0.1
        let TimeMake = CMTimeMake(value: Int64(timeInterval * Double(CMTimeScale(NSEC_PER_SEC))), timescale: CMTimeScale(NSEC_PER_SEC))
        let timeObserverToken = player.addPeriodicTimeObserver(forInterval: TimeMake, queue: dispatch_queue) { [weak self] (time) in
                guard let weakSelf = self else { return }
            
                if player.currentItem?.status == .readyToPlay {
                    let currentTime = Float(CMTimeGetSeconds(time))
                    let duration = Float(player.currentItem?.duration.seconds ?? 0.0)
                    // 更新滑块进度
                    let progress = currentTime / duration
                    weakSelf.updateProgressView(currentTime, duration, progress)
                    
                    if let cue: Subtitles.Cue = weakSelf.getCurrentSubtitle(at: time) {// 更新 UI 显示当前字幕
                        weakSelf.currentSubtitleIndex += 1
                        
                        let animationDuration = cue.endTime.timeInSeconds - cue.startTime.timeInSeconds
                        weakSelf.updateSubtitleView(with: cue.text, animationDuration: animationDuration)
                    }
                }
            }
        // 记录timeObserverToken，以便在适当的时候（如视图消失时）可以移除观察者
        self.timeObserverToken = timeObserverToken
    }
    
    func updateProgressView(_ currentTime:Float,  _ duration:Float, _ progress:Float) {
        
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo:[String: Any]  = nowPlayingInfoCenter.nowPlayingInfo ?? [:]
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] =  currentTime
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    func getCurrentSubtitle(at videoTime: CMTime) -> Subtitles.Cue? {// 查找当前时间点对应的字幕
            let cues = self.subtitles.cues
            for cue in cues[currentSubtitleIndex...] {
                if  videoTime.seconds >= cue.startTime.timeInSeconds && videoTime.seconds < cue.endTime.timeInSeconds  {
                    return cue
                }
            }
        return nil
    }
    
    func reset() -> Void {
        currentSubtitleIndex = 0
    }
    
    func updateSubtitleView(with text: String, animationDuration:Double) {
        // 更新显示字幕的视图内容
        DispatchQueue.main.async {
            self.label.text = text
            self.animate3(animationDuration)
            
            let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
            var nowPlayingInfo:[String: Any]  = nowPlayingInfoCenter.nowPlayingInfo ?? [:]
            nowPlayingInfo[MPMediaItemPropertyArtist] = text
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        }
    }
    
    // 销毁时间观察者
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            self.playerView?.playerLayer.player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        if let queuePlayer:AVQueuePlayer = self.playerView?.playerLayer.player as? AVQueuePlayer {
            queuePlayer.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem))
        }
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        currentItemObserver?.invalidate()

    }
}


extension ViewController {
    func getImageFrom(asset: AVAsset, at time: CMTime, size: CGSize) -> UIImage? {
        debugPrint(MPMediaItemPropertyArtwork)
        
        let mediaType:AVMediaType = asset.tracks.first?.mediaType ?? .audio
        if mediaType == .audio {
            let metadata = asset.metadata
            for item in metadata {
                if item.commonKey?.rawValue == MPMediaItemPropertyArtwork {
                    if let imageData = item.value as? Data, let image = UIImage(data: imageData) {
                        return image
                    }
                }
            }
            return nil
            
        } else {
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let timeRange = CMTimeMake(value: time.value, timescale: time.timescale)
            do {
                let img = try assetImgGenerate.copyCGImage(at: timeRange, actualTime: nil)
                let image = UIImage(cgImage: img)
                return image
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }
    }
}

extension ViewController {
    
    func observeCurrentItemChanges(_ queuePlayer:AVQueuePlayer) {
        // 当前播放项目的观察者
        let currentItemObserver = queuePlayer.observe(\.currentItem, options: [.new]) { [weak self] (qPlayer, change) in
            self?.reset()
            if change.newValue  == nil {
                guard let url = Bundle.main.path(forResource: "Charlie Puth-Look At Me Now", ofType: "mp3") else { return  }
                let avsset = AVURLAsset(url: URL(fileURLWithPath: url))
                let playerItem = AVPlayerItem(asset: avsset, automaticallyLoadedAssetKeys: [ViewController.mediaSelectionKey])
                
                let avsset1 = AVURLAsset(url: URL(fileURLWithPath: url))
                let playerItem1 = AVPlayerItem(asset: avsset1, automaticallyLoadedAssetKeys: [ViewController.mediaSelectionKey])
                
                if qPlayer.canInsert(playerItem, after: nil) {
                    qPlayer.insert(playerItem, after: nil)
                }
                 
                if qPlayer.canInsert(playerItem1, after: nil) {
                    qPlayer.insert(playerItem1, after: nil)
                }
                
                queuePlayer.seek(to: CMTime.zero, toleranceBefore: .zero, toleranceAfter: .zero)
                queuePlayer.play()
                
             
            } else if let newItem = change.newValue {
                // 新的播放项目开始播放，检查是否为最后一个项目
                let newItem:AVPlayerItem = newItem!
                if newItem == queuePlayer.items().last {
                    debugPrint(queuePlayer.items())
                    
                    guard let url = Bundle.main.path(forResource: "Charlie Puth-Look At Me Now", ofType: "mp3") else { return  }
                    let avsset = AVURLAsset(url: URL(fileURLWithPath: url))
                    let playerItem = AVPlayerItem(asset: avsset, automaticallyLoadedAssetKeys: [ViewController.mediaSelectionKey])
                    if queuePlayer.canInsert(playerItem, after: nil) {
                        queuePlayer.insert(playerItem, after: nil)
                    }
                    
//                    if let firstItem = queuePlayer.items().first {
//                        // 如果是最后一个项目，当它即将结束时重新排列播放队列以实现循环
//                        DispatchQueue.main.asyncAfter(deadline: .now() + (newItem.asset.duration.seconds - queuePlayer.currentTime().seconds)) {
//                            if queuePlayer.canInsert(newItem, after: nil) {
//                                queuePlayer.insert(newItem, after: nil)
//                                queuePlayer.seek(to: CMTime.zero, toleranceBefore: .zero, toleranceAfter: .zero)
//                                queuePlayer.play()
//                            }
//                        }
//                    }
                }
            }
        }
        self.currentItemObserver = currentItemObserver
    }
        
    func addObserverPlayerItemDidReachEnd(_ player:AVPlayer) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        
        
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {  // 播放结束的处理
        reset()
 
    }
}

 
extension ViewController {
    func animate1(_ animationDuration:Double) -> Void {
        let size = self.label.bounds.size
        
        let colorAlpha = UIView()
        colorAlpha.backgroundColor = .white
        colorAlpha.layer.cornerRadius = 0.5
        colorAlpha.clipsToBounds = true
        colorAlpha.frame = .init(origin: .zero, size: CGSize(width: 0, height: size.height))
        self.label.layer.mask = colorAlpha.layer
        
        UIView.animate(withDuration: animationDuration) {
            colorAlpha.frame = .init(origin: .zero, size: CGSize(width: size.width, height: size.height))
            self.label.layer.mask = colorAlpha.layer
        }
    }
    
    func animate2(_ animationDuration:Double) -> Void {
        self.label.textColor = .clear

        
        let colorAlpha = UILabel()
        colorAlpha.text = self.label.text
        colorAlpha.font = .boldSystemFont(ofSize: 20)
        colorAlpha.textAlignment = .center
        colorAlpha.adjustsFontSizeToFitWidth = true
        colorAlpha.textColor = .white
        colorAlpha.layer.cornerRadius = 0.5
        colorAlpha.clipsToBounds = true
        
        colorAlpha.sizeToFit()
        var size = colorAlpha.bounds.size
        let maxWidth = self.view.bounds.size.width - 40
        if size.width > (maxWidth) {
            size.width = maxWidth
        }
        
        colorAlpha.frame = .init(origin: .zero, size: CGSize(width: 0, height: size.height))
        self.label.layer.mask = colorAlpha.layer
        
        UIView.animate(withDuration: animationDuration) {
            colorAlpha.frame = .init(origin: .zero, size: CGSize(width: size.width, height: size.height))
            self.label.layer.mask = colorAlpha.layer
        }
    }
    
    func animate3(_ animationDuration:Double) -> Void {
        self.label.textColor = .clear
        self.oldLabel.text =  self.label.text

        let colorAlpha = UILabel()
        colorAlpha.text = self.label.text
        colorAlpha.font = .boldSystemFont(ofSize: 20)
        colorAlpha.textAlignment = .center
        colorAlpha.adjustsFontSizeToFitWidth = true
        colorAlpha.textColor = .white
        colorAlpha.layer.cornerRadius = 0.5
        colorAlpha.clipsToBounds = true
        
        colorAlpha.sizeToFit()
        var size = colorAlpha.bounds.size
        let maxWidth = self.view.bounds.size.width - 40
        if size.width > (maxWidth) {
            size.width = maxWidth
        }
        
        colorAlpha.frame = .init(origin: .zero, size: CGSize(width: 0, height: size.height))
        self.label.layer.mask = colorAlpha.layer
        
        UIView.animate(withDuration: animationDuration) {
            colorAlpha.frame = .init(origin: .zero, size: CGSize(width: size.width, height: size.height))
            self.label.layer.mask = colorAlpha.layer
        }
    }
}

extension ViewController {
    private func addRotationAnimation(to layer: CALayer) {
        layer.anchorPoint = .init(x: 0.5, y: 0.5)
        // 创建一个旋转动画
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0.0 // 起始角度
        rotationAnimation.toValue = CGFloat.pi * 2 // 结束角度，即旋转360度
        rotationAnimation.duration = 8.0 // 动画持续时间
        rotationAnimation.repeatCount = .greatestFiniteMagnitude // 无限重复
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear) // 线性插值
        
        // 添加动画到layer
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}


