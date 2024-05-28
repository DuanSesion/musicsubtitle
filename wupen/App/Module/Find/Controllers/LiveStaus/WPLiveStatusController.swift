//
//  WPLiveStatusController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/4.
//

import UIKit

//MARK: 直播详情
class WPLiveStatusController: WPBaseController,WPHiddenNavigationDelegate {
    var model:WPLiveModel!
    private var detail:WPLiveDetailModel?
    
    deinit {
        WPUmeng.um_event_live_detail_click_back()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
        loadRecentLive()
    }
    
    lazy var back: UIButton = {
        var button: UIButton = UIButton()
        let img = UIImage(named: "nav_back")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(img, for: .normal)
        button.contentHorizontalAlignment = .left
        button.rx.tap.subscribe(onNext: { [weak self] recognizer in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        view.addSubview(button)
        return button
    }()
    
    lazy var headerView: WPLiveStatusHeaderView = {
        var headerView: WPLiveStatusHeaderView = WPLiveStatusHeaderView()
        return headerView
    }()

    lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0.01, width: 0, height: 0))
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(WPLiveStatusCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.tableHeaderView = self.headerView
        let tableFooterView = UIView(frame: .init(origin: .zero, size: CGSize(width: WPScreenWidth, height: 30)))
        tableFooterView.backgroundColor = .white
        tableView.tableFooterView = tableFooterView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
         view.addSubview(tableView)
        return tableView
    }()
    
    lazy var bottomView: UIView = {
        var bottomView: UIView = UIView()
        bottomView.backgroundColor = .white
        bottomView.isUserInteractionEnabled = true
        view.addSubview(bottomView)
        return bottomView
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = UIButton()
        let bg = UIImage.wp.createColorImage(rgba(255, 237, 211, 1), size: CGSize(width: WPScreenWidth-32, height: 42)).wp.roundCorner(21)
        let bgDis = UIImage.wp.createColorImage(rgba(188, 188, 188, 1), size: CGSize(width: WPScreenWidth-32, height: 42)).wp.roundCorner(21)
        button.setBackgroundImage(bg, for: .normal)
        button.setBackgroundImage(bgDis, for: .disabled)
        button.setTitleColor(rgba(254, 143, 11, 1), for: .normal)
        button.setTitle("预约直播", for: .normal)
        button.setTitle("直播已结束", for: .disabled)
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.conllect(liveModel: weakSelf.model)
    
        }).disposed(by: disposeBag)
        bottomView.addSubview(button)
        return button
    }()
}

extension WPLiveStatusController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return WPScreenHeight - 78 - self.headerView.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WPLiveStatusCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WPLiveStatusCell
        cell.detail = self.detail
        return cell
    }
}

extension WPLiveStatusController {
    func makeSubviews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245)
        setNavColor(.clear)
        self.edgesForExtendedLayout = .top
        updateLiveState(self.model)
        view.addSubview(bottomView)
        WPUmeng.um_event_live_details_view()
    }
    
    func makeConstraints() -> Void {
        tableView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).offset(30)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.bottom.width.equalToSuperview()
            make.height.equalTo(78)
        }
        
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: WPScreenWidth-32, height: 42))
            make.centerX.equalToSuperview()
            make.top.equalTo(13)
        }
        
        back.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.left.equalTo(15)
            make.top.equalTo(kStatusBarHeight)
        }
    }
    
}

extension WPLiveStatusController {
    func updateLiveState(_ model:WPLiveModel) -> Void {
        model.checkUpdateState()
        button.isHidden = false
        self.headerView.model = model
        self.tableView.reloadData()
        
        let size = CGSize(width: WPScreenWidth-32, height: 42)
        let img = UIImage.wp.createColorImage(rgba(255, 237, 211, 1),size: size).wp.roundCorner(21)//"预约"
        let img1 = UIImage.wp.createColorImage(rgba(211, 211, 211, 1),size: size).wp.roundCorner(21)//已预约
        let img2 = UIImage.wp.createColorImage(rgba(254, 143, 11, 1),size: size).wp.roundCorner(21)//去上课
        let img3 = UIImage.wp.createColorImage(rgba(245, 245, 245, 1),size: size).wp.roundCorner(21)//已结束
        
        if model.isLive {
            let imgl = UIImage(named: "live_state_icon")
            button.setImage(imgl, for: .normal)
            
            button.setTitle("进入", for: .normal)
            button.setBackgroundImage(img2, for: .normal)
            button.setTitleColor(.white, for: .normal)
        
            button.isSelected = false
            button.isEnabled = true
            button.isUserInteractionEnabled = false
            button.isHidden = true
       
     
        } else  if model.status == 0 && model.isConlllect == false {//预约 未结束
            button.setImage(nil, for: .normal)
            
            button.setTitle("预约", for: .normal)
            button.setBackgroundImage(img, for: .normal)
            button.setTitleColor(rgba(254, 143, 11, 1), for: .normal)
            button.isEnabled = true
            button.isSelected = false
            button.isUserInteractionEnabled = true
         
        } else if model.status == 0 && model.isConlllect == true {//已预约 未结束
            button.setImage(nil, for: .normal)
            
            button.setTitle("已预约", for: .normal)
            button.setTitleColor(rgba(255, 255, 255, 1), for: .normal)
            button.setBackgroundImage(img1, for: .normal)
        
            button.isSelected = false
            button.isEnabled = true
            button.isUserInteractionEnabled = true
            
        } else if model.status == 1 {//已结束
            button.setImage(nil, for: .normal)
            
            button.setTitle("已结束", for: .disabled)
            button.setTitleColor(rgba(168, 171, 181, 1), for: .disabled)
            button.setBackgroundImage(img3, for: .disabled)
        
            button.isSelected = false
            button.isEnabled = false
            button.isUserInteractionEnabled = false
        }
    }
}


extension WPLiveStatusController {
    func conllect(liveModel:WPLiveModel) -> Void {
        if liveModel.isConlllect == false {
            liveModel.userCollect {[weak self] model in
                guard let weakSelf = self else { return  }
                
                let result:Bool = (model.jsonModel?.data as? Bool) ?? false
                if result {
                    liveModel.isConlllect = true
                    liveModel.countSubscribe += 1
                    weakSelf.updateLiveState(liveModel)
                    liveModel.updateLiveStateBlock?()
                    
                } else {
                    let ss = model.jsonModel?.msg ?? model.msg
                    weakSelf.view.showMessage(ss)
                }
            }
            
        } else {
            liveModel.userDeCollect {[weak self] model in
                guard let weakSelf = self else { return  }
                
                let result:Bool = (model.jsonModel?.data as? Bool) ?? false
                if result {
                    liveModel.isConlllect = false
                    if liveModel.countSubscribe >= 1 {liveModel.countSubscribe -= 1}
                    weakSelf.updateLiveState(liveModel)
                    liveModel.updateLiveStateBlock?()
                    
                } else {
                    let ss = model.jsonModel?.msg ?? model.msg
                    weakSelf.view.showMessage(ss)
                }
            }
        }
    }
}

extension WPLiveStatusController {
    //MARK: 最近直播详情
    func loadRecentLive() -> Void {
        guard let id = self.model.id else { return  }
        WPLiveModel.findLiveDetail(id) {[weak self] detail in
            guard let weakSelf = self else { return  }
            weakSelf.detail = detail
            weakSelf.headerView.detail = detail
            weakSelf.tableView.reloadData()
        }
    }
}
