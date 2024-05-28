//
//  WPMarkModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/29.
//

import UIKit

class WPMarkModel: NSObject {
    var text:String = ""
    var isSelected:Bool = false
    
    class func years () ->[[WPMarkModel]] {
        var datas:[[WPMarkModel]]  = []
        let list = [["在学校大学生","在校教师"],["企业工作者","自由职业"],["初中生","高中生","其他"]]
        for data in list {
            var items:[WPMarkModel] =  []
            for item in data {
                let model = WPMarkModel()
                model.text = item
                items.append(model)
            }
            datas.append(items)
        }
        return datas
    }
    
    class func interest () ->[[WPMarkModel]] {
        var datas:[[WPMarkModel]]  = []
        let list = [["城市规划","AI","元宇宙"],["建筑","村庄"]]
        for data in list {
            var items:[WPMarkModel] =  []
            for item in data {
                let model = WPMarkModel()
                model.text = item
                items.append(model)
            }
            datas.append(items)
        }
        return datas
    }
    
    
    class func getSelectedMark (_ datas:[[WPMarkModel]]) ->[WPMarkModel] {
        var lists:[WPMarkModel]  = []
        for data in datas {
            for model in data {
                if model.isSelected {
                    lists.append(model)
                }
            }
        }
        return lists
    }
    
}
