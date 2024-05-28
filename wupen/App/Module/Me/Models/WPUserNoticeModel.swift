//
//  WPUserNoticeModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/10.
//

import UIKit

class WPUserNoticeModel: Convertible {
    required init() { }
 
    var id:String?
    
    var userId:String?
    var title:String?
    var content:String?
    var isShow:Bool = false
    var isRead:Bool = false
    var isDel:Bool = false
    var noticeBy:String?
    var noticeAvatar:String?
    var createdTime:String?
    var updatedTime:String?
}

extension WPUserNoticeModel {
    //MARK: 最近10条消息 有未读
    class func getNotice(_ pageNum:Int=1,_ hanld:@escaping(_ isRed:Bool, _ datas:[WPUserNoticeModel], _ totalElements:Int)->Void) {
        var parameters:[String:Any] = [:]
        parameters["userId"] = WPUser.user()?.userInfo?.userId
        parameters["pageSize"] = 10
        parameters["pageNum"] = pageNum
        Session.requestBody(UserPageMyNoticeURL,method: .post,parameters: parameters) { res in
            var isShow:Bool = false
            let totalElements:Int = res.jsonModel?.totalElements ?? 0
            var list:[WPUserNoticeModel] = []
            if let datas:[[String:Any]] = res.jsonModel?.data as? [[String:Any]]  {
              
                for json in datas {
                    let model = json.kj.model(WPUserNoticeModel.self)
                    list.append(model)
                    debugPrint(model.isShow)

                    if model.isShow == false  {
                        isShow = true
                    }
                }
            }
            hanld(isShow,list,totalElements)
        }
    }
    
    func readNotice(_ block:@escaping()->Void) -> Void {//标记已读
        if let noticeID = self.id   {
            if self.isShow == false {
                let url = UserReadNoticeURL + noticeID
                Session.request(url,method: .post) {[weak self] model in
                    guard let weakSelf = self else { return  }
                    if model.jsonModel?.code == 200 {
                        weakSelf.isShow = true
                    }
                    block()
                }
            }
        }
    }
    
    func deleteNotice(_ block:@escaping(_ r:Bool)->Void) -> Void {//删除
        if let noticeID = self.id   {
            if self.isDel == false {
                let url = UserDeleteNoticeURL + noticeID
                Session.request(url,method: .post) {[weak self] model in
                    guard let weakSelf = self else { return  }
                    if model.jsonModel?.code == 200 {
                        weakSelf.isDel = true
                        block(true)
                        
                    } else {
                        block(false)
                    }
                }
            }
        }
    }
}
