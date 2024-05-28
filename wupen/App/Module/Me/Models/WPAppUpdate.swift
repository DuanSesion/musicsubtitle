//
//  WPAppUpdate.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/16.
//

import UIKit

let AppUpdateURL:String = "https://itunes.apple.com/cn/lookup?id=11111111111111111111"
let AppDowloadURL = "https://apps.apple.com/cn/app/%E6%B5%B7%E5%85%83%E5%AE%87%E5%AE%99/id11111111111111111111?uo=4"

class WPVersionItem: Convertible {
    required init() {}
    var releaseNotes:String?
    var version:String?
    var description:String?
    var trackViewUrl:String = AppDowloadURL
}

class WPAppUpdate: Convertible {
    required init() {}
    var resultCount:Int?
    var results:[WPVersionItem]?
}

extension WPAppUpdate {
    //MARK:--app更新
    class func checkAppUpdateVersion(isSHow:Bool = true, handle:@escaping(_ model:WPAppUpdate?, _ isNew:Bool)->Void)->Void {
 
        if isSHow {
            WPKeyWindowDev?.showUnityNetActivity()
        }
        
        Session.request(AppUpdateURL, method: .post) { response in
            UIView.removeNetActivity()
            guard let data:Data = response.data else {return}
            let model:WPAppUpdate? = data.kj.model(WPAppUpdate.self)
            let item:WPVersionItem? = model?.results?.first
            
            if  (model?.results?.count ?? 0 > 0)  {
                let list = item?.version?.split(separator: ".")
                let currentList = WPVersion.split(separator: ".")
                for i in 0..<(list?.count ?? 0) {
                    if i < (list?.count ?? 0) && i < currentList.count {
                        let index = "\(list![i])"
                        let cindex = "\(currentList[i])"
                        if (Int(index) ?? 0 ) > (Int(cindex) ?? 0) {
                            handle(model, true)
                            return

                        } else if (Int(index) ?? 0 ) < (Int(cindex) ?? 0) {
                            handle(model, false)
                            return
                        }
                    }
                }
                handle(model, false)

            } else {
                handle(model, false)
            }
        }
    }
}
