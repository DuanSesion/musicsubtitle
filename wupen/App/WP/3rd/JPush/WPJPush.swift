//
//  WPJPush.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/26.
//

import UIKit

class WPJPush: NSObject {
    //MARK: 极光
    public func initJPush() -> Void {
        //MARK: 【注册通知】通知回调代理（可选）
        JPUSHService.register(forRemoteNotificationConfig: self.pushRegisterEntity(), delegate: self)
        self.requestJPUSH([:])
    }
    
    func pushRegisterEntity() -> JPUSHRegisterEntity {
        let entity:JPUSHRegisterEntity = JPUSHRegisterEntity()
        entity.types = 7
        return entity
    }
    
    func requestJPUSH(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Void {
        let kJpushAppkey = "662b6174940d5a4c49491ebc"
        JPUSHService.setup(withOption: launchOptions ?? [:], appKey: kJpushAppkey, channel: "", apsForProduction: true)
        //MARK: 获取registrationId/检测通知授权情况/地理围栏/voip注册/监听连接状态等其他功能
        JPUSHService.setAlias("public", completion: { code, iAlias, seq in}, seq: 0)
    }
    
    func registerDeviceToken(_ deviceToken:Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
         
        let token = tokenParts.joined(separator: " ")
        print("Device Token: \(token)")
    }
}

extension WPJPush:JPUSHRegisterDelegate {
    // MARK: 收到的 APNs 消息
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: ((Int) -> Void)) {
        let userInfo = notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: (() -> Void)) {
        let userInfo = response.notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler()
        
        let json:NSMutableDictionary = NSMutableDictionary(dictionary: userInfo)
        let model:WPSysNotice? = json.kj.model(type: WPSysNotice.self) as? WPSysNotice
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]?) {
        debugPrint("receive notification authorization status:\(status), info:\(info ?? [:])")
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
         
    }
}



class WPApsNotice: Convertible {
    required init() {}
    
    var badge:Int?
    var alert:WPAlertNotice?
}

class WPAlertNotice: Convertible {
    required init() {}
    
    var body:String?
    var title:String?
}

class WPNoData: Convertible {
    required init() {}
    
    var data_msgtype:Int?
    var push_type:Int?
    var is_vip:Int?
}

public class WPSysNotice: Convertible {
//    public static let `default` = WPSysNotice()
    var isToggle:Bool = false
    required public init() {}
    private  var pasteControl:Any? = nil
    
    var noticeContent:String?
    var noticeCount:Int = 0
    var noticeCreatedTime:String?
    var userNoticeContent:String?
    var userNoticeCount:Int = 0
    var userNoticeCreatedTime:String?
    
    var aps:WPApsNotice?
    var _j_msgid:String?
    var _j_uid:String?
    var _j_business:String?
    var _j_data_:WPNoData?
}
