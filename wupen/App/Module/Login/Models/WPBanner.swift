//
//  WPBanner.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/14.
//

import UIKit

class WPBanner: Convertible {//app-home
    required init() {}
    var id:String = ""
    var title:String = ""
    var image:String = ""
    var links:String = ""
    var sub_titles:String = ""
    var position:String = ""
    var order_num:Int = 0
    var status:Int = 0
    var create_time:String = ""
    var update_time:String = ""
    var h5_link:String?
}


extension WPBanner {
    class func getHomeBanner(pageNum:Int=1,position:String="app-home", _ hanld:@escaping(_ datas:[WPBanner])->Void) {
        var parm:[String:Any] = [:]
        parm["pageNum"] = pageNum
        parm["position"] = position
        parm["pageSize"] = 10
        
        Session.requestBody(BannerPageURL, parameters: parm) { model in
            var datas:[WPBanner] = []
            if let json:[[String:Any]] = model.jsonModel?.data as? [[String:Any]]   {
                json.forEach { js in
                    let model = js.kj.model(WPBanner.self)
                    //model.links = model.links.replacingOccurrences(of: "http://", with: "https://")
                    if model.links.contains("https://") == false &&
                        model.links.contains("http://") == false {
                        model.links = "http://" + model.links
                    }
                    
                    if let h5 = model.h5_link {
                        //model.h5_link = h5.replacingOccurrences(of: "http://", with: "https://")
                        if h5.contains("https://") == false &&
                            model.links.contains("http://") == false  {
                            model.h5_link = "http://" + h5
                        }
                    }
                    datas.append(model)
                }
            }
            hanld(datas)
        }
    }
}
