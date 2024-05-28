//
//  WPFindController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

class WPFindController: WPBaseController,WPHiddenNavigationDelegate {
    var currentVC:WPFindPageController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        WPPlayerManager.default.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNotificationCenter()
        makeSubviews()
        makeConstraints()
        adJsut()
    }
    
    lazy var titles: [String] = {
        return ["发现"]//,"课程","竞赛","论坛"
    }()
    
    lazy var chirlds: [WPFindPageController] = {
        var chirlds: [WPFindPageController] = []
        for (i, _) in titles.enumerated() {
            var vc = WPFindPageController()
            vc.currentIndex = i
            
            vc.didMove(toParent: self)
            self.addChild(vc)
            chirlds.append(vc)
        }
        return chirlds
    }()
    
    lazy var findTopView: WPFindTopView = {
        var findTopView: WPFindTopView = WPFindTopView()
        view.addSubview(findTopView)
        return findTopView
    }()
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let config = SGPagingTitleViewConfigure()
        config.indicatorType = .Dynamic
        config.color = rgba(102, 102, 102, 1)
        config.selectedColor = rgba(51, 51, 51, 1)
        config.font = .boldSystemFont(ofSize: 16)
        config.selectedFont = .boldSystemFont(ofSize: 20)
        config.showBottomSeparator = false
        config.equivalence = false
        config.showIndicator = true
        config.indicatorHeight = 5
        config.indicatorToBottomDistance = 0
        config.indicatorImg = UIImage.wp.createColorImage(rgba(254, 143, 11, 1), size: CGSize(width: 12, height: 4)).wp.roundCorner(2)
        
        var pagingTitleView: SGPagingTitleView = SGPagingTitleView(frame: CGRect(origin: .init(x: 0, y: 15), size: CGSize(width: WPScreenWidth-116, height: 44)), titles:titles , configure:config )
        pagingTitleView.backgroundColor = .clear
        pagingTitleView.delegate = self
        findTopView.addSubview(pagingTitleView)
        return pagingTitleView
    }()
    
    lazy var pagingContentView: SGPagingContentScrollView = {
        let h = (WPScreenHeight - (kNavigationBarHeight+5) - (self.tabBarController?.tabBar.height ?? 0))
        let fr = CGRect(origin: .zero, size: CGSize(width: WPScreenWidth, height: h))
        var pagingContentView: SGPagingContentScrollView = SGPagingContentScrollView(frame: fr, parentVC: self, childVCs:  self.chirlds)
        pagingContentView.backgroundColor = .clear
        pagingContentView.delegate = self
        pagingContentView.isBounces = false
        pagingContentView.isUserInteractionEnabled = true
        view.addSubview(pagingContentView)
        return pagingContentView
    }()
    
    lazy var aiButton: UIButton = {
        var aiButton: UIButton = UIButton()
        aiButton.setImage(.init(named: "ai_button_icon"), for: .normal)
        aiButton.size = .init(width: 104*0.8, height: 98*0.8)
        let panGest:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGest(pan:)))
        aiButton.addGestureRecognizer(panGest)
        aiButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            let vc:WPNavigationController = .init(rootViewController: WPAIController())
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            weakSelf.present(vc, animated: true)
            WPUmeng.um_event_AIWUS_Access(true)
            
        }).disposed(by: disposeBag)
        view.addSubview(aiButton)
        return aiButton
    }()
}

extension WPFindController {
    func makeNotificationCenter() -> Void {
        NotificationCenter.default.rx.notification(.init("LoginOK")).subscribe(onNext: {[weak self]  notice in
            if let user = WPUser.user() {
                let us = user.getFirst(user.userInfo?.userId)
                if  us == nil &&  user.userInfo?.interestTags == nil {
                    self?.presentToMarkController()
                    
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension WPFindController:SGPagingContentViewDelegate {
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func pagingContentView(index: Int) {
        if  index < self.chirlds.count {
            let currentVC = self.chirlds[index]
            if self.currentVC != currentVC {
                self.currentVC = currentVC
                pagingTitleView.reset(index: index)
            }
        }
    }
    
    func pagingContentViewDidScroll() { }
    
    func pagingContentViewWillBeginDragging() {// 内容子视图开始滚动时，不让父视图 tableView 支持多手势
        NotificationCenter.default.post(name: NSNotification.Name(NNSubScrollViewLRScroll), object: false)
    }
    
    func pagingContentViewDidEndDecelerating() {// 内容子视图结束滚动时，让其父视图 tableView 支持多手势
        NotificationCenter.default.post(name: NSNotification.Name(NNSubScrollViewLRScroll), object: true)
    }
}

extension WPFindController:SGPagingTitleViewDelegate {
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        if  index < self.chirlds.count {
            pagingContentView.setPagingContentView(index: index)
        }
    }
}
 

extension WPFindController {
    func makeSubviews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245)
 
        if let currentVC = self.chirlds.first {
            self.currentVC = currentVC
            pagingContentView.resetChirdControllers = self.chirlds
        }
    }

    func makeConstraints() -> Void {
        findTopView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavigationBarHeight+5)
        }
        
        pagingTitleView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(WPScreenWidth-116)
        }
        
        pagingContentView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(pagingTitleView.snp.bottom)
        }
    }
    
    func adJsut() {
        aiButton.right = WPScreenWidth - 4
        aiButton.bottom = pagingContentView.height - 136
    }
}



