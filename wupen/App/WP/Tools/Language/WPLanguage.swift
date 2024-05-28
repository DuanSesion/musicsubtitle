//
//  WPLanguage.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/8.
//

import UIKit

class WPLanguage: NSObject {
    class func currentLanguage()->String {
//        Locale.preferredLanguages
        return Locale.current.identifier
    }
    
    class func chinessLanguage()->Bool {//"zh_CN"
        if  Locale.current.identifier == "zh_CN" ||
            Locale.current.identifier == "zh-Hans_CN" ||
            Locale.current.identifier == "zh-Hant_CN"   {
            return true
        }//"en_CN"
        return false
    }
}
