//
//  WPFindCourseController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/28.
//

import UIKit

class WPFindeCellCollectionView:UICollectionView,UIGestureRecognizerDelegate {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
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
        super.init(coder: coder)
    }
    
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       return true
    }
}
 

class WPFindCourseController: WPBaseController {
    public var model:WPClassificationsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
        loadDatas()
    }
    
    lazy var collectionView: WPFindeCellCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset.left = 0
        flowLayout.sectionInset.right = 0
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        var collectionView: WPFindeCellCollectionView = WPFindeCellCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPFindCourseSubCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 12
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    lazy var datas: [WPCouserModel] = {
        return []
    }()
}

extension WPFindCourseController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 85)
    }
}

extension WPFindCourseController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        WPFindCourseSubCell.didSelectItemAt(collectionView, indexPath: indexPath, datas: self.datas,tags: self.model?.chineseName, controller: self)
    }
}

extension WPFindCourseController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.datas.count >= 4) ? 4 : self.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return WPFindCourseSubCell.collectionViewWithCell(collectionView, indexPath: indexPath, datas: self.datas)
    }
}


extension WPFindCourseController {
    func makeSubviews() -> Void {
        self.view.backgroundColor = .clear
        let bg:UIView = UIView(frame: .init(origin: .init(x: 16, y: 0), size: CGSize(width: WPScreenWidth-32, height: 360+20)))
        bg.backgroundColor = .white
        bg.layer.cornerRadius = 12
        bg.layer.shadowOffset = .init(width: -5, height: 5)
        bg.layer.opacity = 1
        bg.layer.shadowOpacity = 1
        bg.layer.shadowColor = rgba(0, 0, 0, 0.02).cgColor
        view.addSubview(bg)
    }

    func makeConstraints() -> Void {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalTo(self.view)
            make.width.equalTo(self.view).offset(-32)
        }
    }
    
    func toucheEvent() -> Void {
        let text:String? = model?.id ?? "最热"
        WPUmeng.um_event_course_CourseRecommendation(text)
        loadDatas()
    }
}

extension WPFindCourseController {
    func loadDatas() -> Void {
        var classifications:[String]? = nil
        var heatSort:Bool? = nil
        
        if let model = self.model {
            classifications = [model.id]
        } else {
           heatSort = false
        }
        
        let classificationStr = classifications?.first
        WPSearchModel.search(pageNum: 1, heatSort:heatSort, classifications: classifications) {[weak self] model in
            guard let weakSelf = self else { return  }
            if var  list: [WPCouserModel] = model.jsonModel?.data as? [WPCouserModel]  {
                if list.count > 4 {
                    list = Array(list.prefix(4))
                }
                list.forEach { mode in
                    mode.classification = classificationStr
                }
                weakSelf.datas.append(contentsOf: list)
                weakSelf.collectionView.reloadData()
            }
        }
    }
}

