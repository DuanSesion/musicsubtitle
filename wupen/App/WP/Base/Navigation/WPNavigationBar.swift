//
//  WPNavigationBar.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/8.
//

import UIKit

class WPNavigationBar: UINavigationBar {
    var didBackBlock:(()->Void)?
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: WPScreenWidth, height: kNavigationBarHeight))
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
        debugPrint("---init---", self)
    }
    
    override func setBackgroundImage(_ backgroundImage: UIImage?, for barMetrics: UIBarMetrics) {
        self.backgoundImageView.image = backgroundImage
    }
    
    lazy var backgoundImageView: UIImageView = {
        var backgoundImageView: UIImageView = UIImageView()
        backgoundImageView.backgroundColor = .clear
        backgoundImageView.clipsToBounds = true
        self.addSubview(backgoundImageView)
        return backgoundImageView
    }()
    
    lazy var visualEffectView: UIVisualEffectView = {
        var blurEffrct: UIBlurEffect = UIBlurEffect(style: .light)
        var visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: blurEffrct)
        visualEffectView.alpha = 0.0
        visualEffectView.clipsToBounds = true
        self.addSubview(visualEffectView)
        return visualEffectView
    }()
    
    lazy var backButton: UIButton = {
        var backButton: UIButton = UIButton()
        backButton.contentHorizontalAlignment = .left
        backButton.setImage(UIImage(named: "nav_back")?.withTintColor(.white), for: .normal)
        backButton.setImage(UIImage(named: "nav_back"), for: .selected)
        backButton.rx.tap.subscribe(onNext: { [weak self] recognizer in
            self?.didBackBlock?()
            self?.yy_viewController?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        self.addSubview(backButton)
        return backButton
    }()
}

extension WPNavigationBar {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y > 0 {
            let xx = y/self.height
            if xx <= 1 {
                self.visualEffectView.alpha = xx
                backButton.isSelected = true
            }
            
        } else {
            self.visualEffectView.alpha = 0
            backButton.isSelected = false
        }
    }
}

extension WPNavigationBar {
    func setup()->Void {
        self.backgoundImageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        self.visualEffectView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        self.backButton.frame = CGRect(x: 15, y: kStatusBarHeight, width: 25, height: 44)
    }
}
