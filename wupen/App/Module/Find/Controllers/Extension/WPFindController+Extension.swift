//
//  WPFindController+Extension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/4.
//

import UIKit

extension WPFindController {
    @objc func panGest(pan:UIPanGestureRecognizer)->Void {// MARK: 拖动能量中心图
        let navigationBarHeight = kNavigationBarHeight+5
 
        let tanslation:CGPoint =  pan.translation(in: self.view)
        let centerX:CGFloat = self.aiButton.centerX + tanslation.x
        let centerY:CGFloat = self.aiButton.centerY + tanslation.y

        let h:CGFloat = self.aiButton.height
        let w:CGFloat = self.aiButton.width
 
        var x:CGFloat = centerX-(w/2)
        var y:CGFloat = centerY-(h/2)
        if x<0 {
           x = 0
            
        } else if x>(WPScreenWidth-w) {
            x = WPScreenWidth-w
        }

        let bottomH:CGFloat = self.tabBarController?.tabBar.height ?? 0
        
        if y < navigationBarHeight {
            y = navigationBarHeight
            
        } else if y>(WPScreenHeight - h - bottomH) {
            y = WPScreenHeight - h - bottomH
        }
 
        pan.view?.origin = CGPoint(x: x, y: y)
        pan.setTranslation(.zero, in: self.view)
        
        
        if pan.state == .ended || pan.state == .cancelled {
            let halfLeftX  = (centerX - w/2)
            let wHalf = WPScreenWidth/2
            
            var endCenterX = centerX
            let endCenterY = centerY
            
            if endCenterX > halfLeftX && endCenterX < wHalf  {
               endCenterX = w/2
            } else {
               endCenterX = WPScreenWidth - (w/2)
            }
            UIView.animate(withDuration: 0.25, delay: 0.15, usingSpringWithDamping: 1, initialSpringVelocity: 0.5) {
                pan.view?.center = CGPoint(x: endCenterX, y: endCenterY)
            }
        }
    }
}
