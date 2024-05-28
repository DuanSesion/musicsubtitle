//
//  WPSubtitleCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/13.
//

import UIKit

class WPSubtitleCell: UITableViewCell {

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
        makeSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubviews()
        makeConstraints()
    }
    
    lazy var checkButton: UIButton = {
        var checkButton: UIButton = UIButton()
        checkButton.isUserInteractionEnabled = false
        checkButton.setImage(.init(named: "zimu_check_icon"), for: .selected)
        checkButton.setImage(.init(named: "zimu_un_check_icon"), for: .normal)
        contentView.addSubview(checkButton)
        return checkButton
    }()
    
    func setSub(lang:WPLectureVideosLanguageModel, langKey:String?, _ screenState: WPPlayerContentView.WPPlayerScreenState = .small) -> Void {
        self.textLabel?.text = lang.title
        checkButton.isSelected = false
        if langKey == lang.key {
           checkButton.isSelected = true
        }
        
        if screenState == .small {
            self.textLabel?.textColor = rgba(51, 51, 51)
        } else {
            self.textLabel?.textColor = .white
        }
    }
}

extension WPSubtitleCell {
    func makeSubviews () {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.textLabel?.font = .systemFont(ofSize: 14)
    }
    
    func makeConstraints () {
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
    }
}
