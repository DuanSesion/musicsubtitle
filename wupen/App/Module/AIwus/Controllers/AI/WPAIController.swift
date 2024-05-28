//
//  WPAIController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/4.
//

import UIKit

class WPAIController: WPBaseController,WPHiddenNavigationDelegate,WPNotPanGestureRecognizerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        WPUmeng.um_event_AIWUS_Close(false)
    }
    
    lazy var background: UIImageView = {
        var background: UIImageView = .init(image: .init(named: "AI_background_icon"))
        background.isUserInteractionEnabled = true
        background.contentMode = .scaleAspectFill
        view.addSubview(background)
        return background
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        let img = UIImage(systemName: "xmark")?.sd_resizedImage(with: CGSize(width: 24, height: 24), scaleMode: .fill)
        button.setImage(img?.withTintColor(rgba(90, 90, 90), renderingMode: .alwaysOriginal), for: .normal)
        button.rx.tap.subscribe(onNext: { [weak self] recognizer in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        background.addSubview(button)
        return button
    }()
    
    lazy var userNameLabel:UILabel = {
        var userNameLabel:UILabel  = UILabel()
        userNameLabel.textColor = rgba(51, 51, 51, 1)
        userNameLabel.text = "教授名字"
        userNameLabel.font = .systemFont(ofSize: 18)
        background.addSubview(userNameLabel)
        return userNameLabel
    }()
    
    lazy var moreButton: UIButton = {
        var button: UIButton = UIButton()
        let img = UIImage(named: "AI_more_icon")
        button.setImage(img, for: .normal)
        button.rx.tap.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.moreExpendView.isExpend = true
            UIView.animate(withDuration: 0.25) {
                weakSelf.moreExpendView.y = 0
            }
            
        }).disposed(by: disposeBag)
        background.addSubview(button)
        return button
    }()
    
    lazy var moreExpendView: WPAIMoreExpendView = {
        let frame = CGRect(origin: .zero, size: CGSize(width: WPScreenWidth, height: 238))
        var moreExpendView: WPAIMoreExpendView = WPAIMoreExpendView(frame: frame)
        background.addSubview(moreExpendView)
        return moreExpendView
    }()
    
    lazy var bottomView: WPAIBottomView = {
        let frame = CGRect(origin: .zero, size: CGSize(width: WPScreenWidth, height: 98))
        var bottomView: WPAIBottomView = WPAIBottomView(frame: frame)
        bottomView.didSendBlock = .some({[weak self] text in
            guard let weakSelf = self else { return  }
            bottomView.isUserInteractionEnabled = false
            weakSelf.send(text)
        })
        bottomView.showKeyBordBlock = .some({ [weak self] in
            guard let weakSelf = self else { return  }
            weakSelf.reloadData(false)
        })
        background.addSubview(bottomView)
        return bottomView
    }()
    
    
    lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0.01, width: 0, height: 0))
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(WPWPAICell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPAIMeCellCell.self, forCellReuseIdentifier: "me")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.delegate = self
        tableView.dataSource = self
         background.addSubview(tableView)
        return tableView
    }()
    
    lazy var datas: [WPAIModel] = {
        let model = WPAIModel()
        model.isMe = true
        model.textMsg = "您好！"
        let model1 = WPAIModel()
        model1.textMsg = "您好！请问有什么问题我可以帮您解答吗？"
        return [model,model1]
    }()
    
    lazy var caches: [WPAIModel] = {
        var caches: [WPAIModel] = []
        if let datas = WPAIModel.caches() {
            caches.append(contentsOf: datas)
        }
        return caches
    }()
}

extension WPAIController {
    func makeSubviews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245)
        self.datas.append(contentsOf: self.caches)
        WPUmeng.um_event_AIWUS_Close(true)
    }
    
    func makeConstraints() -> Void {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalTo(10+kStatusBarHeight)
            make.right.equalToSuperview().offset(-16)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(background).offset(16)
            make.centerY.equalTo(button)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel)
            make.left.equalTo(userNameLabel.snp.right).offset(2)
        }
        
        bottomView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(background).offset(kNavigationBarHeight+29)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        moreExpendView.y = -moreExpendView.height
        reloadData()
    }
}


extension WPAIController:UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let h:CGFloat = 44+9+24
//        if datas.count > indexPath.row {
//            let model = datas[indexPath.row]
//            if model.isMe {
//                
//                let w = (WPScreenWidth - 76 - 32)
//                let h = model.textMsg.heightWithStringAttributes(attributes: [.font:UIFont.systemFont(ofSize: 14)], fixedWidth: w)
//                
//                
//                var height = h + 24
//                
//                debugPrint(height, model.textMsg)
//                
//                
//                if height < 44 + 24{
//                   height = 44 + 24
//                }
//                return height
//                
//            } else {
//                let w = (WPScreenWidth - 81 - 44)
//                let h = model.textMsg.heightWithStringAttributes(attributes: [.font:UIFont.systemFont(ofSize: 14)], fixedWidth: w)
//                
//                var height = h  + 48
//                if height < h {
//                   height = h
//                }
//                return height
//            }
//        }
//        return h
//    }
    
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datas.count > indexPath.row {
           let model = datas[indexPath.row]
            if model.isMe {
                let cell:WPAIMeCellCell = tableView.dequeueReusableCell(withIdentifier: "me", for: indexPath) as! WPAIMeCellCell
                cell.model = model
                
                return cell
                
            } else {
                let cell:WPWPAICell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WPWPAICell
                cell.model = model
                
                return cell
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}


extension WPAIController {
    func send(_ text:String) -> Void {
        let me = WPAIModel()
        me.isMe = true
        me.textMsg = text
        me.time = "\(Date.jk.currentDate.timeIntervalSince1970)"
        
        let role = WPAIModel()
        role.isSend = true
        role.textMsg = "正在思考…"
        role.time = "\(Date.jk.currentDate.timeIntervalSince1970 + 1)"
        
        datas.append(me)
        datas.append(role)
        reloadData()
        
        self.view.showUnityNetActivity()
        self.view.endEditing(true)
        role.sendAIMessage(text) {[weak self] response in
            guard let weakSelf = self else { return  }
            weakSelf.bottomView.isUserInteractionEnabled = true
            weakSelf.view.removeNetActivity()
            weakSelf.reloadData()
            debugPrint(response.code)
            if response.code == 200 {
                weakSelf.caches.append(contentsOf: [me,role])
                WPAIModel.save(weakSelf.caches)
            }
        }
    }
}


extension WPAIController {
    func addRefreshHeader() {
        tableView.mj_header = WPRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshData))
    }
}

extension WPAIController {
   @objc func refreshData() {
       tableView.mj_header?.endRefreshing()
    }
    
    func reloadData(_ animated:Bool=true) {
        // 这里是你的数据刷新逻辑...
        tableView.reloadData() // 刷新表格数据

        // 确保数据源已经有数据，避免因索引越界导致的崩溃
        guard tableView.numberOfRows(inSection: 0) > 0 else { return }

        // 计算最后一行的索引路径
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0)

        UIView.animate(withDuration: 0.15) {
            // 滚动到表格底部
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }

}
