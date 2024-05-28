//
//  WPCouserModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPCouserModel: Convertible {
    required init() { }
    //--课程的字段
    var lectureId:String?
    var title:String?
    var titleEn:String?
    var introduce:String?
    var introduceEn:String?
    var classification:String?
    var series:[Int]?
    var tags:String?
    var duration:String?
    var scholarName:String?
    var scholarNameEn:String?
    var scholarAvatar:String?
    var coverImage:String?
    var universityName:String?
    var universityNameEn:String?
    var learnNums:Int = 0
    var updateTime:String?
    
    //--系列课程的字段
    var id:String?
    var chineseName:String?
    var englishName:String?
    var chineseTitle:String?
    var englishTitle:String?
    
    var chineseIntroduce:String?
    var englishIntroduce:String?
//    var coverImage:String?
    var status:Int = 0
    var top:Int = 0
    var dropDownFlag:Int = 0
    var shortName:String?
    var lectureCount:Int = 0
 
    var cellHeight:CGFloat = 106.0
}


extension WPCouserModel {
    //MARK: 查询课程详情数据
     func checkCouserDetail(_ hanld:@escaping(_ resp:APIResponse,_ des:WPCouserDetailModel?)->Void) {
         let lectureID = "\(self.lectureId ?? "")"
        let url = LectureDetailURL + lectureID
        Session.request(url) {  model in
            var des:WPCouserDetailModel? = nil
            if let json:[String:Any] = model.jsonModel?.data as? [String:Any]  {
                des = json.kj.model(WPCouserDetailModel.self)
                des?.videos.forEach({ video in
                    video.captionMapJsonToModels()
                })
                des?.videos.first?.isSelected = true
            }
            hanld(model,des)
        }
    }
}

extension WPCouserModel {
    func adjustCellHeight() -> Void {
        //checkUpdateState()
        
        let imgH = 92.0
        let textWidth = (WPScreenWidth - 45)/2 - 16
        var textH:CGFloat = title?.heightWithFont(font: .systemFont(ofSize: 14), fixedWidth: textWidth) ?? 0
        if  textH < 20 {
            textH = 20.0
        }
        
        let bH = 68.0
        cellHeight = imgH + bH + textH + 14.0 + 8.0
        
//        if self.status == 0 {
//            let bH = 80.0
//            cellHeight = imgH + bH + textH + 14.0
//            
//        } else {
//            let bH = 68.0
//            cellHeight = imgH + bH + textH + 14.0
//        }
    }
}

