//
//  WPInterestMarkView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/26.
//

import UIKit

class WPInterestMarkView: UIImageView {

    public var finishBlock:(([String])->Void)?
    public var closeBlock:(()->Void)?
 

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    lazy var datas: [[WPMarkModel]]  = {
        return WPMarkModel.interest()
    }()

    lazy var closeButton: UIButton = {
        var closeButton: UIButton = UIButton()
        closeButton.setTitle("跳过", for: .normal)
        closeButton.setTitleColor(rgba(189, 144, 102, 1), for: .normal)
        closeButton.layer.borderColor = rgba(189, 144, 102, 1).cgColor
        closeButton.layer.borderWidth = 0.5
        closeButton.titleLabel?.font = .systemFont(ofSize: 13)
        closeButton.backgroundColor = .clear
        closeButton.clipsToBounds = true
        closeButton.layer.cornerRadius = 14.0
        closeButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.closeBlock?()
        }).disposed(by: disposeBag)
        addSubview(closeButton)
        return closeButton
    }()
    
    lazy var nextButton: UIButton = {
        var nextButton: UIButton = UIButton()
        nextButton.setTitle("开启", for: .normal)
        
        nextButton.setImage(.init(systemName: "arrow.right"), for: .normal)
        nextButton.tintColor = .white
        let bgimg = UIImage.wp.createColorImage(rgba(240, 140, 37), size: CGSize(width: 148, height: 46)).wp.roundCorner(23)
        nextButton.setBackgroundImage(bgimg, for: .normal)
        
        let colors = [rgba(188, 188, 188, 1).cgColor,rgba(230, 230, 230, 1).cgColor]
        let bgimgEN = UIImage.wp.jianBianLeftToRight(colors: colors, size: CGSize(width: 148, height: 46))?.wp.roundCorner(23)
        nextButton.setBackgroundImage(bgimgEN, for: .disabled)
 
        nextButton.layer.cornerRadius = 23.0
        nextButton.layer.shadowColor = rgba(0, 0, 0, 0.25).cgColor
        nextButton.layer.shadowOpacity = 1
        nextButton.layer.shadowRadius = 10
        nextButton.layer.shadowOffset = .init(width: -5, height: 5)
        nextButton.isEnabled = false
        
        nextButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            let data = WPMarkModel.getSelectedMark(weakSelf.datas)
            var lists:[String] = []
            data.forEach { model in
                lists.append(model.text)
            }
            
            weakSelf.finishBlock?(lists)
        }).disposed(by: disposeBag)
        addSubview(nextButton)
        return nextButton
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = WPEqualCellSpaceFlowLayout()
        flowLayout.sectionInset.left = 38
        flowLayout.sectionInset.right = 15
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 16
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.footerReferenceSize = CGSize(width: WPScreenWidth, height: 16)
        flowLayout.betweenOfCell = 16
        
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPRemarkCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        return collectionView
    }()
    
    
    lazy var textLabel: UILabel = {
        var label: UILabel = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "告诉我们\n你感兴趣的内容"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = .black
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.clipsToBounds = true
        self.addSubview(label)
        return label
    }()
    
    lazy var subTextLabel: UILabel = {
        var label: UILabel = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "期待您推荐更好的内容"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.clipsToBounds = true
        self.addSubview(label)
        return label
    }()
}


extension WPInterestMarkView {
    func initSubViews() -> Void {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        self.contentMode = .scaleAspectFill
        self.image = .init(named: "firt_login_icon")
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 52, height: 28))
            make.top.equalTo(self).offset(kStatusBarHeight+8)
            make.right.equalTo(self).offset(-16)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(38)
            make.top.equalTo(self.closeButton.snp.bottom).offset(35)
        }
        
        subTextLabel.snp.makeConstraints { make in
            make.left.equalTo(textLabel)
            make.top.equalTo(self.textLabel.snp.bottom).offset(6)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.width.equalTo(self)
            make.top.equalTo(self.subTextLabel.snp.bottom).offset(35)
            make.bottom.equalTo(self)
        }
        
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 148, height: 46))
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-88)
        }
        
        nextButton.jk.setImageTitleLayout(.imgRight, spacing: 8)
    }
}

extension WPInterestMarkView:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return WPRemarkCell.cellSize(sizeForItemAt: indexPath, datas: datas)
    }
}

extension WPInterestMarkView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        WPRemarkCell.didSelectItemAt(collectionView, indexPath: indexPath, datas: datas)
        nextButton.isEnabled = (WPMarkModel.getSelectedMark(datas).count > 0)
    }
}

extension WPInterestMarkView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return WPRemarkCell.collectionViewWithCell(collectionView, indexPath: indexPath, datas: datas)
    }
}


extension WPInterestMarkView {

}
