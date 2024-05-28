//
//  WPAIMoreExpendView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/5.
//

import UIKit

class WPAIMoreExpendView: UIImageView {
    public var isExpend:Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
        makeConstraints()
    }

    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.setImage(.init(named: "AI_expend_button_icon"), for: .normal)
        let panGest:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGest(pan:)))
        button.addGestureRecognizer(panGest)
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.isExpend = false
            UIView.animate(withDuration: 0.25) {
                weakSelf.y = -weakSelf.height
            }
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }()
    
    lazy var userNameLabel:UILabel = {
        var userNameLabel:UILabel  = UILabel()
        userNameLabel.textColor = rgba(51, 51, 51, 1)
        userNameLabel.text = "教授名字"
        userNameLabel.font = .systemFont(ofSize: 18)
        addSubview(userNameLabel)
        return userNameLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = WPEqualCellSpaceFlowLayout()
        flowLayout.cellType = .center
        flowLayout.sectionInset.left = 16
        flowLayout.sectionInset.right = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .vertical
        flowLayout.betweenOfCell = 13
        
        var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(WPAIUserCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        return collectionView
    }()
}

extension WPAIMoreExpendView {
    func initSubViews() -> Void {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .white
        self.contentMode = .scaleToFill
        self.image = .init(named: "AI_expend_more_bg_icon")
        self.clipsToBounds = true
        self.setCorners([.bottomLeft,.bottomRight],cornerRadius: 16)
    }
    
    func makeConstraints() -> Void {
        self.button.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.top.equalTo(self).offset(54)
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(userNameLabel.snp.bottom).offset(25)
            make.height.equalTo(78)
        }
    }
}

extension WPAIMoreExpendView {
    @objc func panGest(pan:UIPanGestureRecognizer)->Void {
  
        
        let tanslation:CGPoint =  pan.translation(in: self)
        if tanslation.y < 0 {
            if pan.state == .began {
                debugPrint("===begin, ", tanslation.y)
                
            } else  if pan.state == .changed {
                debugPrint("===changed, ", tanslation.y)
                self.y = tanslation.y
                
            } else  if pan.state == .cancelled || pan.state == .ended {
 
                if abs(tanslation.y) >= self.height/2 {
                    self.isExpend = false
                    UIView.animate(withDuration: 0.25) {
                        self.y = -self.height
                    }
                } else {
                    self.isExpend = false
                    UIView.animate(withDuration: 0.25) {
                        self.y = 0
                    }
                }
            }
        }
    }
    
}


extension WPAIMoreExpendView:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 166, height: 78.0)
    }
}

extension WPAIMoreExpendView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
    }
}

extension WPAIMoreExpendView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WPAIUserCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WPAIUserCell
        if indexPath.row == 0 {
            cell.icon.image = .init(named: "ai_user_head_icon")
            cell.button.isSelected = true
            cell.name.textColor = .white
            cell.label.textColor  = .white
        } else {
            let img:UIImage? = .init(systemName: "person.crop.circle")?.sd_resizedImage(with: CGSize(width: 66, height: 66), scaleMode: .aspectFill)?.withTintColor(rgba(188, 188, 188, 0.66), renderingMode: .alwaysOriginal)
            cell.icon.image = img
            cell.button.isSelected = false
            cell.name.textColor = rgba(51, 51, 51, 1)
            cell.label.textColor  = rgba(136, 136, 136, 1)
            cell.name.text = "即将上线更多"
            cell.label.text = "more"
        }
        
        return cell
    }
}
