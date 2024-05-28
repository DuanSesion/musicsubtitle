//
//  WPSu.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

// 视频播放器与字幕管理 // 解析 SRT 字幕文件
class WPSubtitleManager:NSObject {
    var player: AVPlayer?
    var subtitles: Subtitles?
    var currentSubtitleIndex: Int = 0
    var updateSubtitleBlock:((_ text:String)->Void)?
    var timeObserverToken: Any?
    
    var updateProgressBlock:((_ currentTime:Float, _ duration:Float, _ progress:Float)->Void)?
    
    init(player: AVPlayer, withSRTFile fileURL: URL? = nil,updateBlock:@escaping(_ text:String)->Void) {
        super.init()
        self.player = player
        self.updateSubtitleBlock = updateBlock
        self.srtURL = fileURL
        // 监听播放器当前时间
        addProgressObserver()
    }
    
    ////本地字幕文件
    var srtURL:URL?{
        didSet {
            if let url = srtURL {//本地字幕文件
                currentSubtitleIndex = 0
                if let subtitles = try? Subtitles.init(fileURL: url, encoding: .unicode) {
                    self.subtitles = subtitles
                    
                } else {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        }
    }
    
    func reset() -> Void {
        currentSubtitleIndex = 0
    }
    
    // 销毁时间观察者
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            self.player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func getCurrentSubtitle(at videoTime: CMTime) -> Subtitles.Cue? {// 查找当前时间点对应的字幕
        if let cues = self.subtitles?.cues{
            for cue in cues[currentSubtitleIndex...] {

//                debugPrint("3=====>", cue.endTime.timeInSeconds - cue.startTime.timeInSeconds)
                
                if  videoTime.seconds >= cue.startTime.timeInSeconds && videoTime.seconds < cue.endTime.timeInSeconds  {
                    debugPrint("字幕====================================================> ",cue)
                    return cue
                }
            }
        }
        return nil
    }
    
    func updateSubtitleView(with text: String) {
        // 更新显示字幕的视图内容
        DispatchQueue.main.async {[weak self] in
            self?.updateSubtitleBlock?(text)
        }
    }
    
    func updateProgressView(_ currentTime:Float,  _ duration:Float, _ progress:Float) {
        // 更新显示字幕的视图内容
        DispatchQueue.main.async {[weak self] in
            self?.updateProgressBlock?(currentTime, duration, progress)
            
//            debugPrint("当前播放进度: ",progress)
//            debugPrint("当前播放时间: ",currentTime)
//            debugPrint("视频时长: ",duration)
        }
    }
    
    func addProgressObserver() {// 监听播放器当前时间 - 每秒更新一次播放进度

        let timeInterval:TimeInterval = 0.5
        debugPrint(Int64(timeInterval * Double(CMTimeScale(NSEC_PER_SEC))))
      
        let TimeMake = CMTimeMake(value: Int64(timeInterval * Double(CMTimeScale(NSEC_PER_SEC))), timescale: CMTimeScale(NSEC_PER_SEC))
        let timeObserverToken = player?.addPeriodicTimeObserver(forInterval: TimeMake, queue: DispatchQueue.main) { [weak self] (time) in
                guard let weakSelf = self else { return }
            debugPrint("====>",Date.jk.currentDate)
            
            
                if weakSelf.player?.currentItem?.status == .readyToPlay {
                    let currentTime = Float(CMTimeGetSeconds(time))
                    let duration = Float(weakSelf.player?.currentItem?.duration.seconds ?? 0.0)
                    // 更新滑块进度
                    let progress = currentTime / duration
                    weakSelf.updateProgressView(currentTime, duration, progress)
                    
                    
                    if let cue: Subtitles.Cue = weakSelf.getCurrentSubtitle(at: time) {// 更新 UI 显示当前字幕
                        weakSelf.updateSubtitleView(with: cue.text)
                        weakSelf.currentSubtitleIndex += 1
                    }
                    
//                    self.progressSlider?.setValue(currentTime / duration, animated: true)
                }
            }

        // 记录timeObserverToken，以便在适当的时候（如视图消失时）可以移除观察者
        self.timeObserverToken = timeObserverToken
    }

}
