//
//  WPRegisterAcountController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/10.
//

import UIKit

class WPRegisterAcountController: WPBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubViews()
        makeConstraints()
    }
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
        //tableView.contentInset.top = 8
         view.addSubview(tableView)
        return tableView
    }()
    
}

extension WPRegisterAcountController {
    func makeSubViews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245, 1)
        self.title = "其他"
        self.edgesForExtendedLayout = .bottom
    }

    func makeConstraints() -> Void {
        tableView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
    }
}


extension WPRegisterAcountController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {//关于wupen
                let web:WPWebController = .init()
                web.url = "http://www.wupen.org"
                web.title = "About WuPen"
                self.navigationController?.pushViewController(web, animated: true)
                WPUmeng.um_event_me_click_aboutWupen()
                
            } else if indexPath.row == 1 {//更新
                WPUmeng.um_event_me_click_checkUpdate()
                
                WPAppUpdate.checkAppUpdateVersion(isSHow: true) {[weak self] model, isNew in
                    guard let weakSelf = self else { return  }
                    if isNew {
                        let appUpdateView:WPAppUpdateView = WPAppUpdateView(.update, model: model)
                        appUpdateView.show()
                        
                    } else {
                        let appUpdateView:WPAppUpdateView = WPAppUpdateView(.noUpdate)
                        appUpdateView.show()
                    }
                }
                
            } else {//反馈
                WPUmeng.um_event_me_click_Feedback()
            }
            
        } else {
            let logOutView:WPLogOutView = WPLogOutView(.resiginAcount)
            logOutView.show()
            logOutView.didSelectedBlock = .some({[weak self] in
                guard let weakSelf = self else { return  }
                WPUser.clean()
                weakSelf.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:WPMyInfoCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WPMyInfoCell {
            cell.accessoryType = .disclosureIndicator
            if indexPath.section == 0 {
                cell.textLabel?.font = .systemFont(ofSize: 14)
                cell.textLabel?.textColor = rgba(51, 51, 51, 1)
                cell.layer.cornerRadius = 0
                cell.layer.shadowOpacity = 0
                if indexPath.row == 0 {
                    cell.textLabel?.text = "关于wupen"
                    cell.setCorners([.topLeft,.topRight], cornerRadius: 8)
                    cell.imageView?.image = .init(named: "关于icon")
                    
                } else if indexPath.row == 1 {
                    cell.textLabel?.text = "APP更新"
                    cell.layer.mask = nil
                    cell.imageView?.image = .init(named: "更新icon")
                    
                } else {
                    cell.textLabel?.text = "反馈建议"
                    cell.setCorners([.bottomLeft,.bottomRight], cornerRadius: 8)
                    cell.imageView?.image = .init(named: "反馈icon")
                }
                
            } else {
                cell.textLabel?.font = .boldSystemFont(ofSize: 14)
                cell.textLabel?.textColor = rgba(51, 51, 51, 1)
                cell.textLabel?.text = "注销账号"
                cell.layer.mask = nil
                cell.layer.cornerRadius = 8
                cell.layer.shadowOpacity = 1
            }
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}
