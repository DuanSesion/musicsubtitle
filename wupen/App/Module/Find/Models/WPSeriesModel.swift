//
//  WPSeriesModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/9.
//

import UIKit

class WPSeriesModel: Convertible {//系列课程
    required init() {}
    
    //--系列课程的字段
    var id:String?
    var chineseName:String?
    var englishName:String?
    var chineseIntroduce:String?
    var englishIntroduce:String?
    var coverImage:String?
    var status:Int = 0
    var top:Int = 0
    var dropDownFlag:Int = 0
    var shortName:String?
    var lectureCount:Int = 0
}

extension WPSeriesModel {
    //MARK: 系列课程
    class func seriesGetDatas(isHome:Bool=true,_ hanld:@escaping(_ model:APIResponse)->Void) {
        var parm:[String:Any] = [:]
        parm["isHome"] = isHome
        Session.request(SeriesURL, parameters: parm) { model in
            if let list:[[String:Any]] = model.jsonModel?.data as? [[String:Any]] {
                let datas:[WPCouserModel] = list.kj.modelArray(WPCouserModel.self)
                model.jsonModel?.data = datas
            }
            hanld(model)
        }
    }
}
