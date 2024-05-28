//
//  WPNoticeController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

class WPNoticeController: WPBaseController {
    var pageNum:Int = 1
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubViews()
        makeConstraints()
        systemNotice()
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
        tableView.register(WPNoticeCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPSystemNoticeCell.self, forCellReuseIdentifier: "system")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.delegate = self
        tableView.dataSource = self
         view.addSubview(tableView)
        return tableView
    }()
    
    lazy var emptyView: UIView = {
        var emptyView: UIView = createEmptyView("",icon: "comm_empty_icon")
        view.insertSubview(emptyView, at: 0)
        return emptyView
    }()
    
    lazy var datas: [WPUserNoticeModel] = {
        return []
    }()
    
    lazy var systemDatas: [WPNoticeModel] = {
        return []
    }()
}

extension WPNoticeController {
    func makeSubViews() -> Void {
        setNavColor(rgba(245, 245, 245, 1))
        self.view.backgroundColor = rgba(245, 245, 245, 1)
        self.title = "个人消息"
       
        WPUmeng.um_event_me_click_notification()
    }
    
    func makeConstraints() -> Void {
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func makeLoadMore() -> Void {
        let footer = MJRefreshAutoNormalFooter.init {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.pageNum += 1
            weakSelf.readNotice()
        }
        footer.setTitle("emm，好像没有数据了～", for: .noMoreData)
        footer.stateLabel?.textColor = rgba(112,112,112,0.8)
        footer.stateLabel?.font = .systemFont(ofSize: 12)
        tableView.mj_footer = footer
        footer.isHidden = true
    }
}

extension WPNoticeController {
    func rowAction(_ notice:WPUserNoticeModel) -> UISwipeActionsConfiguration {
        let delete = UIContextualAction(style: .destructive, title: "") { action, view, block in
            block(true)
            notice.deleteNotice {[weak self] r in
                guard let weakSelf = self else {return}
                if r {
                    let index = weakSelf.datas.firstIndex { no in
                        return no.id == notice.id
                    }
                    if let index = index {
                        if index >= 0 && index < weakSelf.datas.count {
                            weakSelf.datas.remove(at: index)
                            weakSelf.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        let img = UIImage(named: "notice_delete_icon")?.withRenderingMode(.alwaysOriginal)
        delete.image = img
        delete.backgroundColor = rgba(245, 245, 245, 1)
        
        if notice.isShow  {
            let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [delete])
            swipeActionsConfiguration.performsFirstActionWithFullSwipe = false
            return swipeActionsConfiguration
            
        } else {
            let mark = UIContextualAction(style: .normal, title: "") { action, view, block in
                block(true)
                notice.readNotice {[weak self] in
                    guard let weakSelf = self else {return}
                    weakSelf.tableView.reloadData()
                }
            }
            
            let markImg = UIImage(named: "notice_red_icon")?.withRenderingMode(.alwaysOriginal)
            mark.image = markImg
            mark.backgroundColor = rgba(245, 245, 245, 1)

            let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [delete,mark])
            swipeActionsConfiguration.performsFirstActionWithFullSwipe = false
            return swipeActionsConfiguration
        }
    }
}

extension WPNoticeController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count + ((self.systemDatas.count > 0) ? 1 : 0)
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
        return 74
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let heade  = tableView.dequeueReusableHeaderFooterView(withIdentifier: "group")
        return heade
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "group")
        return footer
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (self.systemDatas.count > 0) {
            if indexPath.section == 0 {
                return nil
                
            } else {
                let section = indexPath.section - 1
                if section < datas.count {
                    let model = datas[section]
                    return rowAction(model)
                }
            }
        }
        
        if indexPath.section < datas.count {
            let model = datas[indexPath.section]
            return rowAction(model)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.systemDatas.count > 0) {
            if indexPath.section == 0  {
                let vc:WPSystemNoticeController = WPSystemNoticeController()
                vc.systemDatas = self.systemDatas
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let section = indexPath.section - 1
                if section < datas.count {
                    let model = datas[section]
                    let showView:WPMeInspectNoticeView = WPMeInspectNoticeView()
                    showView.model = model
                    showView.show()
                    model.readNotice {[weak self] in
                        guard let weakSelf = self else {return}
                        weakSelf.tableView.reloadData()
                    }
                }
            }
            
        } else {
            if indexPath.section < datas.count {
                let model = datas[indexPath.section]
                let showView:WPMeInspectNoticeView = WPMeInspectNoticeView()
                showView.model = model
                showView.show()
                
                model.readNotice {[weak self] in
                    guard let weakSelf = self else {return}
                    weakSelf.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.systemDatas.count > 0) {
            if indexPath.section == 0  {
                let cell:WPSystemNoticeCell = tableView.dequeueReusableCell(withIdentifier: "system", for: indexPath) as! WPSystemNoticeCell
                cell.model = self.systemDatas
                return cell
            }
        }

        let cell:WPNoticeCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WPNoticeCell
        if indexPath.section < datas.count {
            let model = datas[indexPath.section]
            cell.model = model
        }
        return cell
    }
}

extension WPNoticeController {
    func readNotice() -> Void {
        WPUserNoticeModel.getNotice(self.pageNum) {[weak self] r, d,totalElements in
            guard let weakSelf = self else { return }
            weakSelf.tableView.mj_footer?.endRefreshing()
            if weakSelf.pageNum <= 1 {
                weakSelf.datas.removeAll()
                weakSelf.tableView.mj_footer?.isHidden = false
                weakSelf.tableView.mj_footer?.resetNoMoreData()
            }
            
            weakSelf.datas.append(contentsOf: d)
            weakSelf.tableView.reloadData()
            
            let totalElements = totalElements
            if weakSelf.datas.count == totalElements && totalElements == 0 {
                weakSelf.tableView.mj_footer?.isHidden = true
                
            } else if weakSelf.datas.count == totalElements {
                weakSelf.tableView.mj_footer?.endRefreshingWithNoMoreData()
                weakSelf.tableView.mj_footer?.isHidden = (totalElements < 10)
                 
            } else {
                weakSelf.tableView.mj_footer?.resetNoMoreData()
                weakSelf.tableView.mj_footer?.isHidden = false
            }
            
            if (weakSelf.datas.count == 0) && (weakSelf.systemDatas.count == 0) {
                weakSelf.emptyView.isHidden = false
            } else {
                weakSelf.emptyView.isHidden = true
            }
        }
    }
}

extension WPNoticeController {
    func systemNotice() -> Void {
        WPNoticeModel.getNotice {[weak self] isRed, datas in
            guard let weakSelf = self else { return }
            weakSelf.systemDatas.removeAll()
            weakSelf.systemDatas.append(contentsOf: datas)
            weakSelf.tableView.reloadData()
            weakSelf.readNotice()
        }
    }
}

