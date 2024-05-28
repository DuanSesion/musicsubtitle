//
//  WPLiveDetailModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/15.
//

import UIKit

class WPLiveDetailModel: Convertible {
    required init() { }
    var internatMap:WPLiveMap?
    
    var id:String?
    var userId:String?
    var username:String?
    var userAvatar:String?
    var name:String?
    var coverUrl:String?
    var description:String?
    var startTime:String?
    var endTime:String?
    var countSubscribe:Int = 0 // 预约人数
    var recordUrl:String?
    var status:Int = 0 //状态0未开播，1字幕提取中，2字幕已提取，3字幕已翻译
    var isLive:Bool = false
}

extension WPLiveDetailModel {
    func checkUpdateState()->Void {
        guard let startTimeS = startTime, let endTimeS = endTime else { return }
        let now:Date = Date.chinaDate()
        let startTimeDate:Date = Date.chinaDate(dateString: startTimeS)
        let endTimeDate:Date =  Date.chinaDate(dateString: endTimeS)
        
        let minutes1:Int = now.jk.numberOfMinutes(from: startTimeDate) ?? 0
        let minutes2:Int = now.jk.numberOfMinutes(from: endTimeDate) ?? 0
        if minutes1 >= 0 && minutes2 < 0 {
            self.isLive = true
        } else {
            self.isLive = false
        }
        
        if minutes1 < 0 { // 未开始
            self.status = 0
            
        } else if minutes2 >= 0 { // 结束
            self.status = 1
        }
    }
}

