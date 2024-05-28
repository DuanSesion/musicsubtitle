//
//  WPTabBarController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

class WPTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeTabBar()
        setup()
        setSplash()
    }
}

 
extension WPTabBarController {
    func makeTabBar() -> Void {
        let tabBar = WPTabBar()
        self.setValue(tabBar, forKeyPath: "tabBar")
        self.tabBar.backgroundImage = UIImage.wp.createColorImage(.white, size: CGSize(width: WPScreenWidth, height: self.tabBar.frame.size.height))
        
//        self.tabBar.backgroundImage = UIImage.wp.createColorImage(.white, size: CGSize(width: 1, height: 1))
//        self.tabBar.unselectedItemTintColor = .darkGray.withAlphaComponent(0.55)
//        self.tabBar.isTranslucent = true
//        self.tabBar.backgroundColor = .clear
//        self.tabBar.barTintColor = .white
    }
     
    func setup() -> Void {
        let datas = WPTabBarModel.tabarModels()
        let unselectedColor = rgba(155, 162, 157, 1)
        let selectedColor = rgba(34, 46, 56, 1)
        let font = UIFont.boldSystemFont(ofSize: 11)
        
        for item in datas {
            let viewController:UIViewController = item.viewController
            
            var image:UIImage? = UIImage(named: item.imageUnSel ?? "")
            var selectedImage:UIImage? = UIImage(named: item.imageSel ?? "")
            let title = item.title
            
            image = image?.withRenderingMode(.alwaysOriginal)
            selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
            
            viewController.tabBarItem = UITabBarItem.init(title: title, image: image, selectedImage: selectedImage)
            let navigation: WPNavigationController = WPNavigationController.init(rootViewController: viewController)
            
            navigation.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:unselectedColor, NSAttributedString.Key.font:font], for: .normal)
            navigation.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:selectedColor, NSAttributedString.Key.font:font], for: .selected)
            
            navigation.tabBarItem.title = title
            navigation.tabBarItem.image = image
            navigation.tabBarItem.selectedImage = selectedImage
            
            self.addChild(navigation)
        }
    }
}

extension WPTabBarController {
    func setSplash() -> Void {
        let splashView = WPSplashView(frame: .zero)
        splashView.show(self.view)
        

        /**

         */
    }
}
