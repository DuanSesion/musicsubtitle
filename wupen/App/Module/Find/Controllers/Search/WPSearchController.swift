//
//  WPSearchController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/4.
//

import UIKit

class WPSearchController: WPBaseController,WPHiddenNavigationDelegate,WPNotPanGestureRecognizerDelegate {
    public var pageNum = 1
    private var keyword:String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        WPPlayerManager.default.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
        getHotKeyworld()
        makeLoadMore()
    }
    
    lazy var searchBar: UISearchBar = {
        var searchBar: UISearchBar = UISearchBar(frame: .zero)
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 17
        searchBar.clipsToBounds = true
        searchBar.returnKeyType = .search
        searchBar.searchTextField.font = .systemFont(ofSize: 14)
        searchBar.searchTextField.textColor = rgba(51, 51, 51)
        
        let atr:NSMutableAttributedString = NSMutableAttributedString(string: "搜索")
        atr.yy_font = .systemFont(ofSize: 14)
        atr.yy_color = rgba(136, 136, 136, 1)
        searchBar.searchTextField.attributedPlaceholder = atr
        
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = rgba(51, 51, 51, 1)
        searchBar.setImage(.init(named: "search_clean_button"), for: .clear, state: .normal)
        
        let leftView:UIImageView? = searchBar.searchTextField.leftView as? UIImageView
        leftView?.tintColor = rgba(136, 136, 136, 1)
        
        let size = CGSize(width: WPScreenWidth-76, height: 34)
        let img = UIImage.wp.createColorImage(.white, size: size).wp.roundCorner(17)
        searchBar.setBackgroundImage(img, for: .any, barMetrics: .default)
        
        searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            weakSelf.searchCacheView.isHidden = false
            weakSelf.searchCacheView.update()

        }).disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            weakSelf.searchCacheView.isHidden = true
            
            weakSelf.pageNum = 1
            weakSelf.keyword = searchBar.text?.wp.trim()
            weakSelf.loadDatas(keyword: weakSelf.keyword)

        }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            searchBar.resignFirstResponder()
 
            
            weakSelf.pageNum = 1
            let text = searchBar.text?.wp.trim()
            weakSelf.keyword = text
            weakSelf.searchCacheView.saveHistory(keyWorld:weakSelf.keyword)
            WPUmeng.um_event_find_SearchAndClick(weakSelf.keyword)
 

        }).disposed(by: disposeBag)
        self.view.addSubview(searchBar)
        return searchBar
    }()
    
    lazy var cancleButton: UIButton = {
        var cancleButton: UIButton = UIButton.init(type: .custom)
        cancleButton.setTitle("取消", for: .normal)
        cancleButton.setTitleColor(rgba(168, 171, 181, 1), for: .normal)
        cancleButton.titleLabel?.font = .systemFont(ofSize: 14)
        cancleButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        self.view.addSubview(cancleButton)
        return cancleButton
    }()
    
    lazy var searchCacheView: WPSearchCacheView = {
        var searchCacheView: WPSearchCacheView = WPSearchCacheView()
        searchCacheView.isHidden = false
        searchCacheView.didSelectItemBlock = .some({ [weak self] item in
            guard let weakSelf = self else { return  }
            weakSelf.pageNum = 1
            weakSelf.searchBar.text = item
            weakSelf.keyword = item?.wp.trim()
            searchCacheView.isHidden = true
            weakSelf.searchBar.resignFirstResponder()
            weakSelf.loadDatas(keyword: weakSelf.keyword)
            WPUmeng.um_event_find_SearchAndClick(weakSelf.keyword)
        })
        view.addSubview(searchCacheView)
        return searchCacheView
    }()
    
    lazy var resultLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "“空间规划”的搜索结果，共8条"
        label.textColor = rgba(51, 51, 51, 1)
        label.font = .systemFont(ofSize: 14)
        view.addSubview(label)
        return label
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.setTitleColor(rgba(51, 51, 51, 1), for: .normal)
        button.setTitle("全部(0)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        let im = UIImage.wp.createColorImage(rgba(254, 143, 11, 1), size: CGSize(width: 12, height: 3)).wp.roundCorner(1.5)
        button.setImage(im, for: .normal)
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
 
 
        }).disposed(by: disposeBag)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = ZDCollectionViewWaterfallLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.columnCount = 2
 
        
//        let flowLayout = WPEqualCellSpaceFlowLayout()
//        flowLayout.cellType = .left
//        flowLayout.sectionInset.left = 16
//        //flowLayout.sectionInset.right = 16
//        flowLayout.minimumInteritemSpacing = 10
//        flowLayout.minimumLineSpacing = 10
//        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        flowLayout.betweenOfCell = 10
 
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPSearchCell.self, forCellWithReuseIdentifier: "WPSearchCell")
        collectionView.register(WPSearchCell2.self, forCellWithReuseIdentifier: "WPSearchCell2")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var emptyView: UIView = {
        var emptyView: UIView = createEmptyView()
        view.addSubview(emptyView)
        return emptyView
    }()
    
    lazy var datas: [Convertible] = {
        return []
    }()

    func makeLoadMore() -> Void {
        let footer:MJRefreshAutoNormalFooter  = MJRefreshAutoNormalFooter.init {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.pageNum += 1
            weakSelf.loadDatas(keyword: weakSelf.keyword)
        }
        footer.setTitle("emm，好像没有数据了～", for: .noMoreData)
        footer.stateLabel?.textColor = rgba(112,112,112,0.8)
        footer.stateLabel?.font = .systemFont(ofSize: 12)
        self.collectionView.mj_footer = footer
        footer.isHidden = true
    }
}

extension WPSearchController:ZDCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if datas.count > indexPath.row {
          let model = datas[indexPath.row ]
            if let couser:WPCouserModel = model as? WPCouserModel {
                couser.adjustCellHeight()
                return CGSize(width: (WPScreenWidth - 45)/2, height: couser.cellHeight)
                
                
            } else if let live:WPLiveModel = model as? WPLiveModel {
                live.adjustCellHeight()
                return CGSize(width: (WPScreenWidth - 45)/2, height: live.cellHeight)
            }
        }
        return  CGSize(width: (WPScreenWidth - 45)/2, height: 219.0)
    }
    
    func colletionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        heightForFooterInSection section: NSInteger) -> CGFloat {
        return 16.0
    }
}

extension WPSearchController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if datas.count > indexPath.row {
          let model = datas[indexPath.row ]
            if let couser:WPCouserModel = model as? WPCouserModel {
                let vc:WPCourseDetailController = WPCourseDetailController()
                vc.model = couser
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if let live:WPLiveModel = model as? WPLiveModel {
                let vc:WPLiveStatusController = WPLiveStatusController()
                vc.model = live
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension WPSearchController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WPSearchCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "WPSearchCell", for: indexPath) as! WPSearchCell
        if datas.count > indexPath.row {
            let model = datas[indexPath.row ]
            if let couser:WPCouserModel = model as? WPCouserModel {
                let cell:WPSearchCell2  = collectionView.dequeueReusableCell(withReuseIdentifier: "WPSearchCell2", for: indexPath) as! WPSearchCell2
                cell.model = couser
                return cell
                
            } else if let live:WPLiveModel = model as? WPLiveModel {
                cell.model = live
                return cell
            }
        }
        return cell
    }
}

extension WPSearchController {
    func makeSubviews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245)
        self.edgesForExtendedLayout = .top
        updateResult("-", count: 0)
        WPUmeng.um_event_find_DiscoverSearch()
    }
    
    func makeConstraints() -> Void {
        emptyView.snp.makeConstraints { make in
            make.centerX.width.centerY.equalToSuperview()
       }
        
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(WPScreenWidth-76)
            make.top.equalTo(5+kStatusBarHeight)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.height.centerY.equalTo(searchBar)
            make.right.equalToSuperview()
            make.width.equalTo(60)
        }
    
        collectionView.snp.makeConstraints { make in
            make.left.width.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(99)
        }
        
        searchCacheView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(12)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
            make.top.equalTo(searchBar.snp.bottom).offset(15)
        }
        
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(resultLabel.snp.bottom).offset(16)
        }
        

    }
}
        
extension WPSearchController {
    func updateResult(_ text:String?, count:Int) -> Void {
        var textrString = "\(text ?? "")"
        let countString = "\(count)"
        if textrString.count > 12 {
            let range = textrString.index(textrString.startIndex, offsetBy: 12)
            let subString = String(textrString[..<range])
            textrString = String(subString) + "..."
        }
        
        let atrString = "“\(textrString)”的搜索结果，共\(countString)条"
        let atr = NSMutableAttributedString(string: atrString)
        atr.yy_font = .systemFont(ofSize: 14)
        atr.yy_color = rgba(51, 51, 51, 1)
        atr.yy_setColor(rgba(211, 134, 48), range: NSRange(location: 1, length: textrString.count))
        atr.yy_setColor(rgba(211, 134, 48), range: NSRange(location: atrString.count - 1 - countString.count, length: countString.count))
        resultLabel.attributedText = atr
        
        button.setTitle("全部(\(count))", for: .normal)
        button.jk.setImageTitleLayout(.imgBottom, spacing: 6)
    }
}

extension WPSearchController {
    func loadDatas(keyword:String?) -> Void {
        self.searchCacheView.isHidden = true
        WPSearchModel.commonQuery(pageNum: pageNum, keyword: keyword) {[weak self] model in
            guard let weakSelf = self else { return  }
            weakSelf.updateResult(keyword, count: model?.total ?? 0)
            if weakSelf.pageNum <= 1 {weakSelf.datas.removeAll()}
            
            var datas:[Convertible] = []
            datas.append(contentsOf: model?.lives?.data ?? [])
            datas.append(contentsOf: model?.lectures?.data ?? [])
            weakSelf.datas.append(contentsOf: datas)
            weakSelf.collectionView.reloadData()
            
            let total:Int = (model?.total ?? 0)
            if weakSelf.datas.count == total && total > 0{
                weakSelf.collectionView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                weakSelf.collectionView.mj_footer?.resetNoMoreData()
            }
            
            weakSelf.collectionView.mj_footer?.isHidden = (total == 0)
            weakSelf.emptyView.isHidden = !(weakSelf.datas.count == 0)
        }
    }
    
    func getHotKeyworld(){
        WPSearchModel.getHotKeyworld {[weak self] datas in
            guard let weakSelf = self else { return  }
            weakSelf.searchCacheView.hotkeyworld = datas
        }
    }
}
