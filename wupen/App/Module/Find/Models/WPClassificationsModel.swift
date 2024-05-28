//
//  WPClassificationsModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/9.
//

import UIKit

class WPClassificationsModel: Convertible {//课程分类
    required init() {}
    var id:String = ""
    var chineseName:String = ""
    var englishName:String = ""
    var status:Int = 0
}

extension WPClassificationsModel {
    //MARK: 课程分类
    class func getClassificationsDatas(num:Int=4,_ hanld:@escaping(_ model:APIResponse)->Void) {
        var parm:[String:Any] = [:]
        parm["num"] = num
        Session.request(LectureClassificationsURL, parameters: parm) { model in
            if let list:[[String:Any]] = model.jsonModel?.data as? [[String:Any]] {
                let datas:[WPClassificationsModel] = list.kj.modelArray(WPClassificationsModel.self)
                model.jsonModel?.data = datas
            }
            hanld(model)
        }
    }
}
