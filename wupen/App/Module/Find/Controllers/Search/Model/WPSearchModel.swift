//
//  WPSearchModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPSearchLiveModel: Convertible {
    required init() { }
    var code:Int = 0
    var success:Bool = false
    var msg:String?
    var time:String?
    var pageNum:Int = 0
    var pageSize:Int = 0
    var totalElements:Int = 0
    var totalPage:Int = 0
    
    var data:[WPLiveModel] = []
}

class WPSearchCourseModel: Convertible {
    required init() { }
    var code:Int = 0
    var success:Bool = false
    var msg:String?
    var time:String?
    var pageNum:Int = 0
    var pageSize:Int = 0
    var totalElements:Int = 0
    var totalPage:Int = 0
    
    var data:[WPCouserModel] = []
}

class WPSearchModel: Convertible {
    required init() { }
    var total:Int = 0
    var lives:WPSearchLiveModel?
    var lectures:WPSearchCourseModel?
}

extension WPSearchModel {
    //MARK: -课程
    class func search(pageNum:Int = 1, 
                      keyword:String?=nil,
                      lectureId:String?=nil,
                      heatSort:Bool?=false,
                      timeAsc:Bool?=true,
                      classifications:[String]?=nil,
                      series:[Int]?=nil,
                      tags:[String]?=nil,
                      _ hanld:@escaping(_ model:APIResponse)->Void) {
        
        var parm:[String:Any] = [:]
        parm["pageNum"] = pageNum
        parm["pageSize"] = 10
        parm["keyword"] = keyword
        parm["heatSort"] = heatSort
        parm["timeAsc"] = timeAsc
        parm["tags"] = tags
        parm["series"] = series
        parm["classifications"] = classifications
        parm["lectureId"] = lectureId
 
        Session.requestBody(LectureListURL,parameters: parm) { model in
            if let datas:[[String:Any]] = model.jsonModel?.data as? [[String:Any]]  {
                var list:[WPCouserModel] = []
                for json in datas {
                    let model = json.kj.model(WPCouserModel.self)
                    list.append(model)
                }
                model.jsonModel?.data = list
            }
            hanld(model)
        }
    }
    
    //MARK: -直播
    class func searchLive(pageNum:Int = 1, 
                          keyword:String?=nil,
                          userId:String?=nil,
                          status:Int?=nil,
                          timeAsc:Bool=true,
                          _ hanld:@escaping(_ model:APIResponse)->Void) {
        var parm:[String:Any] = [:]
        parm["pageNum"] = pageNum
        parm["pageSize"] = 10
        parm["keyword"] = keyword
        parm["userId"] = userId
        parm["status"] = status
        parm["timeAsc"] = timeAsc
        
        WPLiveModel.checkCollect { liveCollectIDs in
            Session.requestBody(LiveCheckURL,parameters: parm) { model in
                if let datas:[[String:Any]] = model.jsonModel?.data as? [[String:Any]]  {
                    var list:[WPLiveModel] = []
                    for json in datas {
                        let model = json.kj.model(WPLiveModel.self)
                        model.adjustCellHeight()
                        
                        let idS:Int = Int("\(model.id ?? "-1")") ?? -1
                        if liveCollectIDs.contains(idS) {
                            model.isConlllect = true
                        }
                        list.append(model)
                    }
                    model.jsonModel?.data = list
                }
                hanld(model)
            }
        }
    }
}

extension WPSearchModel {
    //MARK:  领取积分
    class func getLectureReceiveCredit(_ lectureId:String?, handle:@escaping(_ mode:APIResponse)->Void) -> Void {
        guard let lectureId = lectureId else { return  }
        let url = LectureReceiveCreditURL + lectureId
        Session.request(url) { model in
            handle(model)
        }
    }
    
    //MARK:  增加看课人数
    class func putLectureVisitors(_ lectureId:String?, handle:@escaping(_ mode:APIResponse)->Void) -> Void {
        guard let lectureId = lectureId else { return  }
        let url = LectureVisitorsURL + lectureId
        Session.request(url,method: .put) { model in
            handle(model)
        }
    }
}


extension WPSearchModel {
    //MARK:  热搜词
    class func getHotKeyworld(handle:@escaping(_ datas:[String])->Void) -> Void {
        Session.request(CommonHotKeywordURL) { model in
            handle((model.jsonModel?.data as? [String]) ?? [])
        }
    }
    
    //MARK:  全局搜索
    class func commonQuery(pageNum:Int = 1,keyword:String?=nil, handle:@escaping(_ model:WPSearchModel?)->Void) -> Void {
        var parm:[String:Any] = [:]
        parm["pageNum"] = pageNum
        parm["pageSize"] = 10
        parm["keyword"] = keyword
        Session.requestBody(CommonQueryURL,parameters: parm) { model in
            let model = model.data?.kj.model(WPSearchModel.self)
            handle(model)
        }
    }
}
