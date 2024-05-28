//
//  WPSearchHotView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPSearchHotView: UIView {
    public var didSelectItemBlock:((_ item:String?)->Void)?

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
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.setImage(.init(named: "search_hot_icon"), for: .normal)
        button.setTitleColor(rgba(51, 51, 51, 1), for: .normal)
        button.setTitle("热门搜索", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        addSubview(button)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let flowLayout = WPEqualCellSpaceFlowLayout()
        flowLayout.cellType = .left
        flowLayout.sectionInset.left = 16
        //flowLayout.sectionInset.right = 16
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
//        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.itemSize = CGSize(width: (WPScreenWidth - 42)/2, height: 20.0)
        flowLayout.betweenOfCell = 10
        
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPSearCacheCell.self, forCellWithReuseIdentifier: "WPSearCacheCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        return collectionView
    }()
    
    lazy var datas: [String] = {
        return ["城市设计", "竞赛", "2021", "调研报告", "城市更新", "城市可持", "元宇宙", "碳中和"]
    }()
    
    var hotkeyworld:[String]!{
        didSet {
            datas.removeAll()
            datas.append(contentsOf: hotkeyworld)
            collectionView.reloadData()
        }
    }
}

extension WPSearchHotView:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (WPScreenWidth - 42)/2, height: 20.0)
    }
}

extension WPSearchHotView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if datas.count > indexPath.row {
            let text = datas[indexPath.row ]
            didSelectItemBlock?(text)
        }
    }
}

extension WPSearchHotView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WPSearCacheCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "WPSearCacheCell", for: indexPath) as! WPSearCacheCell
        if datas.count > indexPath.row {
            let text = datas[indexPath.row ]
            cell.label.text = text
        }
        return cell
    }
}

extension WPSearchHotView {
    func makeSubviews() -> Void {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
    }
    
    func makeConstraints() -> Void {
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(1)
        }
        
        button.jk.setImageTitleLayout(.imgRight, spacing: 3)
        
        collectionView.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
}
