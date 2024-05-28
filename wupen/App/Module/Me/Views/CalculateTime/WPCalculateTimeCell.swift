//
//  WPCalculateTimeCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPCalculateTimeCell: UITableViewCell {

    class func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath,datas:[WPMyDurationRecordModel]) -> UITableViewCell {
//        let model:WPMyInfoModel = datas[indexPath.section]
        let cell:WPCalculateTimeCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WPCalculateTimeCell
        if datas.count > indexPath.section {
            cell.model = datas[indexPath.section]
        }
        return cell
    }

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
    
    lazy var bg: UIImageView = {
        var bg: UIImageView = UIImageView()
        bg.backgroundColor = rgba(245, 245, 245, 1)
        bg.layer.cornerRadius = 12
        contentView.addSubview(bg)
        return bg
    }()

    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "完成《xxxx》课程观看"
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        self.bg.addSubview(label)
        return label
    }()
    
    lazy var calculateTime: UILabel = {
        var label: UILabel = UILabel()
        label.text = "+100"
        label.textColor = rgba(21, 13, 43, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        self.bg.addSubview(label)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "2023-01-01 16:00:00"
        label.textColor = rgba(168, 171, 181, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        self.bg.addSubview(label)
        return label
    }()
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(233, 233, 233, 1)
        self.bg.addSubview(line)
        return line
    }()

    var model:WPMyDurationRecordModel!{
        didSet {
            label.text = model.remark ?? "-"
            timeLabel.text = model.updatedTime
            calculateTime.attributedText = getLongTime( model.duration)
        }
    }
}

extension WPCalculateTimeCell {
    func getLongTime(_ duration:Int)->NSAttributedString {
        let creditDuration:Int = duration
     
        let  hour = creditDuration / 60 / 60
        let  min = (creditDuration - hour * 3600) % 60

        var str = "+\(hour)时\(min)分"
        if hour <= 0 {
            str = "+\(min)分"
        }
        
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.yy_font = UIFont.systemFont(ofSize: 18)
        attributedString.yy_color = rgba(51, 51, 51, 1)
        
        let font = UIFont(name: "DIN Alternate", size: 12)
        
        if let position:Range<String.Index> = str.range(of: "时"),
            let range = str.nsRange(from: position) {
            attributedString.yy_setFont(font, range: range)
        }
        
        if let position:Range = str.range(of: "分"),
           let range = str.nsRange(from: position) {
            attributedString.yy_setFont(font, range: range)
        }
        
        return attributedString
    }
}



extension WPCalculateTimeCell {
    func makeSubViews() -> Void {
        self.backgroundColor = .white

    }
    
    func makeConstraints() -> Void {
        bg.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(WPScreenWidth-32)
        }
        
        label.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(14)
            make.right.lessThanOrEqualTo(calculateTime.snp.left).offset(-2)
        }
        
        calculateTime.snp.makeConstraints { make in
            make.centerY.equalTo(label)
            make.right.equalToSuperview().offset(-12)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(label)
            make.right.lessThanOrEqualTo(self.bg).offset(-14)
            make.bottom.equalToSuperview().offset(-9)
        }
        
        line.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalTo(WPScreenWidth - 60)
        }
        
    }
}
