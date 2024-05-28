//
//  UIImage+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

extension UIImage: WPPOPCompatible { 
    // MARK: 文字加到UIImage上
    func addTitle(title: String, font: UIFont, point:CGPoint, textColor:UIColor? = UIColor.white) -> UIImage? {
        // 画布大小
        let size = CGSize(width: self.size.width, height: self.size.height)
        // 创建一个基于位图的上下文
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        //文字样式属性
        let style = NSMutableParagraphStyle ()
        style.lineBreakMode = .byCharWrapping
        style.alignment = .center
        
        // 计算文字所占的size，文字居中显示在画布上
        let attributes = [ NSAttributedString.Key.font : font,
                           NSAttributedString.Key.foregroundColor : textColor,
                           NSAttributedString.Key.paragraphStyle : style]
        
        let sizeText = (title as NSString).boundingRect(with: self.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        
        let rect = CGRect(x: point.x , y: point.y, width: sizeText.width, height: sizeText.height)
        
        // 绘制文字
        (title as NSString).draw(in: rect, withAttributes: attributes as [NSAttributedString.Key : Any])
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: UIImage加到UIImage上
    func addImagePoint(logoImg: UIImage, logoPoint:CGPoint) -> UIImage {
        let srcImg = self
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        srcImg.draw(in: CGRect(x: 0, y: 0, width: srcImg.size.width, height: srcImg.size.height),blendMode: .normal, alpha: 1)
        let rect = CGRect(x: logoPoint.x,
                          y: logoPoint.y,
                          width: logoImg.size.width,
                          height: logoImg.size.height)
        logoImg.draw(in: rect, blendMode: .normal, alpha: 1)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultingImage!
    }
}


public extension WPPOP where Base == UIImage {
    /// 生成纯色图片
    static func createColorImage(_ color: UIColor, size:CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height:size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: - 调整图片分辨率/尺寸（等比例缩放）
    func scaleSize(_ newSize: CGSize) -> UIImage? {
        let size = self.base.size
        let heightScale = newSize.height / size.height
        let widthScale = newSize.width / size.width

        var finallSize = CGSize(width: newSize.width, height: newSize.height)
        if widthScale > 1.0, widthScale > heightScale {
            finallSize = CGSize(width: size.width / widthScale, height: size.height / widthScale)
        } else if heightScale > 1.0, widthScale < heightScale {
            finallSize = CGSize(width: size.width / heightScale, height: size.height / heightScale)
        }
        let w:Float = truncf(Float(finallSize.width))
        let h:Float = truncf(Float(finallSize.height))
        UIGraphicsBeginImageContext(CGSize(width: Int(w), height: Int(h)))
        self.base.draw(in: CGRect(x: 0, y: 0, width: Int(w), height: Int(h)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func roundCorner(_ radius:CGFloat) -> UIImage {
        let size = self.base.size
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        //开始图形上下文
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        //绘制路线
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect,
                                      byRoundingCorners: UIRectCorner.allCorners,
                                      cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        //裁剪
        UIGraphicsGetCurrentContext()!.clip()
        //将原图片画到图形上下文
        self.base.draw(in: rect)
        UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        return output!
      }
    
    /// 修改图片颜色
    func tintImage(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.base.size, _: false, _: 0.0)
        let context = UIGraphicsGetCurrentContext()
        self.base.draw(in: CGRect(x: 0, y: 0, width: self.base.size.width, height: self.base.size.height))
        if let context = context {
            context.setBlendMode(.sourceAtop)
        }
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: self.base.size.width, height: self.base.size.height))
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}


public extension WPPOP where Base == UIImage {
    static func jianBian(colors:[CGColor], size:CGSize)->UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let colorspace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context:CGContext = UIGraphicsGetCurrentContext(),
              let gradient:CGGradient = CGGradient(colorsSpace: colorspace, colors: colors as CFArray, locations: nil) else { return nil }
        
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    static func jianBianLeftToRight(colors:[CGColor], size:CGSize)->UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let colorspace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context:CGContext = UIGraphicsGetCurrentContext(),
              let gradient:CGGradient = CGGradient(colorsSpace: colorspace, colors: colors as CFArray, locations: nil) else { return nil }
        
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: 0), options: [])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    static func jianBianLeftTopToRightBottom(colors:[CGColor], size:CGSize)->UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
         
        let colorspace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context:CGContext = UIGraphicsGetCurrentContext(),
              let gradient:CGGradient = CGGradient(colorsSpace: colorspace, colors: colors as CFArray, locations: nil) else { return nil }
        
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 114.0, y: size.height), options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}



