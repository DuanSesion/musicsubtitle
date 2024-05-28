//
//  WPFindCourseSeriesSubCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/28.
//

import UIKit

class WPFindCourseSeriesSubCell: UICollectionViewCell {
    class func collectionViewWithCell(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[Any])->UICollectionViewCell {
        let cell:WPFindCourseSeriesSubCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WPFindCourseSeriesSubCell
        if datas.count > indexPath.row {
 
        }
        return cell
    }
    
    class func didSelectItemAt(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[Any])->Void {
  
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
    
    lazy var icon: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        icon.backgroundColor = .gray
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "xxxxxxxxxxxxxxxxxxxx"
        textLabel.numberOfLines = 2
        textLabel.textColor = rgba(55, 55, 55)
        textLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var numberLabel: UILabel = {
        var numberLabel: UILabel = UILabel()
        numberLabel.text = "1111节课"
        numberLabel.textColor = rgba(165, 165, 165)
        numberLabel.font = .systemFont(ofSize: 12)
        numberLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(numberLabel)
        return numberLabel
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.setTitle("学习", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        let bgimg = UIImage.wp.createColorImage(rgba(240, 140, 37), size: CGSize(width: 60, height: 36)).wp.roundCorner(18)
        button.setBackgroundImage(bgimg, for: .normal)
        
        contentView.addSubview(button)
        return button
    }()
}

extension WPFindCourseSeriesSubCell {
    func makeSubviews() -> Void {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = .init(width: -5, height: 5)
        self.layer.opacity = 1
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.shadowColor = rgba(0, 0, 0, 0.15).cgColor
        
        self.contentView.backgroundColor = .white
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 5
    }
    
    func makeConstraints() -> Void {
        icon.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 60, height: 36))
        }
        
        textLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(5)
            make.top.equalTo(icon.snp.bottom).offset(5)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.right.equalTo(button.snp.left).offset(-3)
            make.left.equalToSuperview().offset(5)
            make.centerY.equalTo(button)
        }
    }
}
