//
//  WPWPAICell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/5.
//

import UIKit

class WPWPAICell: UITableViewCell {
    var timer:Timer?

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
 
        var width = textContentView.width
        var xx = model.textMsg.widthWithFont(font: UIFont.systemFont(ofSize: 14)) + 24.0
        let maxw = WPScreenWidth - 81 - 44
        if xx > maxw {
            xx = maxw
        }
        
        if width < xx {
            width = xx
        }
        
        
        let corners:UIRectCorner = [.topRight,.bottomLeft,.bottomRight]
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
            label.textColor = rgba(102, 102, 102, 1)
            textContentView.backgroundColor = .white
            
            label.sizeToFit()
            layoutIfNeeded()
            
            if model.isSend {
                label.textColor = rgba(95, 117, 196, 1)
                textContentView.backgroundColor = rgba(216, 230, 252, 1)
            }
            
//            if model.needAnimate {
//                label.text = ""
//                self.upadteAnser()
//            }
            
//            model.resultBlock = .some({[weak self] in
//                guard let weakSelf = self else { return  }
//               
//            })
        }
    }
    
    lazy var textContentView: UIView = {
        var textContentView: UIView = UIView()
        textContentView.layer.cornerRadius = 4
        textContentView.backgroundColor = .white
        contentView.addSubview(textContentView)
        return textContentView
    }()
    
    lazy var user: UIImageView = {
        var user: UIImageView = UIImageView(image: .init(named: "ai_user_head_icon"))
        user.contentMode = .scaleAspectFill
        contentView.addSubview(user)
        return user
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.numberOfLines = 0
        label.textColor = rgba(102, 102, 102, 1)
        label.font = .systemFont(ofSize: 14)
        textContentView.addSubview(label)
        return label
    }()
    

    
}

extension WPWPAICell {
    func upadteAnser() -> Void {
        timer?.invalidate()
        label.textColor = rgba(102, 102, 102, 1)
        textContentView.backgroundColor = .white
        
        if model.needAnimate {
            model.needAnimate = false
            
            var width = model.textMsg.widthWithFont(font: UIFont.systemFont(ofSize: 14)) + 25.0
            let maxw = WPScreenWidth - 81 - 44
            if width > maxw {
                width = maxw
            }
            
            var height = model.textMsg.heightWithFont(fixedWidth: WPScreenWidth - 81 - 44) + 24.0
            if height < 49+24{
               height = 49+24
            }
     
            let corners:UIRectCorner = [.topRight,.bottomLeft,.bottomRight]
            let radii = CGSize(width: 12, height: 12)
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: width, height: height)), byRoundingCorners: corners, cornerRadii: radii)
            let mask = CAShapeLayer()
            mask.backgroundColor = UIColor.clear.cgColor
        
            mask.path = path.cgPath
            textContentView.layer.mask = mask
            
            
           
            let text = model.textMsg
            var animatedText = ""
            // 使用Timer进行逐字显示
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {[weak self] time in
                guard let weakSelf = self else { return }

                // 添加下一个字符到已显示的文本中
               
                let cc = text.prefix(animatedText.count + 1).last
                let x = String(cc ?? Character(extendedGraphemeClusterLiteral: .comma))
                
                animatedText.append(x)

                // 更新Label的文本并执行动画
                UIView.animate(withDuration: 0.3) {
                    weakSelf.label.text = animatedText
                }

                // 当所有字符都显示完毕，停止定时器
                if animatedText.count == text.count {
                    weakSelf.timer?.invalidate()
                    if let te:UITableView = self?.superview as? UITableView {
                        te.reloadData()
                    }
                }
            }
        }

        
 
    }
    
}

extension WPWPAICell {
    func makeSubViews() -> Void {
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    func makeConstraints() -> Void {
        user.snp.makeConstraints { make in
            make.width.height.equalTo(53)
            make.top.equalToSuperview()
            make.left.equalTo(16)
        }
        
        textContentView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-24)
            make.left.equalTo(user.snp.right).offset(12)
            make.right.lessThanOrEqualTo(contentView).offset(-44)
        }
        
        label.snp.makeConstraints { make in
            make.left.top.equalTo(textContentView).offset(12)
            make.bottom.right.equalTo(textContentView).offset(-12)
        }
    }
}
