//
//  WPBaseController\.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

class WPBaseController: UIViewController,RainbowColorSource {
    lazy var rainbowNavigation = RainbowNavigation()
    var navColor:UIColor = rgba(245, 245, 245, 1)
    
    deinit {  debugPrint("---init---", self) }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom
        self.view.backgroundColor = rgba(245, 245, 245, 1)
        setNavColor(navColor)
    }
    
    func setNavColor(_ color:UIColor) -> Void {
        self.navColor = color
        navigationController?.navigationBar.rb.backgroundColor = navColor
        navigationController?.navigationBar.rb.statusBarColor = navColor
        
        if let navigationController = navigationController {
            rainbowNavigation.wireTo(navigationController: navigationController)
        }
    }
}
extension WPBaseController {
    func createEmptyView(_ text:String = "没有查询到内容，换个词试试", icon:String="search_empty_icon") -> UIView {
        let emptyView = UIView()
        emptyView.isHidden = true
        let icon: UIImageView = UIImageView(image: .init(named: icon))
        icon.contentMode = .scaleAspectFit
        emptyView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 225, height: 143))
        }

        let label: UILabel = UILabel()
        label.text = text
        label.textColor = rgba(146, 147, 147, 1)
        label.textAlignment = .left
        label.tag = 100
        label.font = .systemFont(ofSize: 12)
        emptyView.addSubview(label)

        label.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(18)
        }
        return emptyView
    }
}


extension WPBaseController {
    public func presentToMarkController() -> Void {
        if UIViewController.wp.TopViewController(base: WPKeyWindowDev?.rootViewController) is WPAttributeMarkController == false {
            let markController = WPAttributeMarkController.createMarkController()
            WPKeyWindowDev?.rootViewController?.present(markController, animated: true)
        }
    }
    
   public func presentToLoginController() -> Void {
        if UIViewController.wp.TopViewController(base: WPKeyWindowDev?.rootViewController) is WPLoginController == false {
            let loginController = WPLoginController.createLoginController()
            WPKeyWindowDev?.rootViewController?.present(loginController, animated: true)
        }
    }
}

