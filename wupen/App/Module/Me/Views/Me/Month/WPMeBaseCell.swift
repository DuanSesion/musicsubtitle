//
//  WPMeBaseCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/26.
//

import UIKit

class WPMeBaseCell: UICollectionViewCell {
    class func collectionViewWithCell(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[WPLiveModel], updateBlock:@escaping(_ :Bool)->Void)->UICollectionViewCell {
        if indexPath.row == 0 {
            return WPMeCalendarCell.collectionViewWithCell(collectionView, indexPath: indexPath, datas: datas, updateBlock: updateBlock)
        }
        
        if datas.count <= 0 {
            return WPMeEmptyCell.collectionViewWithCell(collectionView, indexPath: indexPath, datas: datas) {  r in }
        }
        
        return WPMeLiveStatusCell.collectionViewWithCell(collectionView, indexPath: indexPath, datas: datas,updateBlock: updateBlock)
    }
    
    class func didSelectItemAt(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[WPLiveModel])->Void {
        if indexPath.row == 0 {
            WPMeCalendarCell.didSelectItemAt(collectionView, indexPath: indexPath, datas: datas)
        } else {
            WPMeLiveStatusCell.didSelectItemAt(collectionView, indexPath: indexPath, datas: datas)
        }
    }
    
    class func register (_ collectionView:UICollectionView) {
        collectionView.register(WPMeCalendarCell.self, forCellWithReuseIdentifier: "WPMeCalendarCell")
        collectionView.register(WPMeLiveStatusCell.self, forCellWithReuseIdentifier: "WPMeLiveStatusCell")
        collectionView.register(WPMeEmptyCell.self, forCellWithReuseIdentifier: "WPMeEmptyCell")
        collectionView.register(WPMeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(WPMeFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
    }
    
    lazy var shadowView: UIView = {
        var shadowView: UIView = UIView()
        shadowView.layer.cornerRadius = 8
        shadowView.backgroundColor = .white
        shadowView.isUserInteractionEnabled = true
        shadowView.layer.shadowOffset = .init(width: -1, height: -2)
        shadowView.layer.shadowColor = rgba(225, 241, 255, 0.50).cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.backgroundColor = UIColor.white.cgColor
        contentView.addSubview(shadowView)
        return shadowView
    }()
}
