//
//  String+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

extension String: WPPOPCompatible {
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let start = range.lowerBound.samePosition(in: self),
              let end = range.upperBound.samePosition(in: self) else {
            return nil
        }
        return NSRange(location: self.distance(from: self.startIndex, to: start),
                       length: self.distance(from: start, to: end))
    }
}

public extension Int {
    func durationStr() -> String {//转换时分秒
        let totalSeconds = self
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        // 格式化为两位数，不足两位前面补0
        let formattedHours = String(format: "%02d", hours > 0 ? hours : 0 )
        let formattedMinutes = String(format: "%02d", minutes > 0 ? minutes : 0 )
        let formattedSeconds = String(format: "%02d", seconds > 0 ? seconds : 0 )
        if hours > 0 {
            return "\(formattedHours):\(formattedMinutes):\(formattedSeconds)"
        }
        return "\(formattedMinutes):\(formattedSeconds)"
    }
}

public extension WPPOP where Base == String {
    func trim() -> String {
        var components = self.base.trimmingCharacters(in: .newlines)
        components = components.trimmingCharacters(in: .whitespaces)
        return components
    }
    
    func clearSpace() -> String {
        let text = NSString(string: self.base)
        let whitespaces = NSCharacterSet.whitespaces
        let noEmptyStrings = NSPredicate.init(format: "SELF != ''")
        let parts:NSMutableArray =  NSMutableArray(array: text.components(separatedBy: whitespaces))
        parts.filter(using: noEmptyStrings)
        return parts.componentsJoined(by: "")
    }
    
    // 使用正则表达式替换
    func regularReplace(pattern: String, with: String, options: NSRegularExpression.Options = []) -> String {
            let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self.base, options: [],
                                                  range: NSMakeRange(0, self.base.count),
                                                  withTemplate: with)
    }
}


extension String {
    
    /**
     Get the height with the string.
     
     - parameter attributes: The string attributes.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func heightWithStringAttributes(attributes : [NSAttributedString.Key : AnyObject], fixedWidth : CGFloat) -> CGFloat {
        
        guard self.count > 0 && fixedWidth > 0 else {
        
            return 0
        }
        
        let size = CGSizeMake(fixedWidth, CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
    }
    
    /**
     Get the height with font.
     
     - parameter font:       The font.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func heightWithFont(font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat) -> CGFloat {
        
        guard self.count > 0 && fixedWidth > 0 else {
            
            return 0
        }
        
        let size = CGSizeMake(fixedWidth, CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.height
    }
    
    /**
     Get the width with the string.
     
     - parameter attributes: The string attributes.
     
     - returns: The width.
     */
    func widthWithStringAttributes(attributes : [NSAttributedString.Key : AnyObject]) -> CGFloat {
        
        guard self.count > 0 else {
            
            return 0
        }
        
        let size = CGSizeMake(CGFloat.greatestFiniteMagnitude, 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.width
    }
    
    /**
     Get the width with the string.
     
     - parameter font: The font.
     
     - returns: The string's width.
     */
    func widthWithFont(font : UIFont = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        
        guard self.count > 0 else {
            
            return 0
        }
        
        let size = CGSizeMake(CGFloat.greatestFiniteMagnitude, 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.width
    }
}
