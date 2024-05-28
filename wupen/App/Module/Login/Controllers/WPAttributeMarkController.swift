//
//  WPAttributeMarkController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

class WPAttributeMarkController: WPBaseController,WPHiddenNavigationDelegate {
    
    class func createMarkController()->WPNavigationController {
        let mark = WPAttributeMarkController()
        let navigationController = WPNavigationController(rootViewController: mark)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        makeAction()
    }
   
    lazy var markView: WPAttributeMarkView = {
        var markView: WPAttributeMarkView = WPAttributeMarkView(frame: .zero)
        view.addSubview(markView)
        return markView
    }()
    
    lazy var interestMarkView: WPInterestMarkView = {
        var interestMarkView: WPInterestMarkView = WPInterestMarkView(frame: .zero)
        interestMarkView.isHidden = true
        view.addSubview(interestMarkView)
        return interestMarkView
    }()
    
    var year:[String] = []
    var interests:[String] = []
}


extension WPAttributeMarkController {
    func setUI() -> Void {
        self.view.backgroundColor = .white
        interestMarkView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        markView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    func makeAction() -> Void {
        markView.closeBlock = .some({ [weak self]in
            guard let weakSelf = self else { return  }
            weakSelf.dismiss(animated: true)
        })
        
        markView.nextBlock = .some({ [weak self] datas in
            guard let weakSelf = self else { return  }
            weakSelf.markView.isHidden = true
            weakSelf.interestMarkView.isHidden = false
            weakSelf.year = datas
        })
        
        interestMarkView.closeBlock = .some({ [weak self]in
            guard let weakSelf = self else { return  }
            weakSelf.dismiss(animated: true)
        })
        
        interestMarkView.finishBlock = .some({ [weak self] datas in
            guard let weakSelf = self else { return  }
            weakSelf.interests = datas
            weakSelf.save()
        })
    }
}

extension WPAttributeMarkController {
    func save() -> Void {
        var datas:[String] = self.year
        datas.append(contentsOf: self.interests)
        
        let ss = datas.joined(separator: "，")
        debugPrint(ss)
        
        self.view.showUnityNetActivity()
        WPUser.userSaveMark(marks: ss) {[weak self] model in
            guard let weakSelf = self else { return  }
            weakSelf.view.removeNetActivity()
            if model.jsonModel?.code == 200 {
                weakSelf.dismiss(animated: true)
                NotificationCenter.default.post(name: .init("markFinish"), object: nil)
                
            } else {
                weakSelf.view.showError(model.jsonModel?.msg ?? model.msg)
            }
        }
    }
}
