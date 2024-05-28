//
//  WPLoginController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

class WPLoginController: WPBaseController,WPHiddenNavigationDelegate {
    
    class func createLoginController()->WPNavigationController {
        let login = WPLoginController()
        let navigationController = WPNavigationController(rootViewController: login)
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        makeAction()
    }
    
    lazy var loginView: WPLoginView = {
        var loginView: WPLoginView = WPLoginView(frame: .zero)
        view.addSubview(loginView)
        return loginView
    }()
}

extension WPLoginController {
    func initSubViews() -> Void {
        loginView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    func makeAction() -> Void {
        loginView.closeBlock = .some({ [weak self]in
            guard let weakSelf = self else { return  }
            weakSelf.dismiss(animated: true)
        })
        
        loginView.logionBlock = .some({ [weak self]in
            guard let weakSelf = self else { return  }
            weakSelf.dismiss(animated: true) {
                NotificationCenter.default.post(name: .init("LoginOK"), object: nil)
            }
        })
    }
}


