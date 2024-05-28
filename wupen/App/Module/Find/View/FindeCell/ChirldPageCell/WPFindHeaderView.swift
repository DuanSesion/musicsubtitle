//
//  WPFindFooterView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPFindHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    lazy var textTitleLabel: UILabel = {
        var textTitleLabel: UILabel = UILabel()
        textTitleLabel.text = "课程"
        textTitleLabel.textColor = rgba(51, 51, 51, 1)
        textTitleLabel.font = .boldSystemFont(ofSize: 18)
        self.addSubview(textTitleLabel)
        return textTitleLabel
    }()
    
    lazy var button: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(.init(systemName: "chevron.right"), for: .normal)
        button.tintColor = rgba(136, 136, 136, 1)
        button.setTitleColor(rgba(136, 136, 136, 1), for: .normal)
        button.setTitle("全部", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.isHidden = true
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            if weakSelf.model.type == .course {
                let vc:WPCourseListController = WPCourseListController()
                weakSelf.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
                WPUmeng.um_event_find_HotCoursesViewMore()
                
            } else if weakSelf.model.type == .live {
                let vc:WPLiveListController = WPLiveListController()
                weakSelf.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            }
 
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }()
    
    var model:WPFindeCellModel!{
        didSet {
            textTitleLabel.text = model.title
            button.isHidden = !model.hasMore
        }
    }
}

extension WPFindHeaderView {
    func setup() -> Void {
        self.backgroundColor = .clear
        textTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(88)
            make.centerY.right.equalToSuperview()
        }
        
        button.jk.setImageTitleLayout(.imgRight,spacing: 3)
    }
}
