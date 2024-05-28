//
//  UIView+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

extension UIView: WPPOPCompatible { 
    /// 尺寸
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            self.frame.size = CGSize(width: newValue.width, height: newValue.height)
        }
    }

    /// 宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            self.frame.size.width = newValue
        }
    }

    /// 高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            self.frame.size.height = newValue
        }
    }

    /// 横坐标
    var x: CGFloat {
        get {
            return self.frame.minX
        }
        set(newValue) {
            self.frame = CGRect(x: newValue, y: y, width: width, height: height)
        }
    }

    /// 纵坐标
    var y: CGFloat {
        get {
            return self.frame.minY
        }
        set(newValue) {
            self.frame = CGRect(x: x, y: newValue, width: width, height: height)
        }
    }

    /// 右端横坐标
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(newValue) {
            self.frame.origin.x = newValue - self.frame.size.width
            self.frame = CGRect(x: newValue - self.frame.size.width, y: y, width: width, height: height)
        }
    }

    /// 底端纵坐标
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(newValue) {
            self.frame.origin.y = newValue - self.frame.size.height
            
            self.frame = CGRect(x: x, y: newValue - self.frame.size.height, width: width, height: height)
        }
    }

    /// 中心横坐标
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            self.center = CGPoint(x:newValue,y:self.centerY)
            //center.x = newValue
        }
    }

    /// 中心纵坐标
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newValue) {
            self.center = CGPoint(x:self.centerX,y:newValue)
        }
    }

    /// 原点
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(newValue) {
            self.frame.origin = newValue
        }
    }

    /// 右上角坐标
    var topRight: CGPoint {
        get {
            return CGPoint(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y)
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: newValue.x - width, y: newValue.y)
        }
    }

    /// 右下角坐标
    var bottomRight: CGPoint {
        get {
            return CGPoint(x: self.frame.origin.x + self.frame.size.width, y: self.frame.origin.y + self.frame.size.height)
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: newValue.x - width, y: newValue.y - height)
        }
    }

    /// 左下角坐标
    var bottomLeft: CGPoint {
        get {
            return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height)
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: newValue.x, y: newValue.y - height)
        }
    }
    
}


public extension  UIView {
    var cornerRadius: CGFloat {
        set { self.layer.cornerRadius = newValue }
        get { return self.layer.cornerRadius }
    }

    var borderColor: UIColor {
        set { self.layer.borderColor = newValue.cgColor }
        get { return UIColor(cgColor: self.layer.borderColor!) }
    }

    var borderWidth: CGFloat {
        set { self.layer.borderWidth = newValue }
        get { return self.layer.borderWidth }
    }
    
    func resignKeyboard() -> Void {
        //IQKeyboardManager.shared.resignFirstResponder()
    }
    
    func setCorners(_ corners:UIRectCorner, cornerRadius:CGFloat = 0.0, shadowRadius:CGFloat = 0.0,shadowColor:UIColor = .clear) -> Void {
        let radii = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radii)
        let mask = CAShapeLayer()
        mask.shadowRadius = shadowRadius
        
        mask.shadowColor = shadowColor.cgColor
        mask.shadowOffset = CGSize(width: 0, height: 5)
        mask.shadowOpacity = 1
        mask.backgroundColor = UIColor.clear.cgColor
    
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


public extension  UIView {
    func showMessage(_ message: String?, duration: TimeInterval = 1.66, title: String? = nil, image: UIImage?=nil, style: ToastStyle = ToastManager.shared.style, completion: ((_ didTap: Bool) -> Void)? = nil) -> Void {
         DispatchQueue.main.async { [weak self] in
             self?.makeToast(message,duration: duration,position:.center, title: title, image: image, completion: completion)
         }
     }
    
    func animationSmall()->Void {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        pulse.duration = 0.05
        pulse.repeatCount = 1
        pulse.autoreverses = true
        pulse.fromValue = 1
        pulse.toValue = 0.7
        // 给tabBarButton添加动画效果
        self.layer.add(pulse, forKey: nil)
    }
}


public extension  UIView {
    func show(_ animations: @escaping () -> Void) -> Void {
        WPKeyWindowDev?.rootViewController?.view.addSubview(self)
        UIView.animate(withDuration: 0.25) {
//            self.contentView.transform = .identity
            self.alpha = 1
            animations()
        }
    }

    func dismiss(_ animations: @escaping () -> Void) -> Void {
        UIView.animate(withDuration: 0.25) {
//            self.contentView.transform = .init(scaleX: 0.01, y: 0.01)
            self.alpha = 0
            animations()
             
        } completion: { r in
            self.removeFromSuperview()
        }
    }
    
    func transformMini() -> Void {
        self.transform = .init(scaleX: 0.01, y: 0.01)
    }
    
    func transformMax() -> Void {
        self.transform = .identity
    }
}


extension UIView {

    func showUnityNetActivity( msg:String?=nil, hasBackground:Bool=false)->Void {
        if hasBackground {
            let viewBackground = UIView(frame: .init(x: 0, y: 0, width: self.width, height: self.height))
            viewBackground.backgroundColor = .clear
            self.addSubview(viewBackground)
            ProgressHUD.shared.viewBackground = viewBackground
        }

        ProgressHUD.colorStatus = rgba(255, 49, 49, 1)
        ProgressHUD.colorAnimation = rgba(255, 49, 49, 1)
        ProgressHUD.animationType = .circleDotSpinFade //.circleSpinFade
        ProgressHUD.animate(msg, interaction: false)
    }
    
     class func removeNetActivity()->Void {
         ProgressHUD.remove()
     }
    
     func removeNetActivity()->Void {
         ProgressHUD.remove()
     }
    
    func showSucceed(_ msg:String,hasBackground:Bool=false)->Void {
        if hasBackground {
            let viewBackground = UIView(frame: .init(x: 0, y: 0, width: self.width, height: self.height))
            self.addSubview(viewBackground)
            ProgressHUD.shared.viewBackground = viewBackground
        }
        
        ProgressHUD.colorStatus = rgba(254, 143, 11, 1)
        ProgressHUD.colorAnimation = rgba(254, 143, 11, 1)
        ProgressHUD.succeed(msg, delay: 1.88)
    }
    
    func showError(_ msg:String?,hasBackground:Bool=false)->Void {
        if hasBackground {
            let viewBackground = UIView(frame: .init(x: 0, y: 0, width: self.width, height: self.height))
            self.addSubview(viewBackground)
            ProgressHUD.shared.viewBackground = viewBackground
        }
        
        ProgressHUD.colorStatus = rgba(254, 143, 11, 1)
        ProgressHUD.colorAnimation = rgba(254, 143, 11, 1)
        ProgressHUD.error(msg, delay: 1.88)
    }
}


extension UITextField {
 
    /// 限制textField输入
    public func limitInputWithPattern(pattern: String, _ limitCount: Int = -1) {
        // 非markedText才继续往下处理
        guard let _: UITextRange = self.markedTextRange else {
            // 当前光标的位置（后面会对其做修改）
            let cursorPostion = self.offset(from: self.endOfDocument, to: self.selectedTextRange!.end)
            // 替换后的字符串
            var str = ""
            if pattern == "" {
                str = self.text?.wp.clearSpace() ?? ""
            } else {
                str = self.text?.wp.clearSpace().wp.regularReplace(pattern: pattern, with: "") ?? ""
            }
            // 如果长度超过限制则直接截断
            if limitCount >= 0, str.count > limitCount {
                str = String(str.prefix(limitCount))
            }
            self.text = str
            // 让光标停留在正确位置
            let targetPostion = self.position(from: self.endOfDocument, offset: cursorPostion)!
            self.selectedTextRange = self.textRange(from: targetPostion, to: targetPostion)
            return
        }
    }
 
}
