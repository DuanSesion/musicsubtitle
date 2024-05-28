//
//  WPUser.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/4.
//

import UIKit

class WPUserInfo: Convertible {
    required init() {}
    var userId:String?
    var username:String?
    var phone:String?
    var email:String?
    var location:String?
    var firstName:String?
    var lastName:String?
    var gender:Int? //性别
    var birthday:String? //生日
    var profilePhoto:String?//头像
    var introduce:String?
    var occupationStatus:Int = 0
    var company:String?
    var occupation:String?
    var university:String?
    var professional:String?
    var enroll:String?
    var loginTime:String?
    var userGroup:Int = 0
    var registeredTime:String?
    var credit:Int = 0 //学分
    var creditDuration:Int = 0//累计学时
    var interestTags:String? //兴趣标签
}

class WPUser: Convertible {
    required init() {}
    var token:String?
    var userInfo:WPUserInfo?
}

extension WPUser {
    class func user()->WPUser? { return read(WPUser.self, from: FileManager.default.wp.usersPath() + "/user") }
    public func save() -> Void { write(self, to: FileManager.default.wp.usersPath() + "/user") }
    class func clean() -> Void {
        let path = FileManager.default.wp.usersPath() + "/user"
        if FileManager.default.fileExists(atPath: path) {
           try? FileManager.default.removeItem(atPath: path)
        }
    }
    
    public func saveFirst() -> Void { write(self, to: FileManager.default.wp.usersPath() + "/\(self.userInfo?.userId ?? "")") }
    public func getFirst(_ userId:String?=nil) -> WPUser?  {
        return read(WPUser.self, from: FileManager.default.wp.usersPath() + "/\(userId ?? "")")
    }
}

extension WPUser {
    class func sendValidPHONE_LOGIN(phone:String,_ hanld:@escaping(_ model:APIResponse)->Void) {
        var parm:[String:Any] = [:]
        parm["validType"] = "PHONE_LOGIN"
        parm["target"] = phone
        Session.requestBody(SendValidURL, parameters: parm) { model in
            hanld(model)
        }
    }
    
    class func userAuth(phone:String?=nil, validCode:String?, appleCode:String?=nil, _ hanld:@escaping(_ model:APIResponse)->Void) {
        var parm:[String:Any] = [:]
        parm["appleCode"] = appleCode
        parm["telephone"] = phone
        parm["validCode"] = validCode
        Session.requestBody(UserAuthURL, parameters: parm) { model in
            let result:Bool = (phone != nil)
            
            if model.jsonModel?.code == 200 {
                if  let token:String = model.jsonModel?.data as? String {
                    let user = WPUser()
                    user.token = token
                    user.save()
                    WPUmeng.um_event_login(result,username:result ? phone : appleCode, sucesse: true)
                    
                    WPUser.userDetail { user in
                        hanld(model)
                        user?.saveFirst()
                        WPUmeng.um_event_login_LoginSuccess(username: user?.userInfo?.userId)
                    }
                    
                } else {
                    WPKeyWindowDev?.showError("login error")
                    WPUmeng.um_event_login(result,username:result ? phone : appleCode, sucesse: false)
                    WPUmeng.um_event_login_LoginFailure(error: model.jsonModel?.msg ?? model.msg)
                }
                
            } else {
                hanld(model)
                WPKeyWindowDev?.showError("login error")
                WPUmeng.um_event_login(result,username:result ? phone : appleCode, sucesse: false)
                WPUmeng.um_event_login_LoginFailure(error: model.jsonModel?.msg ?? model.msg)
            }
        }
    }
    
    class func userDetail(_ hanld:@escaping(_ user:WPUser?)->Void) {
        Session.request(UserDetailURL) { model in
            let user = WPUser.user()
            if  let json:[String:Any] = model.jsonModel?.data as? [String:Any] {
                let userInfo = json.kj.model(WPUserInfo.self)
                user?.userInfo = userInfo
                user?.save()
            }
            hanld(user)
        }
    }
    
    class func userSaveMark(marks:String?=nil,
                            username:String?=nil,
                            gender:Int?=nil,
                            birthday:String?=nil,
                            profilePhoto:String?=nil,
                            phone:String?=nil,
                            _ hanld:@escaping(_ model:APIResponse)->Void) {
        var parm:[String:Any] = [:]
        parm["interestTags"] = marks
        parm["username"] = username
        parm["gender"] = gender
        parm["birthday"] = birthday
        parm["profilePhoto"] = profilePhoto
        parm["phone"] = phone
        Session.requestBody(UserEditUserDetailURL,method: .put,parameters: parm) { model in
            WPUser.userDetail { user in
                user?.save()
                hanld(model)
            }
        }
    }
}

 


