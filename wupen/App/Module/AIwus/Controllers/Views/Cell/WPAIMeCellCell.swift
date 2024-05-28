//
//  WPWPAIMeCellCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/5.
//

import UIKit

class WPAIMeCellCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubViews()
        makeConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        textContentView.setCorners([.topLeft,.bottomLeft,.bottomRight],cornerRadius: 12)
        var width = textContentView.width
        var xx = model.textMsg.widthWithFont(font: UIFont.systemFont(ofSize: 14)) + 25.0
        let maxw = WPScreenWidth - 76 - 32 - 24
        if xx > maxw {
            xx = maxw
        }
        
        if width < xx {
            width = xx
        }
        
        let corners:UIRectCorner = [.topLeft,.bottomLeft,.bottomRight]
        let radii = CGSize(width: 12, height: 12)
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: width, height: self.height-24)), byRoundingCorners: corners, cornerRadii: radii)
        let mask = CAShapeLayer()
        mask.backgroundColor = UIColor.clear.cgColor
    
        mask.path = path.cgPath
        textContentView.layer.mask = mask
    }
    
    var model:WPAIModel!{
        didSet {
            label.text = model.textMsg
            label.sizeToFit()
            layoutIfNeeded()
            
//            model.resultBlock = .some({[weak self] in
//                guard let weakSelf = self else { return  }
//            })
        }
    }
    
    lazy var textContentView: UIView = {
        var textContentView: UIView = UIView()
        textContentView.layer.cornerRadius = 4
        textContentView.backgroundColor = rgba(91, 157, 255, 1)
        contentView.addSubview(textContentView)
        return textContentView
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.numberOfLines = 0
        label.textColor = rgba(255, 255, 255, 1)
        label.font = .systemFont(ofSize: 14)
        textContentView.addSubview(label)
        return label
    }()

}

extension WPAIMeCellCell {
    func makeSubViews() -> Void {
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    func makeConstraints() -> Void {
        textContentView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-24)
            make.left.greaterThanOrEqualTo(contentView).offset(76)
            make.right.equalTo(contentView).offset(-32)
        }
        
        label.snp.makeConstraints { make in
            make.left.top.equalTo(textContentView).offset(12)
            make.bottom.right.equalTo(textContentView).offset(-12)
        }
    }
}
