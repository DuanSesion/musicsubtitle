//
//  Dictionary+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

extension Dictionary: WPPOPCompatible { }

public extension WPPOP where Base == Dictionary<String,Any> {
    func trim() -> Dictionary<String,Any>  {
        var dic = self.base
        for (k,v) in dic {
            if (v is NSNull) 
                || (v as? String == "null")
                || (v as? String == "<null>")
                || (v as? String == "(null)")
                || (v as? String == "NULL")  {
                dic.removeValue(forKey: k)
                
            } else if (v is [String:Any]) {
                let vdic = v as! [String:Any]
                dic.updateValue(vdic.wp.trim(), forKey: k)
                
            } else if (v is [Any]) {
                let vArray = v as! [Any]
                dic.updateValue(vArray.wp.trim(), forKey: k)
            }
        }
        return dic
    }
}
