//
//  WPMyCollectModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/17.
//

import UIKit

class WPMyCollectModel: Convertible {
    required init() {}
}

extension WPMyCollectModel {
    class func saveMyCollects( _ datas:[WPLiveModel]) {
        write(datas.self, to: FileManager.default.wp.collectIDsCachePath() + "/mycollects")
    }
    
    class func getMyCollects() ->[WPLiveModel] {
        return read([WPLiveModel].self, from: FileManager.default.wp.collectIDsCachePath() + "/mycollects") ?? []
    }
}

extension WPMyCollectModel {
    //MARK: 我的直播收藏
    class func getMyCollectLives(_ pageNum:Int=1,_ hanld:@escaping( _ datas:[WPLiveModel])->Void) {
        let myCollects = WPMyCollectModel.getMyCollects()
        if myCollects.count > 0 {
            hanld(myCollects)
        }
        
        var parameters:[String:Any] = [:]
        //parameters["pageSize"] = 10
//        parameters["pageNum"] = pageNum
        parameters["contentType"] = "live"
        Session.requestBody(UserPageMyCollectURL,method: .post,parameters: parameters) { res in
            let totalElements:Int = res.jsonModel?.totalElements ?? 0
            var list:[WPLiveModel] = []
            if let datas:[[String:Any]] = res.jsonModel?.data as? [[String:Any]]  {
                for json in datas {
                    let model = json.kj.model(WPLiveModel.self)
                    model.checkUpdateState()
                    list.append(model)
                }
                WPMyCollectModel.saveMyCollects(list)
            }
            hanld(list)
        }
    }
}
