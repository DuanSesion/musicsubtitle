//
//  WPNoticeModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/10.
//

import UIKit

class WPNoticeModel: Convertible {//广播控制器
    required init() { }
    var id:String?
    var title:String?
    var content:String?
    var createdTime:String?
    var isShow:Bool = false
    var isDel:Bool = false
    var isRead:Bool = false
}
 
extension WPNoticeModel {
    //MARK: 最近10条消息 有未读
    class func getNotice(_ hanld:@escaping(_ isRed:Bool, _ datas:[WPNoticeModel])->Void) {
        Session.request(PublicNoticeURL) { res in
            var isShow:Bool = false
            var list:[WPNoticeModel] = []
            if let datas:[[String:Any]] = res.jsonModel?.data as? [[String:Any]]  {
                for json in datas {
                    let model = json.kj.model(WPNoticeModel.self)
                    model.refresh()
                    if model.isDel == false {
                        list.append(model)
                        
                        if model.isDel == false &&
                           model.isRead == false  {
                            isShow = true
                        }
                    }
                }
            }
            hanld(isShow,list)
        }
    }
}

extension WPNoticeModel {
    func saveIsRead() -> Void {
        self.isRead = true
        let userId:String = WPUser.user()?.userInfo?.userId ??  ""
        let id:String = self.id ?? ""
        let key = "isRead_\(userId)_\(id)"
        
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func deleted() -> Void {
        self.isDel = true
        let userId:String = WPUser.user()?.userInfo?.userId ??  ""
        let id:String = self.id ?? ""
        let key = "isDel_\(userId)_\(id)"
        
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func refresh() -> Void {
        let userId:String = WPUser.user()?.userInfo?.userId ??  ""
        let id:String = self.id ?? ""
        let key = "isDel_\(userId)_\(id)"
        let readKey = "isRead_\(userId)_\(id)"
        
        let isDel:Bool =  UserDefaults.standard.bool(forKey: key)
        let isRead:Bool =  UserDefaults.standard.bool(forKey: readKey)
        
        self.isDel = isDel
        self.isRead = isRead
    }
}


public extension UserDefaults {
    /**
     Set Archive Data
     
     - parameter object: object
     - parameter key:    key
     */
    func setArchiveData<T: NSCoding>(_ object: T, forKey key: String) {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true) {
            set(data, forKey: key)
            synchronize()
        }
    }
    
    /**
     Get Archive Data
     
     - parameter _:   type
     - parameter key: key
     
     - returns: T
     */
    func archiveDataForKey<T: NSCoding>(_: T.Type, key: String) -> T? {
        guard let data = object(forKey: key) as? Data else { return nil }
        guard let object = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else { return nil }
        return object
    }
}
