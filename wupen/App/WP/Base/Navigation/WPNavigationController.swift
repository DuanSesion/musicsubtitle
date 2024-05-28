//
//  WPNavigationController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

// MARK: 隐藏导航图界面 使用此协议
public protocol WPHiddenNavigationDelegate : NSObjectProtocol { }
public protocol WPNotPanGestureRecognizerDelegate : NSObjectProtocol {}

class WPNavigationController: UINavigationController {
    var nextBarTintColor:UIColor = rgba(235, 235, 235)
    var barTintColor:UIColor = .clear
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    lazy var pan:UIPanGestureRecognizer = {
        var pan:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self.interactivePopGestureRecognizer?.delegate, action: #selector(handleNavigationTransition(_ :)))
        pan.delegate = self
        return pan
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addPan()
    }
}

extension WPNavigationController {
    func setUI() -> Void {
        self.delegate = self
        self.view.backgroundColor = rgba(245, 245, 245)
        
        let app = UINavigationBarAppearance()
        app.configureWithOpaqueBackground()  // 重置背景和阴影颜色
        app.titleTextAttributes = [
           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
           NSAttributedString.Key.foregroundColor: rgba(51, 51, 51, 1)
        ]
 
        app.backgroundColor = .clear
        app.shadowColor = .clear
        app.backgroundImage = UIImage.wp.createColorImage(.clear, size: CGSize(width: WPScreenWidth, height: 44.0))
 
        let backImage = UIImage(named: "nav_back")?.withRenderingMode(.alwaysOriginal)
        app.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
 
        self.navigationBar.scrollEdgeAppearance = app
        self.navigationBar.standardAppearance = app
    }
    
    @objc func handleNavigationTransition(_ pan:UIPanGestureRecognizer)->Void {
        if pan.state == .ended {
           self.popViewController(animated: true)
        }
    }
    
    func addPan() -> Void {
        //注销系统方法
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.view.addGestureRecognizer(self.pan)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if ((self.children.count) != 0) {
             viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension WPNavigationController:UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is WPHiddenNavigationDelegate {
            navigationController.setNavigationBarHidden(true, animated: true)
            
        } else if viewController is WPHiddenNavigationDelegate == false {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
        navigationController.navigationBar.backItem?.backButtonTitle = ""
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backButtonTitle = ""
        navigationController.navigationBar.backItem?.backButtonTitle = ""
        if viewController is WPNotPanGestureRecognizerDelegate {
            self.pan.isEnabled = false
            
        } else {
            self.pan.isEnabled = true
        }
    }
}


extension UINavigationController:UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.children.count == 1 {
            return false
        }
        let translation:CGPoint  = gestureRecognizer.location(in: self.view)
        return (translation.x <= 45)
    }
}
