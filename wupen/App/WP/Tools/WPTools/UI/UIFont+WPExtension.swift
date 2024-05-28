//
//  UIFont+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

extension UIFont: WPPOPCompatible { }

public extension WPPOP where Base == UIFont {
   static func registerFont(fileURL: URL) {
        guard CTFontManagerRegisterFontsForURL(fileURL as CFURL, .process, nil) else {
            print("Failed to register font.")
            return
        }
        print("Font registered successfully.")
    }
}
 

