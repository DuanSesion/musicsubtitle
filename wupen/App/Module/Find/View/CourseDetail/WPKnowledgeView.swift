//
//  WPKnowledgeView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/7.
//

import UIKit

class WPKnowledgeView: UIView {
    var video:WPLectureVideosModel?

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
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(237, 237, 237, 1)
        addSubview(line)
        return line
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "知识点"
        textLabel.textColor = rgba(51, 51, 51, 1)
        textLabel.font = .boldSystemFont(ofSize: 18)
        addSubview(textLabel)
        return textLabel
    }()
    
    lazy var subLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "1/20"
        textLabel.textColor = rgba(51, 51, 51, 1)
        textLabel.font = .systemFont(ofSize: 12)
        addSubview(textLabel)
        return textLabel
    }()

    lazy var button: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(.init(systemName: "chevron.right"), for: .normal)
        button.tintColor = rgba(136, 136, 136, 1)
        button.setTitleColor(rgba(136, 136, 136, 1), for: .normal)
        button.setTitle("全部", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.contentHorizontalAlignment = .trailing
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            if let videos = weakSelf.couserDetail?.videos {
                WPUmeng.um_event_course_KnowledgePointsList(weakSelf.couserDetail?.lecture?.chineseTitle)
                
                if videos.count > 0 {
                    let courseVideosView:WPCourseVideosView = WPCourseVideosView()
                    courseVideosView.show(videos: videos)
                    courseVideosView.didSelectedBlock = .some({[weak self] video in
                        guard let weakSelf = self else {return }
                        
                        video.isSelected = true
                        weakSelf.video = video
                        weakSelf.couserDetail?.currentDidIndexBlock?(video)
                        
                        if let videos = weakSelf.couserDetail?.videos {
                            let index = videos.firstIndex { s in
                                return video.video?.id == s.video?.id
                            }
                            
                            // 自播视频
                            guard let i = index, (i) < videos.count else { return  }
                            let nextIndex:Int = i
                            weakSelf.currentIndex = nextIndex
                        }
                    })
                }
            }
 
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset.left = 16
        flowLayout.sectionInset.right = 16
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 8
        flowLayout.itemSize = .init(width: 192, height: 82)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPKnowledgeCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        return collectionView
    }()
    
    var couserDetail:WPCouserDetailModel?{
        didSet {
//            subLabel.text = "\((couserDetail?.currentIndex ?? 0) + 1)/\(couserDetail?.videos.count ?? 0)"
//            collectionView.reloadData()
            if let currentIndex = couserDetail?.currentIndex {
                self.currentIndex = currentIndex
            }
        }
    }
    
    var currentIndex:Int!{
        didSet {
            subLabel.text = "\((currentIndex) + 1)/\(couserDetail?.videos.count ?? 0)"
            couserDetail?.currentIndex = currentIndex
            couserDetail?.videos.forEach({ v in
                v.isSelected = false
            })
            
            if currentIndex < (couserDetail?.videos.count ?? 0) && currentIndex >= 0 {
                self.video?.isSelected = false
                if let model = couserDetail?.videos[currentIndex] {
                    model.isSelected = true
                    self.video = model
                }
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: .init(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}

extension WPKnowledgeView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 192, height: 82)
    }
}

extension WPKnowledgeView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.video?.isSelected = false
        collectionView.reloadData()
        
        couserDetail?.currentIndex = indexPath.row
        subLabel.text = "\((couserDetail?.currentIndex ?? 0 ) + 1)/\(couserDetail?.videos.count ?? 0)"
        
        if indexPath.row < (couserDetail?.videos.count ?? 0) {
            self.currentIndex = indexPath.row
          
            if let model = couserDetail?.videos[indexPath.row] {
                model.isSelected = true
                self.video = model
                couserDetail?.currentDidIndexBlock?(model)
            }
        }
//        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
}

extension WPKnowledgeView:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  couserDetail?.videos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WPKnowledgeCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WPKnowledgeCell
        if indexPath.row < (couserDetail?.videos.count ?? 0) {
            if let model = couserDetail?.videos[indexPath.row] {
                cell.model = model
            }
        }
        return cell
    }
}

extension WPKnowledgeView {
    func makeSubviews() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    func makeConstraints() -> Void {
        line.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(1)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerY.equalTo(textLabel)
            make.left.equalTo(textLabel.snp.right).offset(9)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(45)
            make.centerY.equalTo(textLabel)
            make.right.equalToSuperview().offset(-16)
        }
        button.jk.setImageTitleLayout(.imgRight,spacing: 1)
        
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(textLabel.snp.bottom).offset(12)
            make.height.equalTo(92)
            make.width.equalTo(WPScreenWidth)
        }
    }
}
