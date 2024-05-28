//
//  WPCourseDetailController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/4.
//

import UIKit

class WPCourseDetailController: WPBaseController,WPHiddenNavigationDelegate {
    let statusBarHeight:CGFloat = kStatusBarHeight // 状态栏高度
    let playerViewHeight:CGFloat = 212.0 // 播放器高度
    let zsHeight:CGFloat = 148.0 // 知识栏高度
    let kcHeight:CGFloat = 65.0 // 课程推荐标题高度
    let infoHeight:CGFloat = 71.0 // 信息栏高度
    var masHeight:CGFloat = 44.0 // 课程标题详细高度 最低spaTo：17  44. 
    
    public var model:WPCouserModel?
    private var couserDetail:WPCouserDetailModel?
    private var pageNum = 1
    private var player:WPLectureVideosModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        self.player?.stop()
        self.player = nil
        WPUmeng.um_event_course_detail_click_back()
        debugPrint("deinit====>",self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let player = self.player {
            if self.player?.video?.id != WPPlayerManager.default.video?.video?.id {
                WPPlayerManager.default.stop()
            }
            WPPlayerManager.default.video = player
            WPPlayerManager.default.playerURL = player.playerURL
            player.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player = WPPlayerManager.default.video
        self.player?.pause()
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player?.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
        makeLoadMore() 
        putLectureVisitors()
    }
    
    lazy var navigationBar: WPNavigationBar = {
        var navigationBar: WPNavigationBar = WPNavigationBar()
        view.addSubview(navigationBar)
        return navigationBar
    }()
    
    lazy var flowLayout: WPEqualCellSpaceFlowLayout = {
        let flowLayout = WPEqualCellSpaceFlowLayout()
        flowLayout.cellType = .left
        flowLayout.sectionInset.left = 16
        //flowLayout.sectionInset.right = 16
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.betweenOfCell = 13
        
        let height = statusBarHeight + playerViewHeight + zsHeight + kcHeight + masHeight + infoHeight
        flowLayout.headerReferenceSize = .init(width: WPScreenWidth, height:  height)
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPCourseDetailCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(WPCourseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(WPMeFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var emptyView: UIView = {
        var emptyView: UIView = createEmptyView("")
        view.insertSubview(emptyView, at: 0)
        return emptyView
    }()
    
    lazy var datas: [WPCouserModel] = {
        return []
    }()
}

extension WPCourseDetailController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationBar.scrollViewDidScroll(scrollView)
        if navigationBar.backButton.isSelected {
            navigationBar.width = WPScreenWidth
        } else {
            navigationBar.width = WPScreenWidth/2
        }
    }
}

extension WPCourseDetailController:ZDCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (WPScreenWidth - 45)/2, height: 183.0)
    }
    
    func colletionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        heightForFooterInSection section: NSInteger) -> CGFloat {
        return 16.0
    }
    
    func colletionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        heightForHeaderInSection section: NSInteger) -> CGFloat {
        return  flowLayout.headerReferenceSize.height
    }
}

extension WPCourseDetailController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let v = WPCourseHeaderView.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        if let headerView:WPCourseHeaderView = v as? WPCourseHeaderView {
            headerView.couserDetail = self.couserDetail
            headerView.updateHeigtBlock = .some({[weak self] height in
                self?.flowLayout.headerReferenceSize = .init(width: WPScreenWidth, height: height)
                collectionView.performBatchUpdates {}
            })
        }
       return v
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        WPPlayerManager.default.pause()
        self.player = WPPlayerManager.default.video
 
        if datas.count > indexPath.row {
            let model = datas[indexPath.row]
            let vc = WPCourseDetailController()
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
            WPUmeng.um_event_course_ClickRecommendation(model.lectureId)
        }
    }
}

extension WPCourseDetailController:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WPCourseDetailCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WPCourseDetailCell
        if datas.count > indexPath.row {
            cell.model = datas[indexPath.row]
        }
        return cell
    }
}

extension WPCourseDetailController {
    func makeSubviews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245)
        loadDatas()
    }
    
    func makeConstraints() -> Void {
        emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-190)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        navigationBar.frame = CGRect(x: 0, y: 0, width: WPScreenWidth/2, height: kNavigationBarHeight)
    }
    
    func makeLoadMore() -> Void {
        let footer:MJRefreshAutoNormalFooter  = MJRefreshAutoNormalFooter.init {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.pageNum += 1
            weakSelf.loadaSeriaDatas()
        }
        footer.setTitle("emm，好像没有数据了～", for: .noMoreData)
        footer.stateLabel?.textColor = rgba(112,112,112,0.8)
        footer.stateLabel?.font = .systemFont(ofSize: 12)
        self.collectionView.mj_footer = footer
        footer.isHidden = true
    }
}

extension WPCourseDetailController {
    func loadDatas() -> Void {// 详情
        self.collectionView.mj_footer?.endRefreshing()
        model?.checkCouserDetail({[weak self] resp, des in
            guard let weakSelf = self else { return  }
            des?.couser = weakSelf.model
            weakSelf.couserDetail = des
            weakSelf.collectionView.reloadData()
            if resp.jsonModel?.code != 200 {
                weakSelf.view.showMessage(resp.jsonModel?.msg ?? resp.msg)
            }
            
            weakSelf.loadaSeriaDatas()
            WPUmeng.um_event_course_JoinStudyCount((des?.lecture?.learnNums ?? 0))
        })
    }
    
    func putLectureVisitors() -> Void {//看课程人数累计
        guard let LectureID = self.model?.lectureId else {return}
        WPSearchModel.putLectureVisitors(LectureID) {mode in
//            guard let weakSelf = self else { return  }
//            if mode.jsonModel?.success == true {
//                //weakSelf.model?.learnNums =  (weakSelf.model?.learnNums ?? 0) + 1
//            }
        }
    }
    
    func loadaSeriaDatas() -> Void {//推荐课程
        var tags:[String]? = nil
        if let tagstr = self.model?.tags{//首页课程系列进入首页
            if tagstr.isEmpty == false {
                tags = [tagstr]
            }
        }
        
        var classifications:[String]? = nil
        if let classifs = self.model?.classification {//首页课程进入首页
            classifications = [classifs]
        }
 
        WPSearchModel.search(pageNum: self.pageNum,timeAsc: true, classifications: classifications, tags:tags) {[weak self] model in
                guard let weakSelf = self else { return  }
                weakSelf.collectionView.mj_footer?.endRefreshing()
                if weakSelf.pageNum <= 1 {
                    weakSelf.collectionView.mj_footer?.isHidden = false
                    weakSelf.collectionView.mj_footer?.resetNoMoreData()
                    weakSelf.datas.removeAll()
                }
            
                if model.jsonModel?.code != 200 &&  weakSelf.pageNum > 1 {  weakSelf.pageNum -= 1 }
            
                var resultDatasCount:Int = 0
                if var list: [WPCouserModel] = model.jsonModel?.data as? [WPCouserModel]  {
                    resultDatasCount = list.count
                    
                    list.removeAll { mo in
                        return mo.lectureId == weakSelf.model?.lectureId
                    }
                    weakSelf.datas.append(contentsOf: list)
                }
                weakSelf.collectionView.reloadData()
            
                let totalElements = (model.jsonModel?.totalElements ?? 0)
                weakSelf.emptyView.isHidden = true
                if weakSelf.datas.count == totalElements && totalElements == 0 {
                    weakSelf.collectionView.mj_footer?.isHidden = true
                    weakSelf.emptyView.isHidden = false
    
                } else if weakSelf.datas.count >= totalElements {
                    weakSelf.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                    weakSelf.collectionView.mj_footer?.isHidden = (totalElements <= 10)
    
                } else {
                    if resultDatasCount < 10 && weakSelf.datas.count > 0 && totalElements > 10 {
                        weakSelf.collectionView.mj_footer?.isHidden = false
                        weakSelf.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                        
                    } else {
                        weakSelf.collectionView.mj_footer?.resetNoMoreData()
                        weakSelf.collectionView.mj_footer?.isHidden = false
                    }
                }
        }
    }
}
