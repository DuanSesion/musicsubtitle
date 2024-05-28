//
//  WPAppUpdateView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/16.
//

import UIKit

enum AppUpdateType: Int {
   case update
   case noUpdate
}

class WPAppUpdateView: UIView {
    private var type:AppUpdateType = .noUpdate
    private var model:WPAppUpdate?

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        makeSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubViews()
        makeConstraints()
    }
    
    init(_ type:AppUpdateType = .noUpdate,model:WPAppUpdate?=nil) {
        super.init(frame: UIScreen.main.bounds)
        self.type = type
        self.model = model
        
        makeSubViews()
        makeConstraints()
    }
    
    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        addSubview(contentView)
        return contentView
    }()
    
    lazy var close: UIButton = {
        var button: UIButton = UIButton()
        button.setImage(.init(named: "comm_close_icon"), for: .normal)
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            self?.dismiss {
                self?.contentView.transformMini()
            }
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "版本更新"
        label.textColor = rgba(51, 51, 51, 1)
        label.font = .systemFont(ofSize: 16)
        contentView.addSubview(label)
        return label
    }()

    lazy var visionLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "最新版本V" + WPVersion
        label.textColor = rgba(102, 102, 102, 1)
        label.font = .systemFont(ofSize: 13)
        contentView.addSubview(label)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        var label: UILabel = UILabel()
        label.numberOfLines = 0
        label.textColor = rgba(136, 136, 136, 1)
        label.font = .systemFont(ofSize: 13)
        contentView.addSubview(label)
        return label
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else {return}
            if weakSelf.type == .update {
                if let url = URL(string: AppDowloadURL) {
                    UIApplication.shared.open(url)
                }
            }
            weakSelf.dismiss {
                self?.contentView.transformMini()
            }

        }).disposed(by: disposeBag)
        contentView.addSubview(button)
        return button
    }()
}

extension WPAppUpdateView{
    func show() {
        self.show {[weak self] in
            self?.contentView.transformMax()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesBegan(touches, with: event)
         if touches.first?.view == self {
            dismiss { [weak self] in
                self?.contentView.transformMini()
            }
        }
    }
}

extension WPAppUpdateView{
    func makeSubViews() -> Void {
        self.backgroundColor = rgba(0, 0, 0, 0.6)
        self.isUserInteractionEnabled = true
        if self.type == .noUpdate {
            button.backgroundColor = rgba(255, 234, 194, 1)
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.setTitle("目前已是最新版本", for: .normal)
            button.setTitleColor(rgba(185, 142, 90, 1), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            
        } else {
            button.backgroundColor = rgba(254, 143, 11, 1)
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.setTitle("更新版本", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            contentLabel.text = self.model?.results?.first?.releaseNotes
        }
    }

    func makeConstraints() -> Void {
        if self.type == .noUpdate {
            contentView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-80)
                make.size.equalTo(CGSize(width: 264, height: 148))
            }
            
            button.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 160, height: 40))
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-23)
            }
            
        } else {
            contentView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-80)
                make.width.equalTo(264)
                make.height.greaterThanOrEqualTo(213)
            }
            
            contentLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().offset(-34)
                make.top.equalTo(visionLabel.snp.bottom).offset(14)
            }
            
            button.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 134, height: 40))
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-17)
                make.top.greaterThanOrEqualTo(contentLabel.snp.bottom).offset(18)
            }
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
        }
        visionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }

        close.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(32)
            make.width.height.equalTo(28)
            make.centerX.equalToSuperview()
        }
        
        contentView.transformMini()
    }
}


