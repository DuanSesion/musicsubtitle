//
//  WPMyScoreRecordModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/10.
//

import UIKit

class WPMyScoreRecordModel: Convertible {
    required init() { }
    
    var id:String?
    var userId:String?
    var lectureId:String?
    var credit:Int = 0
    var remark:String?
    var updatedTime:String?
}

extension WPMyScoreRecordModel {
    //MARK: 学分记录
    class func getMyScoreRecord(_ pageNum:Int=1,_ hanld:@escaping( _ datas:[WPMyScoreRecordModel], _ totalElements:Int)->Void) {
        var parameters:[String:Any] = [:]
        parameters["pageSize"] = 10
        parameters["pageNum"] = pageNum
        parameters["userId"] = WPUser.user()?.userInfo?.userId
        Session.requestBody(UserQueryCreditRecordURL,method: .post,parameters: parameters) { res in
            let totalElements:Int = res.jsonModel?.totalElements ?? 0
            var list:[WPMyScoreRecordModel] = []
            if let datas:[[String:Any]] = res.jsonModel?.data as? [[String:Any]]  {
                for json in datas {
                    let model = json.kj.model(WPMyScoreRecordModel.self)
                    list.append(model)
                }
            }
            hanld(list,totalElements)
        }
    }
}
