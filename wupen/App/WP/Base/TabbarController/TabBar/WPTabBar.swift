//
//  WPTabBar.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/26.
//

import UIKit

class WPTabBar: UITabBar {

    override class var layerClass: AnyClass {
        return CAShapeLayer.classForCoder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.button.frame = CGRect(x: 0, y: 0, width: self.itemWidth, height: 62)
        self.button.centerX = self.centerX
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.unselectedItemTintColor = rgba(61, 69, 80, 1)
        self.barStyle = .default
        self.backgroundColor = .clear
        self.isTranslucent = true
        self.shadowImage = UIImage.wp.createColorImage(.clear)
        self.itemPositioning = .centered

        self.itemWidth = (WPScreenWidth - 30)/3
        self.itemSpacing = 5
        
        if let layer:CAShapeLayer = self.layer as? CAShapeLayer {
            layer.shadowOffset = .init(width: -1, height: -2)
            layer.shadowColor = rgba(225, 241, 255, 0.50).cgColor
            layer.shadowRadius = 5
            layer.shadowOpacity = 1
            layer.backgroundColor = UIColor.white.cgColor
            //layer.cornerRadius = 31
        }
    }
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.rx.tap.subscribe(onNext: { [weak self] recognizer in
            let vc:WPAIController = WPAIController()
            let nav:WPNavigationController = WPNavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            WPKeyWindowDev?.rootViewController?.present(nav, animated: true)
            WPUmeng.um_event_AIWUS_Access(false)
            
        }).disposed(by: disposeBag)
        self.addSubview(button)
        return button
    }()
 
}
