//
//  WPCouserDetailModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/8.
//

import UIKit

class WPCouserDetailModel: Convertible {
    required init() { }
    var lecture:WPLectureModel?
    var videos:[WPLectureVideosModel] = []
    var internatMap:[String:[String:Any]] = [:]
    /**
     "internatMap": {
       "-1": {
         "lectureId": null,
         "title": null,
         "introduce": null,
         "language": null
       }
     */
    var proportion:Int = 0
    // 时长
    var duration:Int = 0
    // 学习进度
    var lectureDuration:CGFloat = 0
    // 详情代传
    var couser:WPCouserModel?
    // 当前播放第几个视频
    var currentIndex:Int = 0
    var currentDidIndexBlock:((_ video:WPLectureVideosModel)->Void)?
}
 
class WPLectureModel: Convertible {
    required init() { }
    var id:String?
    var chineseTitle:String?
    var englishTitle:String?
    var chineseIntroduce:String?
    var englishIntroduce:String?
    var scholar:String?
    var university:String?
    var classification:String?
    var duration:Int = 0
    var coverImage:String?
    var handoutFile:String?
    var recommendBook:String?
    var tags:String?
    var score:CGFloat = 0
    var credit:Int = 0
    var thumbNums:Int = 0
    var status:Int = 0
    var updateTime:String?
    var learnNums:Int = 0
    var top:Int = 0
    var internatStatus:Int = 0
    var internatTime:String?
}

class WPLectureVideosLanguageModel: Convertible {
    required init() { }
    var id:String = ""
    var introduce:String = ""
    var language:String = ""
    var src:String = ""
    var taskId:String = ""
    var title:String = ""
    var videoId:String = ""
    
    var key:String = ""
}

class WPLectureVideosModel: Convertible {
    required init() { }
    var video:WPVideoModel?
    var updateProgressBlock:(()->Void)?
    var playEndBlock:(()->Void)?
    var playVolumeChangeBlock:((_ volume:Float)->Void)?
    
    var isSelected:Bool = false
    var playEnd:Bool = false
    
    var duration:Int = 0
    var progress:CGFloat = 0
    var proportion:Int = 0
    
    var autoTime:CGFloat = 0
    var captionMap:[String:[String:Any]] = [:]
    var captionMapModel:[String:WPLectureVideosLanguageModel] = [:]
    
    /** captionMap
     117 =         {
           id = 5009;
           introduce = "<null>";
           language = 117;
           src = "http://58.33.91.82:12404/wupen-test/files/82216c40-0b80-11eb-ae4b-55976d9c75cb_mr.vtt";
           taskId = "<null>";
           title = "<null>";
           videoId = 137;
       }
     */
   
    //单个播放管理器
    public var loadedTimeRangesObserve: NSKeyValueObservation?
    public var playbackBufferEmptyObserve: NSKeyValueObservation?
    public var statusObserve: NSKeyValueObservation?
    public var playerStatusObserve: NSKeyValueObservation?
    public var playbackLikelyToKeepUpObserver:NSKeyValueObservation?
    //MARK: 字幕管理器
    public var subtitleManager:WPSubtitleManager?
    public var player:AVPlayer?
    public var playerURL:String?
   
    
    func obserInvalidate() -> Void {
        loadedTimeRangesObserve?.invalidate()
        playbackBufferEmptyObserve?.invalidate()
        statusObserve?.invalidate()
        playerStatusObserve?.invalidate()
        playbackLikelyToKeepUpObserver?.invalidate()
        subtitleManager?.removePeriodicTimeObserver()
        
        //self.player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate))
        loadedTimeRangesObserve = nil
        playbackBufferEmptyObserve = nil
        statusObserve = nil
        playerStatusObserve = nil
        subtitleManager = nil
        playbackLikelyToKeepUpObserver = nil
        player = nil
        playerURL = nil
     
    }
    
    func play() {
        player?.play()
    }
    
    func resume() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() -> Void {
        let currentItem = player?.currentItem
        let asset = currentItem?.asset
        
        player?.pause()
        
        currentItem?.cancelPendingSeeks()
        asset?.cancelLoading()
        player?.replaceCurrentItem(with: nil)
        
        obserInvalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

extension WPLectureVideosModel{
    func captionMapJsonToModels(){
        if captionMapModel.count == 0 && captionMap.isEmpty == false {
            for (k,v) in captionMap {
                let model = v.kj.model(WPLectureVideosLanguageModel.self)
                model.key = k
                captionMapModel[k] = model
            }
        }
    }
}

extension WPLectureVideosModel{//看课心跳
    func autoAcountTime() -> Void {
        self.autoTime += 0.5
        
        if autoTime >= 5.0  {
            debugPrint(Date.jk.currentDate)
            
            var parm:[String:Any] = [:]
            parm["videoId"] = self.video?.id
            parm["time"] = Int(CGFloat(self.video?.duration ?? 0) * (self.progress))
            Session.requestBody(LectureWatchHeartbeatURL,parameters: parm) {[weak self] res in
                guard let weakSelf = self else { return  }
                if res.jsonModel?.success == true {
                    weakSelf.autoTime = 0
                }
            }
        }
    }
}

extension WPLectureVideosModel {
    func addObserverPlayerItemDidReachEnd(_ item:AVPlayerItem) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: item)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        // 播放结束的处理
        print("播放已结束")
        self.playEnd = true
        self.playEndBlock?()
        WPPlayerManager.default.playEndBlock?(self)
        
        NotificationCenter.default.removeObserver(self)
        
    }
}

class WPVideoModel: Convertible {
    required init() { }
    var id:String?
    var lecture:String?
    var coverImage:String = ""
    var video:String = ""
    var title:String = ""
    var introduce:String = ""
    var duration:Int = 0
    var updateTime:String = ""
    var viewCount:Int = 0
    var audio:String = ""
    var asrTaskId:String?
    var subtitleTxt:String?
    /**
     "video": {
       "id": 3560,
       "lecture": 1072,
       "coverImage": null,
       "video": "http://wupen-video.oss-cn-shanghai.aliyuncs.com/course-video/Professor%20Qisheng%20Pan_Sub_041706631012000.mp4",
       "title": "Part4: The economic impact analysis (EIA)of March JPA in phase 1 and  analysis and results of phase 2,full build-out scenario 3月JPA第一阶段经济影响分析（EIA）以及 第二阶段全面扩建方案的分析和结果",
       "introduce": "The economic impact analysis (EIA)of March JPA in phase 1 and analysis and results of phase 2,full build-out scenario 3月JPA第一阶段经济影响分析（EIA）以及第二阶段全面扩建方案的分析和结果",
       "duration": 301,
       "updateTime": "2024-01-31 00:00:00",
       "viewCount": null,
       "audio": null,
       "asrTaskId": null,
       "subtitleTxt": null
     },
     */
}


