//
//  WPFindPageController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPFindPageController: WPBaseController {
    public var currentIndex:Int = 0
    
    //MARK:  banner 数据管理
     var topModel = WPFindeCellModel()
    //MARK:  最近直播 数据管理
     var recentLive = WPFindeCellModel()
    //MARK:  课程分类 数据管理
     var course = WPFindeCellModel()
    //MARK:  系列课程 数据管理
     var courseSeries = WPFindeCellModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentLive.starAnimationBlock?()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
        addRefreshHeader()
        loadDatas()
    }
    
    lazy var tableHeaderView: WPFindTopBannerView = {
        var tableHeaderView: WPFindTopBannerView = WPFindTopBannerView()
        return tableHeaderView
    }()

    lazy var collectionView: UICollectionView = {//
        let flowLayout = UICollectionViewFlowLayout() //WPEqualCellSpaceFlowLayout()
//        flowLayout.cellType = .center
//        flowLayout.sectionInset.left = 0
//        flowLayout.sectionInset.right = 0
//        flowLayout.minimumInteritemSpacing = 13
//        flowLayout.minimumLineSpacing = 16
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        flowLayout.betweenOfCell = 13
        
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        self.register(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var datas: [WPFindeCellModel] = {
        return WPFindeCellModel.findeCellModels {[weak self] model1, model2, model3, model4 in
            self?.topModel = model1
            self?.recentLive = model2
            self?.course = model3
            self?.courseSeries = model4
        }
    }()
    
    lazy var seriesDatas: [WPCouserModel] = {//系列课程
        return []
    }()
}

extension WPFindPageController {
    func makeSubviews() -> Void {
        self.edgesForExtendedLayout = .top
        self.view.backgroundColor = rgba(245, 245, 245)
        self.view.height = WPScreenHeight - kNavigationBarHeight - 5 - (self.tabBarController?.tabBar.height ?? 0)
        WPUmeng.um_event_find_DiscoverPageEntry(self.currentIndex)
    }
    
    func makeConstraints() -> Void {
        if currentIndex == 0 {
            collectionView.snp.makeConstraints { make in
                make.centerX.bottom.top.equalToSuperview()
                make.width.equalTo(WPScreenWidth)
            }
        }
    }
}
extension WPFindPageController {
    func addRefreshHeader() {
        collectionView.mj_header = WPRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
    }
}

extension WPFindPageController {
   @objc func refreshData() {
       WPLiveModel.checkCollect {mode in}
       collectionView.mj_header?.endRefreshing()
       loadDatas()
    }
}
