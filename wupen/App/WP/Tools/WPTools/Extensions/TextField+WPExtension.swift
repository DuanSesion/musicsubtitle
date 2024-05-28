//
//  TextField+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

//extension UITextField: WPPOPCompatible { }

extension WPPOP where Base == UITextField {
    /// 限制textField输入
     public func limitInputWithPattern(pattern: String, _ limitCount: Int = -1) {
        // 非markedText才继续往下处理
        guard let _: UITextRange = self.base.markedTextRange else {
            // 当前光标的位置（后面会对其做修改）
            let cursorPostion = self.base.offset(from: self.base.endOfDocument, to: self.base.selectedTextRange!.end)
            // 替换后的字符串
            var str = ""
            if pattern == "" {
                str = self.base.text?.wp.clearSpace() ?? ""
            } else {
                str = self.base.text?.wp.clearSpace().wp.regularReplace(pattern: pattern, with: "") ?? ""
            }
            // 如果长度超过限制则直接截断
            if limitCount >= 0, str.count > limitCount {
                str = String(str.prefix(limitCount))
            }
            self.base.text = str
            // 让光标停留在正确位置
            let targetPostion = self.base.position(from: self.base.endOfDocument, offset: cursorPostion)!
            self.base.selectedTextRange = self.base.textRange(from: targetPostion, to: targetPostion)
            return
        }
    }
}
