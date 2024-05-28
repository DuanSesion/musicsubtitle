//
//  WPColorAlphaViwe.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

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
                gradientbglayer.endPoint = CGPoint(x: 0, y: 1)
                self.layer.cornerRadius = 0
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
