//
//  WPSubtitleView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/13.
//

import UIKit

class WPSubtitleView: UIView {
    private var screenState: WPPlayerContentView.WPPlayerScreenState = .small
    public var isOn:Bool = false
    public var lanKey:String?
    public var didSelectedBlock:((_ lang:WPLectureVideosLanguageModel)->Void)?
    public var didisOnBlock:((_ isOn:Bool)->Void)?

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
    
    lazy var downButton: UIButton = {
        var downButton: UIButton = UIButton()
        downButton.setImage(.init(named: "play_submite_down_icon"), for: .normal)
        downButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.hidden()
        }).disposed(by: disposeBag)
        let panGest:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGest(pan:)))
        downButton.addGestureRecognizer(panGest)
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
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(153, 153, 153, 0.20)
        contentView.addSubview(line)
        return line
    }()
    
    private lazy var titletLabel: UILabel = {//标题
        let view = UILabel()
        view.text = "字幕显示"
        view.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        view.textColor = rgba(51, 51, 51, 1)
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var subTitletLabel: UILabel = {//标题
        let view = UILabel()
        view.text = "字幕语言"
        view.font = .monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        view.textColor = rgba(51, 51, 51, 1)
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
        contentView.addSubview(view)
        return view
    }()
    
    lazy var switchButton: UISwitch = {
        var switchButton: UISwitch = UISwitch()
        switchButton.onTintColor = rgba(240, 138, 35)
        switchButton.backgroundColor =  .clear
        switchButton.thumbTintColor = .white
        switchButton.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.didisOnBlock?(switchButton.isOn)
        }).disposed(by: disposeBag)
        contentView.addSubview(switchButton)
        return switchButton
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
        tableView.register(WPSubtitleCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        return tableView
    }()
    
    lazy var datas: [WPLectureVideosLanguageModel] = {
        return []
    }()
}

extension WPSubtitleView {
    @objc func panGest(pan:UIPanGestureRecognizer)->Void {
        let height = self.contentView.height
        let tanslation:CGPoint =  pan.translation(in: self)
        if tanslation.y >= 0 {
            if pan.state == .began {
                debugPrint("===begin, ", tanslation.y)
                
            } else  if pan.state == .changed {
                debugPrint("===changed, ", tanslation.y)
                self.contentView.y = height + tanslation.y
                
            } else  if pan.state == .cancelled || pan.state == .ended {
 
                if abs(tanslation.y) >= (height/2) {
                    UIView.animate(withDuration: 0.25) {
                       self.hidden()
                    }
                } else {
                    UIView.animate(withDuration: 0.25) {
                        self.show()
                    }
                }
            }
        } else {
            self.hidden()
        }
    }
}

extension WPSubtitleView {
    func show(screenState: WPPlayerContentView.WPPlayerScreenState = .small,datas:[WPLectureVideosLanguageModel] = [],isOn:Bool=false) -> Void {
        WPKeyWindowDev?.addSubview(self)
        self.isOn = isOn
        self.switchButton.isOn = isOn
        
        updateUI(screenState: screenState)
        self.datas.removeAll()
        self.datas.append(contentsOf: datas)
        self.tableView.reloadData()
    
        if screenState == .small {
            let h = (558.0/812.0) * WPScreenHeight
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

extension WPSubtitleView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if datas.count > indexPath.row {
            let model:WPLectureVideosLanguageModel = datas[indexPath.row]
            
            let SubtitleStr = model.language + "_" + model.title
            WPUmeng.um_event_course_Click_Subtitle(SubtitleStr)
            
            self.didSelectedBlock?(model)
            self.lanKey = model.key
            tableView.reloadData()
            
            if switchButton.isOn == false {
                switchButton.isOn = true
                self.didisOnBlock?(switchButton.isOn)
            }
        }
        self.hidden()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datas.count > indexPath.row {
            let model:WPLectureVideosLanguageModel = datas[indexPath.row]
            let cell:WPSubtitleCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WPSubtitleCell
            cell.setSub(lang: model, langKey: self.lanKey, self.screenState)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
}

extension WPSubtitleView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.25)
        updateUI()
    }
    
    func updateUI(screenState: WPPlayerContentView.WPPlayerScreenState = .small) -> Void {
        self.frame = UIScreen.main.bounds
        self.screenState = screenState
        self.alpha = 1
      
        
        if screenState == .small {
            let h = (558.0/812.0) * WPScreenHeight
            contentView.frame = .init(x: 0, y: WPScreenHeight - h, width: WPScreenWidth, height: h)
            contentView.setCorners([.topLeft,.topRight], cornerRadius: 8)
            contentView.backgroundColor = .white
            titletLabel.textColor = rgba(51, 51, 51, 1)
            subTitletLabel.textColor = rgba(51, 51, 51, 1)
            leftButton.isHidden = true
            downButton.isHidden = false
    
            
        } else {
            let h =  WPScreenHeight
            contentView.frame = .init(x: WPScreenWidth - 312, y: 0, width: 312, height: h)
            contentView.setCorners([.topLeft,.topRight], cornerRadius: 0)
            contentView.backgroundColor = rgba(0, 0, 0, 0.70)
            titletLabel.textColor = rgba(255, 255, 255, 1)
            subTitletLabel.textColor = rgba(255, 255, 255, 1)
            leftButton.isHidden = false
            downButton.isHidden = true
            leftButton.size = CGSize(width: 25, height: 50)
            leftButton.setCorners([.topLeft,.bottomLeft], cornerRadius: 5)
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
        line.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(0.5)
            make.top.equalTo(titletLabel.snp.bottom).offset(13)
        }
        switchButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 54, height: 34))
            make.centerY.equalTo(titletLabel)
            make.right.equalToSuperview().offset(-16)
        }
        subTitletLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(16)
        }
        tableView.snp.makeConstraints { make in
            make.left.width.bottom.equalToSuperview()
            make.top.equalTo(subTitletLabel.snp.bottom).offset(9)
        }
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(contentView.snp.left).offset(0)
            make.size.equalTo(CGSize(width: 25, height: 50))
        }
    }
}
