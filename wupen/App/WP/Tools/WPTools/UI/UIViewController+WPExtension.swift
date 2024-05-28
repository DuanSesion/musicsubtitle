//
//  UIViewController+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

extension UIViewController: WPPOPCompatible { }

public extension WPPOP where Base == UIViewController {
    // MARK: 当前APP界面显示的 ViewController
    static  func TopViewController(base: UIViewController?) -> UIViewController? {
          if let nav = base as? UINavigationController {
              return TopViewController(base: nav.visibleViewController)
          }
        
          if let presented = base?.presentedViewController {
              return TopViewController(base: presented)
          }
        
          if let tab = base as? UITabBarController {
              if let selected = tab.selectedViewController {
                  return TopViewController(base: selected)
              }
          }
          return base
      }
    
    func TopViewController() -> UIViewController? {
        if let nav = self.base as? UINavigationController {
            return WPPOP<UIViewController>.TopViewController(base: nav.visibleViewController)
        }
        
        if let presented = self.base.presentedViewController {
            return WPPOP<UIViewController>.TopViewController(base: presented)
        }
        
        if let tab = base as? UITabBarController {
          if let selected = tab.selectedViewController {
              return WPPOP<UIViewController>.TopViewController(base: selected)
          }
        }
        return base
    }
}
