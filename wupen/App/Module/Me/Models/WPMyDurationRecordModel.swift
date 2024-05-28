//
//  WPMyDurationRecordModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/10.
//

import UIKit

class WPMyDurationRecordModel: Convertible {
    required init() { }
    
    var id:String?
    var userId:String?
    var lectureId:String?
    var videoId:String?
    var duration:Int = 0
    var remark:String?
    var updatedTime:String?
}

extension WPMyDurationRecordModel {
    //MARK: 学习时长记录
    class func getMyDurationRecord(_ pageNum:Int=1,_ hanld:@escaping( _ datas:[WPMyDurationRecordModel], _ totalElements:Int)->Void) {
        var parameters:[String:Any] = [:]
        parameters["pageSize"] = 10
        parameters["pageNum"] = pageNum
        parameters["userId"] = WPUser.user()?.userInfo?.userId
        Session.requestBody(UserQueryDurationRecordURL,method: .post,parameters: parameters) { res in
            let totalElements:Int = res.jsonModel?.totalElements ?? 0
            var list:[WPMyDurationRecordModel] = []
            if let datas:[[String:Any]] = res.jsonModel?.data as? [[String:Any]]  {
                for json in datas {
                    let model = json.kj.model(WPMyDurationRecordModel.self)
                    list.append(model)
                }
            }
            hanld(list,totalElements)
        }
    }
}
