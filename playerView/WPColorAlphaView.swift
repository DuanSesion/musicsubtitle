//
//  WPColorAlphaViwe.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

// MARK: RGB颜色
func rgba(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat=1) ->UIColor {  return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }

class WPColorAlphaView: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var colors:[CGColor]?{
        didSet {
            if let gradientbglayer = (self.layer as? CAGradientLayer) {
                gradientbglayer.colors = colors
            }
        }
    }
    
    func setup() -> Void {
        self.layer.cornerRadius = 13
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        if let gradientbglayer = (self.layer as? CAGradientLayer) {
            gradientbglayer.colors = [rgba(255, 154, 34, 1).cgColor,rgba(255, 198, 52, 1).cgColor]
            gradientbglayer.locations = [0,1]
            gradientbglayer.startPoint = .zero
            gradientbglayer.endPoint = CGPoint(x: 1, y: 0)
        }
    }
}


