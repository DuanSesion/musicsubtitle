//
//  WPFindeCell3.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPFindeCellScrollView:UIScrollView,UIGestureRecognizerDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isMultipleTouchEnabled = true
        self.delaysContentTouches = true
        self.canCancelContentTouches = true
        self.isDirectionalLockEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.scrollsToTop = true
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       return false
    }
}
 

class WPFindeCell3: UICollectionViewCell {
    private var currentVC:WPFindCourseController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubviews()
        makeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pagingContentView.isHidden = false
        if self.currentVC == nil {
            if let currentVC = self.chirlds.first {
                currentVC.view.frame = .init(origin: .zero, size: pagingContentView.size)
                pagingContentView.addSubview(currentVC.view)
            }
        }
    }
    
    lazy var titles: [String] = {
        return ["最热"]
    }()
    
    lazy var pagingTitleView: SGPagingTitleView = {
        let config = SGPagingTitleViewConfigure()
        config.indicatorType = .Cover
        config.color = rgba(102, 102, 102, 1)
        config.selectedColor = rgba(255, 62, 20, 1)
        config.font = .boldSystemFont(ofSize: 13)
        config.selectedFont = .boldSystemFont(ofSize: 13)
        config.showBottomSeparator = false
        config.equivalence = false
        config.showIndicator = true
        config.indicatorHeight = 5
        config.indicatorToBottomDistance = 0
        config.itemSelectedColor = rgba(246, 236, 220, 1)
        config.radues = 14
        //config.indicatorImg = UIImage.wp.createColorImage(.yellow, size: CGSize(width: 16, height: 4))
        
        var pagingTitleView: SGPagingTitleView = SGPagingTitleView(frame: CGRect(origin: .init(x: 0, y: 15), size: CGSize(width: WPScreenWidth-32, height: 28)), titles:titles , configure:config )
        
        pagingTitleView.backgroundColor = .clear
        pagingTitleView.delegate = self
        
        pagingTitleView.setImage(name: "hot_light_icon", location: .left, spacing: 3, index: 0)
        contentView.addSubview(pagingTitleView)
        return pagingTitleView
    }()
    
    lazy var chirlds: [WPFindCourseController] = {
        var chirlds: [WPFindCourseController] = []
        for (i, _) in titles.enumerated() {
            let vc = WPFindCourseController()
            chirlds.append(vc)
            if  let parentVC = self.yy_viewController {
                parentVC.addChild(vc)
            }
        }
        return chirlds
    }()
    
    lazy var pagingContentView: WPFindeCellScrollView = {
        let fr = CGRect(origin: .init(x: 0, y: 32+16), size: CGSize(width: WPScreenWidth, height: 360+20))
        var pagingContentView: WPFindeCellScrollView = WPFindeCellScrollView(frame: fr)
        pagingContentView.isUserInteractionEnabled = true
        pagingContentView.backgroundColor = .clear
        pagingContentView.delegate = self
        pagingContentView.bounces = false
        pagingContentView.isPagingEnabled = true
        pagingContentView.isUserInteractionEnabled = true
        pagingContentView.contentSize = .init(width: WPScreenWidth*CGFloat(chirlds.count), height: 360+20)
        pagingContentView.showsVerticalScrollIndicator = false
        pagingContentView.showsHorizontalScrollIndicator = false
        contentView.addSubview(pagingContentView)
        return pagingContentView
    }()
    
    var course:WPFindeCellModel!{
        didSet {
            if course.pageTitles.count != self.titles.count && course.currentChirds.count > 0 {
                self.chirlds.removeAll()
                self.chirlds.append(contentsOf: course.currentChirds)
                
                self.titles.removeAll()
                self.titles.append(contentsOf: course.pageTitles)
                pagingTitleView.resetTitles = self.titles
                
                pagingContentView.contentSize = .init(width: WPScreenWidth*CGFloat(self.titles.count), height: 360+20)
            }
        }
    }
}

extension WPFindeCell3 :SGPagingTitleViewDelegate{
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        if  index < self.chirlds.count {
            pagingContentView.setContentOffset(CGPoint(x: CGFloat(index)*WPScreenWidth, y: 0), animated: false)
            let currentVC = self.chirlds[index]
            currentVC.view.frame = .init(origin: .init(x: WPScreenWidth * CGFloat(index), y: 0), size: pagingContentView.size)
            pagingContentView.addSubview(currentVC.view)
            currentVC.toucheEvent()
            
            if self.currentVC != currentVC {
                self.currentVC = currentVC
            }
            
            if index == 0 {
                pagingTitleView.setImage(name: "hot_light_icon", location: .left, spacing: 3, index: 0)
            } else {
                pagingTitleView.setImage(name: "hot_gay_icon", location: .left, spacing: 3, index: 0)
            }
        }
    }
}

extension WPFindeCell3:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/WPScreenWidth)
        if  index < self.chirlds.count {
            let currentVC = self.chirlds[index]
            currentVC.view.frame = .init(origin: .init(x: pagingContentView.width * CGFloat(index), y: 0), size: pagingContentView.size)
            pagingContentView.addSubview(currentVC.view)
            if self.currentVC != currentVC {
                self.currentVC = currentVC
                pagingTitleView.reset(index: index)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/WPScreenWidth)
        if  index < self.chirlds.count {
            let currentVC = self.chirlds[index]
            
            currentVC.view.frame = .init(origin: .init(x: pagingContentView.width * CGFloat(index), y: 0), size: pagingContentView.size)
            pagingContentView.addSubview(currentVC.view)
            
            if self.currentVC != currentVC {
                self.currentVC = currentVC
                pagingTitleView.reset(index: index)
            }
        }
    }
}

extension WPFindeCell3 {
    func makeSubviews() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
    }
    
    func makeConstraints() -> Void {
        pagingTitleView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(WPScreenWidth-16)
            make.height.equalTo(28)
            make.top.equalToSuperview().offset(5)
        }
        
        let fr = CGRect(origin: .init(x: 0, y: 48), size: CGSize(width: WPScreenWidth, height: 360+20))
        pagingContentView.frame = fr
    }
}
