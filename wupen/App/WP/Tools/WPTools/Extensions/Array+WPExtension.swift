//
//  Array+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

extension Array: WPPOPCompatible { }

public extension WPPOP where Base == Array<Any> {
    func trim() -> Array<Any>  {
        let list = self.base
        var newDatas:[Any] = []
        for item in list {
            if let item = item as? [String:Any] {
                newDatas.append(item.wp.trim())
                
            } else if let item = item as? [Any] {
                newDatas.append(item.wp.trim())
                
            } else if (item is NSNull) == false {
                newDatas.append(item)
            }
        }
        return newDatas
    }
}
