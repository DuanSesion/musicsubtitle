//
//  WPMeController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

class WPMeController: WPBaseController,WPHiddenNavigationDelegate {
    var isExpend:Bool = false
    var headerView:WPMeHeaderView?
    var calendarCell :WPMeCalendarCell?
    
    var now:Date = Date.jk.currentDate.nowToLocalDate()
    var currentDate:Date = Date.jk.currentDate.nowToLocalDate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentDate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNotificationCenter()
        makeSubviews()
        makeConstraints()
        loadData()
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = WPEqualCellSpaceFlowLayout()
        flowLayout.cellType = .center
        flowLayout.sectionInset.left = 10
        flowLayout.sectionInset.right = 10
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.betweenOfCell = 0
        
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        WPMeBaseCell.register(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        return collectionView
    }()
    
//    lazy var mycollects: [WPLiveModel] = {//所有收藏
//        return []
//    }()
    
    lazy var datas: [WPLiveModel] = {//指定日期的收藏
        return []
    }()
}








