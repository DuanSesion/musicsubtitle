//
//  WPMeEmptyCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/16.
//

import UIKit

class WPMeEmptyCell: WPMeBaseCell {
    
    override class func collectionViewWithCell(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[WPLiveModel],updateBlock:@escaping(_ :Bool)->Void)->WPMeEmptyCell {
        let cell:WPMeEmptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WPMeEmptyCell", for: indexPath) as! WPMeEmptyCell
        if datas.count > indexPath.row {
 
        }
        return cell
    }
    
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
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.textAlignment = .center
        textLabel.text = "这一天暂时没有日程安排哦～"
        textLabel.textColor = rgba(136, 136, 136, 1)
        shadowView.addSubview(textLabel)
        return textLabel
    }()
}


extension WPMeEmptyCell {
    func makeSubviews() -> Void {
        self.backgroundColor = .clear
        shadowView.layer.shadowOpacity = 0
        shadowView.layer.cornerRadius = 12
    }
    
    func makeConstraints() -> Void {
        shadowView.snp.makeConstraints { make in
            make.centerY.centerX.height.equalTo(contentView)
            make.width.equalTo(WPScreenWidth-32)
        }
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(31.0)
        }
    }
}
