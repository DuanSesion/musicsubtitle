//
//  WPRemarkCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit

class WPRemarkCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func collectionViewWithCell(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[[WPMarkModel]])->WPRemarkCell {
        let cell:WPRemarkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WPRemarkCell
        if datas.count > indexPath.section {
            let datas:[WPMarkModel] = datas[indexPath.section]
            if datas.count > indexPath.row {
                cell.model = datas[indexPath.row]
            }
        }
        return cell
    }
    
    class func didSelectItemAt(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[[WPMarkModel]])->Void {
        if let cell:WPRemarkCell = collectionView.cellForItem(at: indexPath) as? WPRemarkCell {
            cell.model.isSelected = !cell.model.isSelected
            cell.didSelected = cell.model.isSelected
        }
    }
 
    class func cellSize(sizeForItemAt indexPath: IndexPath,datas:[[WPMarkModel]]) -> CGSize {
        let datas:[WPMarkModel] = datas[indexPath.section]
        let text = datas[indexPath.row].text
        let font = UIFont.systemFont(ofSize: 14)
        
        let h = UIFont.systemFont(ofSize: 14).lineHeight
        let width = heightWithConstrainedHeigth(text: text.wp.trim(), heigth: h, font: font) + 36.0
       return CGSize(width: width, height: 38.0)
    }
    
    class func heightWithConstrainedHeigth(text:String, heigth: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: heigth)
        let boundingBox = text.boundingRect(with: constraintRect, options: .truncatesLastVisibleLine, attributes: [NSAttributedString.Key.font : font], context: nil)
        return boundingBox.size.width
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = rgba(94, 100, 118, 1)
        label.font = .boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(label)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var model:WPMarkModel! {
        didSet {
            self.didSelected = self.model.isSelected
            self.label.text = self.model.text
        }
    }
    
    var didSelected:Bool = false {
        didSet {
            if didSelected {
                self.label.textColor = .white
                if let gradientbglayer = (self.layer as? CAGradientLayer) {
                    gradientbglayer.colors = [rgba(240, 140, 37).cgColor,rgba(240, 140, 37,0.8).cgColor]
                }
                
            } else {
                self.label.textColor = rgba(94, 100, 118, 1)
                if let gradientbglayer = (self.layer as? CAGradientLayer) {
                    gradientbglayer.colors = [rgba(255, 255, 255, 0.70).cgColor,rgba(255, 255, 255, 0.70).cgColor]
                }
            }
        }
    }
}

extension WPRemarkCell {
    func setup() -> Void {
        self.layer.cornerRadius = 19
        self.clipsToBounds = true
        self.backgroundColor = .white
        makeLayer()
        
        self.label.snp.makeConstraints { make in
            make.centerX.top.bottom.equalTo(self.contentView)
            make.height.equalTo(38)
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
        }
    }
    
    func makeLayer() -> Void {
        if let gradientbglayer = (self.layer as? CAGradientLayer) {
            gradientbglayer.colors = [rgba(255, 255, 255, 1).cgColor]
            gradientbglayer.locations = [0,1]
            gradientbglayer.startPoint = .zero
            gradientbglayer.endPoint = CGPoint(x: 1, y: 0)
        }
    }
}
