//
//  WPCourseListCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/8.
//

import UIKit

class WPCourseListCell: UICollectionViewCell {
    
    class func collectionViewWithCell(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[WPCouserModel])->UICollectionViewCell {
        let cell:WPCourseListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WPCourseListCell
        cell.updateTopAndBottom(row: indexPath.row, count: datas.count)
        if datas.count > indexPath.row {
            cell.model = datas[indexPath.row]
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
    
    lazy var icon: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.layer.cornerRadius = 8
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = .lightGray
        icon.clipsToBounds = true
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "当前国土空间规划课程实现…."
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(label)
        return label
    }()
    
    
    lazy var userIcon: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.layer.cornerRadius = 8.5
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = .lightGray
        icon.clipsToBounds = true
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "吴志强"
        label.textColor = rgba(102, 102, 102, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
       contentView.addSubview(label)
        return label
    }()
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(211, 211, 211, 1)
        contentView.addSubview(line)
        return line
    }()
    
    lazy var timebgView: UIView = {
        var timebgView: UIView = UIView()
        timebgView.backgroundColor = rgba(243, 243, 243, 1)
        timebgView.layer.cornerRadius = 11.5
        contentView.addSubview(timebgView)
        return timebgView
    }()
    
    lazy var timeLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "120分钟"
        label.textColor = rgba(102, 102, 102, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        timebgView.addSubview(label)
        return label
    }()
    
    lazy var bottomLine: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(238, 238, 238, 1)
        contentView.addSubview(line)
        return line
    }()
    
    lazy var visualEffectView: UIVisualEffectView = {
        var blurEffrct: UIBlurEffect = UIBlurEffect(style: .light)
        var visualEffectView: UIVisualEffectView = UIVisualEffectView(effect: blurEffrct)
        visualEffectView.clipsToBounds = true
        visualEffectView.layer.cornerRadius = 8
        icon.addSubview(visualEffectView)
        return visualEffectView
    }()
    
    lazy var payerIcon: UIImageView = {
        var icon: UIImageView = UIImageView(image: .init(named: "look_icon"))
        icon.contentMode = .scaleAspectFill
        visualEffectView.contentView.addSubview(icon)
        return icon
    }()
    
    lazy var payerCountLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "8000"
        label.textColor = rgba(255, 255, 255, 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 11)
        visualEffectView.contentView.addSubview(label)
        return label
    }()
    
    var model:WPCouserModel!{
        didSet {
            icon.sd_setImage(with: .init(string: model.coverImage ?? ""))
            userIcon.sd_setImage(with: .init(string: model.scholarAvatar ?? ""))
            payerCountLabel.text = "\(model.learnNums)"
            timeLabel.text = model.duration ?? "-"
            
            if WPLanguage.chinessLanguage() {
                titleLabel.text = model.title
                nameLabel.text  = model.scholarName ?? (model.universityName ?? "-")
                
            } else {
                titleLabel.text = model.titleEn
                nameLabel.text  = model.scholarNameEn ?? (model.universityNameEn ?? "-")
            }
        }
    }
}

extension WPCourseListCell {
    func updateTopAndBottom(row:Int,count:Int) -> Void {
        if row == 0 && count == 1 {
            setCorners(.allCorners,cornerRadius: 12)
            bottomLine.isHidden = true
        } else if row == 0 {
            setCorners([.topLeft,.topRight],cornerRadius: 12)
            bottomLine.isHidden = false
        } else if row+1 == count {
            setCorners([.bottomRight,.bottomLeft],cornerRadius: 12)
            bottomLine.isHidden = true
        } else {
            self.layer.mask = nil
            bottomLine.isHidden = false
        }
    }
}

extension WPCourseListCell {
    func makeSubviews() -> Void {
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 0
    }
    
    func makeConstraints() -> Void {
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 125, height: 70))
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(15)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(12)
            make.right.lessThanOrEqualTo(contentView).offset(-16)
            make.top.equalTo(icon).offset(6)
        }
        userIcon.snp.makeConstraints { make in
            make.width.height.equalTo(17)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-25)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(userIcon.snp.right).offset(3)
            make.centerY.equalTo(userIcon)
        }
        line.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 0.5, height: 9))
            make.centerY.equalTo(userIcon)
            make.left.equalTo(nameLabel.snp.right).offset(12)
        }
        timebgView.snp.makeConstraints { make in
            make.height.equalTo(23)
            make.centerY.equalTo(userIcon)
            make.left.equalTo(line.snp.right).offset(12)
        }
        timeLabel.snp.makeConstraints { make in
            make.height.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        bottomLine.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(0.5)
        }
        visualEffectView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.bottom.right.equalToSuperview()
        }
        payerIcon.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(4)
        }
        payerCountLabel.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalTo(payerIcon.snp.right).offset(3)
            make.right.equalToSuperview().offset(-4)
        }
    }
}
