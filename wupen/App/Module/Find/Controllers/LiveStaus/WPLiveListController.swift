//
//  WPLiveListController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/7.
//

import UIKit

class WPLiveListController: WPBaseController,WPHiddenNavigationDelegate {
    private var pageNum:Int = 1
    private var keyword:String?
    private var status:Int?
    private var timeAsc:Bool=true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLoadMore()
        makeSubviews()
        makeConstraints()
    }
    
    lazy var menuCheckView: WPMenuCheckView = {
        var menuCheckView: WPMenuCheckView = WPMenuCheckView(.live) {[weak self] searchText in
            guard let weakSelf = self else { return }
            weakSelf.pageNum = 1
            weakSelf.keyword = searchText?.wp.trim()
            weakSelf.loadDatas()
        }
        
        menuCheckView.liveBlock = .some({[weak self] liveType in
            guard let weakSelf = self else { return }
            weakSelf.pageNum = 1
            
            if liveType == .wait {
                weakSelf.status = 0
                
            } else if liveType == .end {
                weakSelf.status = 1
                
            } else {
                weakSelf.status = nil
            }
            weakSelf.loadDatas()
        })
        
 
        menuCheckView.checkSequenceBlock = .some({[weak self] aes in
            guard let weakSelf = self else { return }
            weakSelf.pageNum = 1
            weakSelf.timeAsc = aes
            weakSelf.loadDatas()
        })
        
        view.addSubview(menuCheckView)
        return menuCheckView
    }()

    
    lazy var collectionView: UICollectionView = {
        let flowLayout = ZDCollectionViewWaterfallLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.columnCount = 2
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPLiveListCell.self, forCellWithReuseIdentifier: "WPLiveListCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.top = 18
        view.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var emptyView: UIView = {
        var emptyView: UIView = createEmptyView("",icon: "comm_empty_icon")
        view.insertSubview(emptyView, at: 0)
        return emptyView
    }()
    
    lazy var datas: [WPLiveModel] = {
        return []
    }()
}

extension WPLiveListController:ZDCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if datas.count > indexPath.row {
          let model = datas[indexPath.row ]
            return CGSize(width: (WPScreenWidth - 45)/2, height: model.cellHeight)
        }
        return  CGSize(width: (WPScreenWidth - 45)/2, height: 219.0)
    }
    
    func colletionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        heightForFooterInSection section: NSInteger) -> CGFloat {
        return 16.0
    }
}

extension WPLiveListController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if datas.count > indexPath.row {
          let model = datas[indexPath.row ]
            let vc:WPLiveStatusController = WPLiveStatusController()
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension WPLiveListController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WPLiveListCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "WPLiveListCell", for: indexPath) as! WPLiveListCell
        if datas.count > indexPath.row {
            let model = datas[indexPath.row ]
            cell.model = model
        }
        return cell
    }
}

extension WPLiveListController {
    func makeSubviews() {
        loadDatas()
    }
    
    func makeConstraints() -> Void {
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        menuCheckView.snp.makeConstraints { make in
            make.width.left.top.equalToSuperview()
            make.height.equalTo(kNavigationBarHeight + 44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(menuCheckView.snp.bottom)
        }
    }
    
    func makeLoadMore() -> Void {
        let footer = MJRefreshAutoNormalFooter.init {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.loadDatas()
        }
        footer.setTitle("emm，好像没有数据了～", for: .noMoreData)
        footer.stateLabel?.textColor = rgba(112,112,112,0.8)
        footer.stateLabel?.font = .systemFont(ofSize: 12)
        collectionView.mj_footer = footer
        footer.isHidden = true
    }
}


extension WPLiveListController {
    func loadDatas() -> Void {
        WPSearchModel.searchLive(pageNum: pageNum, keyword: self.keyword, status:self.status, timeAsc: self.timeAsc) {[weak self] model in
            guard let weakSelf = self else { return  }
            weakSelf.collectionView.mj_footer?.endRefreshing()
            if weakSelf.pageNum <= 1 {
                weakSelf.collectionView.mj_footer?.isHidden = false
                weakSelf.collectionView.mj_footer?.resetNoMoreData()
                weakSelf.datas.removeAll()
            }
            
            if model.jsonModel?.code == 200 {  weakSelf.pageNum += 1 }
           
            if let list: [WPLiveModel] = model.jsonModel?.data as? [WPLiveModel]  {
                weakSelf.datas.append(contentsOf: list)
            }
            weakSelf.collectionView.reloadData()
            
            let totalElements = (model.jsonModel?.totalElements ?? 0)
            if weakSelf.datas.count == totalElements && totalElements == 0 {
                weakSelf.collectionView.mj_footer?.isHidden = true
                
            } else if weakSelf.datas.count == totalElements {
                weakSelf.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                weakSelf.collectionView.mj_footer?.isHidden = (totalElements < 10)
                
            } else {
                weakSelf.collectionView.mj_footer?.resetNoMoreData()
                weakSelf.collectionView.mj_footer?.isHidden = false
            }
            weakSelf.emptyView.isHidden = !(weakSelf.datas.count == 0)
        }
    }
}
