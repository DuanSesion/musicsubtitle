//
//  WPLiveModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPLiveLanguage: Convertible {
    required init() { }
    var language:Int = 0
    var title:String = ""
}

class WPLiveAdditionalProp: Convertible {
    required init() { }
    var liveId:String = ""
    var name:String = ""
    var subtitleUrl:String = ""
    var language:String = ""
}

class WPLiveMap: Convertible {
    required init() { }
    var additionalProp1:WPLiveAdditionalProp?
    var additionalProp2:WPLiveAdditionalProp?
    var additionalProp3:WPLiveAdditionalProp?
}

class WPLiveModel: Convertible {
    required init() { }
    var i18ns:WPLiveLanguage?
    var i18nMap:WPLiveMap?
    
    var id:String?
    var userId:String?
    var scholarName:String?
    var scholarAvatar:String?
    var title:String?
    var coverUrl:String?
    var startTime:String?
    var endTime:String?
    var countSubscribe:Int = 0 // 预约人数
    var status:Int = 0 //0未开始 1结束
    
    //** 直播中 **
    var username:String?
    var name:String?
    var description:String?
    var recordUrl:String?
    
    //** 收藏 **
    var userAvatar:String?
    
    
    // 是否正在直播 - 去上课
    var isLive:Bool = false
    // 是否预定
    var isConlllect:Bool = false
    // 收藏加载中
    var isLoading:Bool = false
    var cellHeight:CGFloat = 219.0
    
    public var updateLiveStateBlock:(()->Void)?
 
    
    func adjustCellHeight() -> Void {
        //checkUpdateState()
        
        let imgH = 92.0
        let textWidth = (WPScreenWidth - 45)/2 - 16
        var textH:CGFloat = title?.heightWithFont(font: .systemFont(ofSize: 14), fixedWidth: textWidth) ?? 0
        if  textH < 20 {
            textH = 20.0
        }
        
//        if self.status == 0 {
            let bH = 80.0
            cellHeight = imgH + bH + textH + 14.0
            
//        } else {
//            let bH = 68.0
//            cellHeight = imgH + bH + textH + 14.0
//        }
    }
    
    func checkUpdateState()->Void {
        guard let startTimeS = startTime, let endTimeS = endTime else { return }
        let now = Date.jk.currentDate.nowToChinaDate()
        let startTimeDate = Date.jk.formatterTimeStringToDate(timesString: startTimeS, formatter: "yyyy-MM-dd HH:mm:ss").nowToChinaDate()
        let endTimeDate = Date.jk.formatterTimeStringToDate(timesString: endTimeS, formatter: "yyyy-MM-dd HH:mm:ss").nowToChinaDate()
        
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
extension WPLiveModel {
    class func save(_ datas:[Any]) -> Void {
         let userID = WPUser.user()?.userInfo?.userId ?? "1"
         write(datas, to: FileManager.default.wp.collectIDsCachePath() + "/\(userID)_IDs")
    }
    
    class func read() -> [Int] {
        let userID = WPUser.user()?.userInfo?.userId ?? "1"
        return KakaJSON.read([Int].self, from: FileManager.default.wp.collectIDsCachePath() + "/\(userID)_IDs") ?? []
    }
}

extension WPLiveModel {
    //MARK: 收藏 1直播
    func userCollect(contentId:String?=nil,contentType:Int=1, _ hanld:@escaping(_ model:APIResponse)->Void) {
        if self.isLoading == false {
            var parm:[String:Any] = [:]
            parm["contentId"] = (contentId != nil) ? contentId : self.id
            parm["contentType"] = (contentType == 1) ? "live":"course"
            self.isLoading = true
            Session.requestBody(UserCollectURL,parameters: parm) {[weak self] model in
                WPLiveModel.checkCollect { liveCollectIDs in}
                self?.isLoading = false
                hanld(model)
                WPUmeng.um_event_live_button_click(true)
            }
        }
    }
    
    //MARK: 取消收藏 1直播
    func userDeCollect(contentId:String?=nil,contentType:Int=1, _ hanld:@escaping(_ model:APIResponse)->Void) {
        if self.isLoading == false {
            var parm:[String:Any] = [:]
            parm["contentId"] = (contentId != nil) ? contentId : self.id
            parm["contentType"] = (contentType == 1) ? "live":"course"
            self.isLoading = true
            Session.requestBody(UserDeCollectURL,parameters: parm) {[weak self] model in
                WPLiveModel.checkCollect { liveCollectIDs in}
                self?.isLoading = false
                hanld(model)
                WPUmeng.um_event_live_button_click()
            }
        }
    }
    
    //MARK: 查询收藏的 ID集
    class func checkCollect(contentType:Int=1, _ hanld:@escaping(_ ids:[Int])->Void) {
        let contentTypeStr = (contentType == 1) ? "live":"course"
        let url = UserCollectAllIdURL + contentTypeStr
        Session.requestBody(url) {  model in
            var lists:[Int] = []
            
            if var das:[Any] = model.jsonModel?.data as? [Any] {
                das = das.wp.trim()
                if let data:[Int] = das as? [Int]   {
                    WPLiveModel.save(data)
                    lists = data
                }
            }
            hanld(lists)
        }
    }
}

extension WPLiveModel {
    //MARK: 最近的一条直播
    class func findRecentLive(_ hanld:@escaping(_ live:WPLiveModel)->Void){
        WPLiveModel.checkCollect { ids in
            Session.requestBody(LiveNextURL) {  model in
                if let json:[String:Any] = model.jsonModel?.data as? [String:Any] {
                    let live = json.kj.model(WPLiveModel.self)
                   
                    if let id = live.id {
                        let datas:[Int] = WPLiveModel.read()
                        let sInt = Int(id) ?? -1
                        if datas.contains(sInt) == true {
                            live.isConlllect = true
                        }
                    }
                    hanld(live)
                }
            }
        }
    }
    
    //MARK: 直播详情
    class func findLiveDetail(_ id:String,_ hanld:@escaping(_ detail:WPLiveDetailModel)->Void){
        let url = LiveDetailURL + id
        Session.requestBody(url) {  model in
            if let json:[String:Any] = model.jsonModel?.data as? [String:Any] {
                let live = json.kj.model(WPLiveDetailModel.self)
                hanld(live)
            }
        }
    }
}
