//
//  WPLectureLangMap.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/13.
//

import UIKit

class WPLectureLangMap: Convertible {
    required init() { }
    var id:String = ""
    var chineseName:String = ""
    var englishName:String = ""
    var languageCode:String = ""
    var languageType:Int = 0
    var initial:String = ""
    var status:Int = 0
    var txCode:String = ""
    
}

extension WPLectureLangMap {
    class func languages()->[WPLectureLangMap]? { return read([WPLectureLangMap].self, from: FileManager.default.wp.languagesCachePath() + "/languages") }
    class func save(_ datas:[WPLectureLangMap]) -> Void { write(datas, to: FileManager.default.wp.languagesCachePath() + "/languages") }
    
    class func languagesMap()->[String:WPLectureLangMap]? { return read([String:WPLectureLangMap].self, from: FileManager.default.wp.languagesCachePath() + "/languagesMap") }
    class func saveMap(_ datas:[String:WPLectureLangMap]) -> Void { write(datas, to: FileManager.default.wp.languagesCachePath() + "/languagesMap") }
}

extension WPLectureLangMap {
    //MARK: 语言
    class func getLectureLang(_ hanld:@escaping( _ datas:[WPLectureLangMap])->Void) -> Void {
        guard let datas:[WPLectureLangMap] = WPLectureLangMap.languages(), datas.count > 0 else {
            Session.request(LectureLangURL) { res in
                var list:[WPLectureLangMap] = []
                if let datas:[[String:Any]] = res.jsonModel?.data as? [[String:Any]]  {
                    for json in datas {
                        let model = json.kj.model(WPLectureLangMap.self)
                        list.append(model)
                    }
                    WPLectureLangMap.save(list)
                }
                hanld(list)
            }
            return
        }
        hanld(datas)
    }
    
    class func getLectureLangMap(_ hanld:@escaping( _ datas:[String:WPLectureLangMap])->Void) -> Void {
        guard let datas:[String:WPLectureLangMap] = WPLectureLangMap.languagesMap(), datas.count > 0 else {
            Session.request(LectureLangMapURL) { res in
                var datas:[String:WPLectureLangMap] = [:]
                if let json:[String:[String:Any]] = res.jsonModel?.data as? [String:[String:Any]]   {
                    for (k,v) in json {
                        let model = v.kj.model(WPLectureLangMap.self)
                        datas[k] = model
                    }
                    WPLectureLangMap.saveMap(datas)
                }
                hanld(datas)
            }
            return
        }
        hanld(datas)
    }
}
