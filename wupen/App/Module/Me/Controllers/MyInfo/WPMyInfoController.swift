//
//  WPMyInfoController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

class WPMyInfoController: WPBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubViews()
        makeConstraints()
    }
    
    lazy var datas: [WPMyInfoModel] = {
        return WPMyInfoModel.datas()
    }()
    
    lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 50.0
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0.01, width: 0, height: 0))
        tableView.cornerRadius = 5
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(WPMyInfoCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
         view.addSubview(tableView)
        return tableView
    }()
    
    lazy var logOut: UIButton = {
        var logOut: UIButton = UIButton()
        logOut.setTitle("登出", for: .normal)
        logOut.titleLabel?.font = .boldSystemFont(ofSize: 14)
        logOut.layer.cornerRadius = 20
        let bg = UIImage.wp.createColorImage(rgba(54, 63, 94, 1), size: CGSize(width: WPScreenWidth-40, height: 40)).wp.roundCorner(20)
        logOut.setBackgroundImage(bg, for: .normal)
        logOut.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            let logOutView = WPLogOutView(.logout)
            logOutView.show()
            logOutView.didSelectedBlock = .some({
                WPUser.clean()
                weakSelf.navigationController?.popViewController(animated: true)
            })
        }).disposed(by: disposeBag)
        view.addSubview(logOut)
        return logOut
    }()
}

extension WPMyInfoController {
    func makeSubViews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245, 1)
        self.title = "个人信息"
        WPUmeng.um_event_me_profile_view()
    }
    
    func makeConstraints() -> Void {
        tableView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        
        logOut.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalToSuperview().offset(-36.0)
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-40)
        }
    }
}

extension WPMyInfoController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {  return 8 }
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {  return 72 }
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let heade  = tableView.dequeueReusableHeaderFooterView(withIdentifier: "group")
        return heade
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "group")
        return footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        WPMyInfoCell.tableView(tableView, didSelectRowAt: indexPath, datas: datas, view: self.view)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return WPMyInfoCell.tableView(tableView, cellForRowAt: indexPath, datas: datas)
    }
}
