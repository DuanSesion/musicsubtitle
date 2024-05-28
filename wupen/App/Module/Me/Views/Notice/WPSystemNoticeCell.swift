//
//  WPSystemNoticeCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/16.
//

import UIKit

class WPSystemNoticeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        makeSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubViews()
        makeConstraints()
    }
    
    lazy var textContentView: UIView = {
        var textContentView: UIView = UIView()
        contentView.addSubview(textContentView)
        return textContentView
    }()
    
    lazy var iconImageView: UIImageView = {
        var iconImageView: UIImageView = UIImageView()
        textContentView.addSubview(iconImageView)
        return iconImageView
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "系统通知"
        label.textColor = rgba(51, 51, 51, 1)
        label.font = .systemFont(ofSize: 16)
        textContentView.addSubview(label)
        return label
    }()
    
    lazy var subLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "今天是2019年5月1日，五一劳动节。在…"
        label.textColor = rgba(153, 153, 153, 1)
        label.font = .systemFont(ofSize: 13)
        textContentView.addSubview(label)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "04/30"
        label.textColor = rgba(168, 171, 181, 1)
        label.font = .systemFont(ofSize: 11)
        textContentView.addSubview(label)
        return label
    }()
    
    lazy var messageBade: UIImageView = {
        var messageBade: UIImageView = UIImageView()
        let img = UIImage.wp.createColorImage(rgba(248, 75, 1, 1), size: CGSize(width: 8, height: 8)).wp.roundCorner(4)
        messageBade.image = img
        iconImageView.addSubview(messageBade)
        return messageBade
    }()
    
    var model:[WPNoticeModel]!{
        didSet {
            let notice:WPNoticeModel? = model.first { notice in
                return (notice.isDel == false) && (notice.isShow == true)
            }
            
            timeLabel.text = "-"
            let noticex:WPNoticeModel? = (notice == nil) ? model.first : notice
            if let notice:WPNoticeModel = noticex {
                self.messageBade.isHidden = (notice.isShow)
                label.text = "系统通知" //notice.title?.wp.trim()
                subLabel.text = notice.content?.wp.trim()
                
                if let createdTime = notice.createdTime {
                    let date:Date = Date.jk.formatterTimeStringToDate(timesString: createdTime, formatter: "yyyy-MM-dd HH:mm:ss")
                    timeLabel.text = date.jk.callTimeAfterNow()
                }
            }
        }
    }
}

extension WPSystemNoticeCell {
    func makeSubViews() -> Void {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        textContentView.backgroundColor = .white
        textContentView.layer.cornerRadius = 12
        textContentView.layer.shadowOffset = .init(width: -1, height: -2)
        textContentView.layer.shadowColor = rgba(225, 241, 255, 0.50).cgColor
        textContentView.layer.shadowRadius = 12
        textContentView.layer.shadowOpacity = 1
        textContentView.layer.backgroundColor = UIColor.white.cgColor
 
        iconImageView.image = .init(named: "msg_system_notices")
    }
    
    func makeConstraints() -> Void {
        textContentView.snp.makeConstraints { make in
            make.height.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(9)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.right.equalToSuperview().offset(-12)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(timeLabel.snp.left)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.left.equalTo(label)
            make.right.lessThanOrEqualTo(textContentView).offset(-30)
        }
        
        messageBade.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.top.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-2.5)
        }
    }
}
