//
//  WPLivePlayerContentView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/15.
//

import UIKit


protocol WPLivePlayerContentDelegate:NSObjectProtocol {
    func livePlayerContentDidFull(in contentView:WPLivePlayerContentView)->Void
    func livePlayerContentDidBack(in contentView:WPLivePlayerContentView)->Void
}

class WPLivePlayerContentView: UIImageView {
    public weak var delegate:WPLivePlayerContentDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        makeSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubviews()
        makeConstraints()
    }
    
    lazy var topView: UIView = {
        var topView: UIView = UIView()
        topView.backgroundColor = .clear
        topView.isUserInteractionEnabled = true
        topView.isHidden = true
        topView.clipsToBounds = true
        addSubview(topView)
        return topView
    }()
    
    lazy var bottomView: WPColorAlphaView = {
        var bottomView: WPColorAlphaView = WPColorAlphaView()
        bottomView.backgroundColor = .clear
        bottomView.isUserInteractionEnabled = true
        bottomView.colors = [rgba(0, 0, 0, 0).cgColor,rgba(0, 0, 0, 1).cgColor]
        addSubview(bottomView)
        return bottomView
    }()
    
    lazy var effect : UIBlurEffect = {
        var effect : UIBlurEffect = .init(style: .light)
        return effect
    }()
    
    lazy var effectView : UIVisualEffectView = {
        var effectView : UIVisualEffectView = UIVisualEffectView(effect: effect)
        effectView.alpha = 0.96
        effectView.isHidden = true
        effectView.backgroundColor = .clear
        effectView.contentView.backgroundColor = .clear
        self.addSubview(effectView)
        return effectView
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        button.setImage(.init(named: "play_full_icon"), for: .normal)
        button.rx.tap.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.delegate?.livePlayerContentDidFull(in: weakSelf)
            
        }).disposed(by: disposeBag)
        bottomView.addSubview(button)
        return button
    }()
    
    lazy var backButton: UIButton = {
        var button: UIButton = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setImage(UIImage(named: "nav_back")?.withTintColor(.white), for: .normal)
        button.rx.tap.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.delegate?.livePlayerContentDidBack(in: weakSelf)
            
        }).disposed(by: disposeBag)
        topView.addSubview(button)
        return button
    }()
    
    lazy var countLabel: UILabel = {
        var countLabel: UILabel = UILabel()
        countLabel.text = ""
        countLabel.font = .systemFont(ofSize: 12)
        countLabel.textColor = .white
        bottomView.addSubview(countLabel)
        return countLabel
    }()
    
    lazy var liveStateLabel: UILabel = {
        var liveStateLabel: UILabel = UILabel()
        liveStateLabel.text = "主播即将上线..."
        liveStateLabel.font = .boldSystemFont(ofSize: 16)
        liveStateLabel.textColor = .white
        liveStateLabel.isHidden = true
        addSubview(liveStateLabel)
        return liveStateLabel
    }()
    
    public var isShowLiveState: Bool = false {
        didSet {
            guard isShowLiveState != oldValue else { return }
            liveStateLabel.isHidden = !isShowLiveState
        }
    }
    
    private var isShowMorePanel: Bool = true {
        didSet {
            guard isShowMorePanel != oldValue else { return }
            if isShowMorePanel {
 
                topView.snp.updateConstraints { make in
                    make.top.equalToSuperview()
                }
                
                bottomView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview()
                }
                
                
            } else {
                topView.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(-64)
                }
                
                bottomView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(54)
                }
            }
            UIView.animate(withDuration: 0.25) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    var detail:WPLiveDetailModel? {
        didSet {
            if let model = detail {
                backButton.setTitle(model.name, for: .normal)
                backButton.jk.setImageTitleLayout(.imgLeft, spacing: 8)
            }
        }
    }
}

extension WPLivePlayerContentView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isShowMorePanel = !isShowMorePanel
    }
}

extension WPLivePlayerContentView {
    func makeSubviews() -> Void {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        addSubview(effectView)
        addSubview(topView)
        addSubview(bottomView)
    }
    
    func makeConstraints() -> Void {
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.left.top.width.equalToSuperview()
            make.height.equalTo(64)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.bottom.width.equalToSuperview()
            make.height.equalTo(54)
        }
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-13)
        }
        
        backButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(26)
            make.right.lessThanOrEqualToSuperview().offset(-26)
            make.top.equalToSuperview().offset(20)
        }
        
        countLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(button)
        }
        
        liveStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension WPLivePlayerContentView {
    public func animationLayout(safeAreaInsets: UIEdgeInsets, to screenState: WPPlayerContentView.WPPlayerScreenState) {
        if screenState == .fullScreen {
            button.isHidden = true
            topView.isHidden = false
            
        } else {
            button.isHidden = false
            topView.isHidden = true
        }
        isShowMorePanel = true
    }
}
