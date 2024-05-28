//
//  WPCourseVideosView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/14.
//

import UIKit

class WPCourseVideosView: UIView {
    private var screenState: WPPlayerContentView.WPPlayerScreenState = .small
    public var didSelectedBlock:((_ video:WPLectureVideosModel)->Void)?

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

    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        return contentView
    }()
    
    lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0.01, width: 0, height: 0))
        tableView.separatorColor = rgba(153, 153, 153, 0.20)
        tableView.separatorInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(WPCourseVideosCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        return tableView
    }()
    
    lazy var downButton: UIButton = {
        var downButton: UIButton = UIButton()
        downButton.setImage(.init(named: "play_submite_down_icon"), for: .normal)
        downButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.hidden()
        }).disposed(by: disposeBag)
//        let panGest:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGest(pan:)))
//        downButton.addGestureRecognizer(panGest)
        contentView.addSubview(downButton)
        return downButton
    }()
    
    lazy var leftButton: UIButton = {
        var leftButton: UIButton = UIButton()
        leftButton.backgroundColor = rgba(0, 0, 0, 0.7)
        leftButton.setImage(.init(named: "me_more_icon")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        leftButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.hidden()
        }).disposed(by: disposeBag)
        self.addSubview(leftButton)
        return leftButton
    }()
    
    private lazy var titletLabel: UILabel = {//标题
        let view = UILabel()
        view.text = "课程列表"
        view.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        view.textColor = rgba(51, 51, 51, 1)
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = true
        contentView.addSubview(view)
        return view
    }()
    
    lazy var videos:[WPLectureVideosModel] = {
        return []
    }()
}

extension WPCourseVideosView {
    func show(screenState: WPPlayerContentView.WPPlayerScreenState = .small,videos:[WPLectureVideosModel] = []) -> Void {
        WPKeyWindowDev?.addSubview(self)
        updateUI(screenState: screenState)
        self.videos.removeAll()
        self.videos.append(contentsOf: videos)
        self.tableView.reloadData()
        
        WPPlayerManager.default.updateCurrentIndexBlock = .some({[weak self] in
            guard let weakSelf = self else { return  }
            weakSelf.tableView.reloadData()
        })
    
        if screenState == .small {
            let h = (608.0/812.0) * WPScreenHeight
            contentView.y = WPScreenHeight
            UIView.animate(withDuration: 0.25) {
                self.contentView.y = WPScreenHeight - h
            }
            
        } else {
            contentView.x = WPScreenWidth
            UIView.animate(withDuration: 0.25) {
                self.contentView.x = WPScreenWidth - 312
            }
        }
    }
    
    func hidden() -> Void {
        if screenState == .small {
            UIView.animate(withDuration: 0.25) {
                self.contentView.y = WPScreenHeight
                self.alpha = 0
                
            } completion: { r in
                self.removeFromSuperview()
            }
            
        } else {
            UIView.animate(withDuration: 0.25) {
                self.contentView.x = WPScreenWidth
                self.alpha = 0
                
            } completion: { r in
                self.removeFromSuperview()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self {
            hidden()
        }
    }
}

extension WPCourseVideosView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if videos.count > indexPath.row {
            let model:WPLectureVideosModel = videos[indexPath.row]
            let cell:WPCourseVideosCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WPCourseVideosCell
            
            let currentVideo = WPPlayerManager.default.video
            cell.setSub(video: model, curretVideo: currentVideo, didPlayBlock: {[weak self] video in
                guard let weakSelf = self else { return  }
                if video.video?.id == WPPlayerManager.default.video?.video?.id { return }
                WPPlayerManager.default.video?.pause()
      
                weakSelf.didSelectedBlock?(video)
                tableView.reloadData()
                 
            },self.screenState)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
}

extension WPCourseVideosView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.25)
    }
    
    func updateUI(screenState: WPPlayerContentView.WPPlayerScreenState = .small) -> Void {
        self.frame = UIScreen.main.bounds
        self.screenState = screenState
        self.alpha = 1
        
        if screenState == .small {
            let h = (608.0/812.0) * WPScreenHeight
            contentView.frame = .init(x: 0, y: WPScreenHeight - h, width: WPScreenWidth, height: h)
            contentView.setCorners([.topLeft,.topRight], cornerRadius: 8)
            contentView.backgroundColor = .white
            titletLabel.textColor = rgba(51, 51, 51, 1)
            leftButton.isHidden = true
            downButton.isHidden = false
            
            titletLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(36)
            }
            
        } else {
            let h =  WPScreenHeight
            contentView.frame = .init(x: WPScreenWidth - 312, y: 0, width: 312, height: h)
            contentView.setCorners([.topLeft,.topRight], cornerRadius: 0)
            contentView.backgroundColor = rgba(0, 0, 0, 0.70)
            titletLabel.textColor = rgba(255, 255, 255, 1)
            leftButton.isHidden = false
            downButton.isHidden = true
            leftButton.size = CGSize(width: 25, height: 50)
            leftButton.setCorners([.topLeft,.bottomLeft], cornerRadius: 5)
            
            titletLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(29)
            }
        }
    }
    
    func makeConstraints () {
        downButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerX.top.equalToSuperview()
        }
        titletLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(16)
        }
        tableView.snp.makeConstraints { make in
            make.left.width.bottom.equalToSuperview()
            make.top.equalTo(titletLabel.snp.bottom).offset(9)
        }
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(contentView.snp.left).offset(0)
            make.size.equalTo(CGSize(width: 25, height: 50))
        }
    }
    
}
