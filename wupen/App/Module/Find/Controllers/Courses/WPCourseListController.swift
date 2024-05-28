//
//  WPCourseListController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/4.
//

import UIKit

class WPCourseListController: WPBaseController,WPHiddenNavigationDelegate {
    private var pageNum:Int = 1
    private var keyword:String?
    private var timeAsc:Bool=true
    private var series:[Int]?=nil
    private var classifications:[String]?=nil
    
    // 系列课程进入
    var model:WPCouserModel?
    
    deinit {
        WPPlayerManager.default.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        WPPlayerManager.default.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeLoadMore()
        makeSubviews()
        makeConstraints()
    }
    
    lazy var menuCheckView: WPMenuCheckView = {
        var menuCheckView: WPMenuCheckView = WPMenuCheckView(.cause) {[weak self] searchText in
            guard let weakSelf = self else { return }
            weakSelf.pageNum = 1
            weakSelf.keyword = searchText?.wp.trim()
            weakSelf.loadDatas()
            weakSelf.view.endEditing(true)
        }
        menuCheckView.textDidBeginEditingBlock = .some({[weak self]  in
            guard let weakSelf = self else { return }
            weakSelf.menuItemListView.hidden()
        })
        menuCheckView.checkSequenceBlock = .some({[weak self] aes in
            guard let weakSelf = self else { return }
            weakSelf.pageNum = 1
            weakSelf.timeAsc = aes
            weakSelf.loadDatas()
            weakSelf.view.endEditing(true)
        })
        menuCheckView.checkCouresBlock = .some({[weak self] index in
            guard let weakSelf = self else { return }
            weakSelf.view.endEditing(true)
            
            if index == 0{
                weakSelf.menuItemListView.datas = menuCheckView.courseClassDatas
            } else {
                weakSelf.menuItemListView.datas = menuCheckView.courseSeriesDatas
            }
            
            if (weakSelf.menuItemListView.datas?.count ?? 0) > 0 && menuCheckView.currentButon.isSelected  {
                weakSelf.menuItemListView.show(view: weakSelf.view)
                
            } else {
                weakSelf.menuItemListView.hidden()
            }
        })
        view.addSubview(menuCheckView)
        return menuCheckView
    }()
    
    lazy var menuItemListView: WPMenuItemListView = {
        var menuItemListView: WPMenuItemListView = WPMenuItemListView()
        menuItemListView.hiddenBlock = .some({[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.menuCheckView.currentButon.isSelected = false
        })
        menuItemListView.didSelectedBlock = .some({[weak self]  model in
            guard let weakSelf = self else { return }
            weakSelf.menuCheckView.selectedModel = model
            
            if let model:WPClassificationsModel = model as? WPClassificationsModel {
                weakSelf.pageNum = 1
//                weakSelf.series = nil
                weakSelf.classifications = [model.id]
                weakSelf.loadDatas()
                
            } else if let model:WPCouserModel = model as? WPCouserModel {
                weakSelf.pageNum = 1
//                weakSelf.classifications = nil
                if let x = model.id , let series = Int(x) {
                    weakSelf.series = [series]
                }
                weakSelf.loadDatas()
            }
        })
        view.addSubview(menuItemListView)
        return menuItemListView
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset.left = 0
        flowLayout.sectionInset.right = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: WPScreenWidth, height: 106)
        
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPCourseListCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset.top = 12.0
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var emptyView: UIView = {
        var emptyView: UIView = createEmptyView("",icon: "comm_empty_icon")
        view.insertSubview(emptyView, at: 0)
        return emptyView
    }()
    
    lazy var datas: [WPCouserModel] = {
        return []
    }()
}

extension WPCourseListController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WPScreenWidth, height: 106)
    }
}

extension WPCourseListController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc:WPCourseDetailController = WPCourseDetailController()
        let model = self.datas[indexPath.row]
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
        WPUmeng.um_event_course_ClickRecommendation(model.lectureId)
    }
}

extension WPCourseListController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return WPCourseListCell.collectionViewWithCell(collectionView, indexPath: indexPath, datas: self.datas)
    }
}

extension WPCourseListController {
    func makeSubviews() {
        if let model = self.model {
            self.menuCheckView.defaultModel = model
            if let x = model.id , let series = Int(x) {
                self.series = [series]
            }
        }
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
        let footer:MJRefreshAutoNormalFooter  = MJRefreshAutoNormalFooter.init {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.loadDatas()
        }
        footer.setTitle("emm，好像没有数据了～", for: .noMoreData)
        footer.stateLabel?.textColor = rgba(112,112,112,0.8)
        footer.stateLabel?.font = .systemFont(ofSize: 12)
        self.collectionView.mj_footer = footer
        footer.isHidden = true
    }
}

extension WPCourseListController {
    func loadDatas() -> Void {
        WPSearchModel.search(pageNum: self.pageNum,keyword: self.keyword, timeAsc: self.timeAsc, classifications:self.classifications, series: self.series) {[weak self] model in
            guard let weakSelf = self else { return  }
            weakSelf.collectionView.mj_footer?.endRefreshing()
            if weakSelf.pageNum <= 1 {
                weakSelf.collectionView.mj_footer?.isHidden = false
                weakSelf.collectionView.mj_footer?.resetNoMoreData()
                weakSelf.datas.removeAll()
            }
            
            if model.jsonModel?.code == 200 {  weakSelf.pageNum += 1 }
            if let list: [WPCouserModel] = model.jsonModel?.data as? [WPCouserModel]  {
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
