//
//  SubtitleLabel.swift
//  player
//
//  Created by 栾昊辰 on 2024/5/24.
//

import UIKit

class SubtitleLabel: UILabel {

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
    
    func setup() -> Void {
        self.layer.cornerRadius = 0.5
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        if let gradientbglayer = (self.layer as? CAGradientLayer) {
            gradientbglayer.colors = [rgba(255, 1, 34, 1).cgColor,rgba(255, 198, 52, 0.9).cgColor]
            gradientbglayer.locations = [0,1]
            gradientbglayer.startPoint = .zero
            gradientbglayer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
}
