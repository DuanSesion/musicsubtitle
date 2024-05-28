//
//  WPSystemNoticeController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/16.
//

import UIKit

class WPSystemNoticeController: WPBaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubViews()
        makeConstraints()
    }
    

    lazy var systemDatas: [WPNoticeModel] = {
        return []
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
        tableView.register(WPNoticeCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPSystemNoticeCell.self, forCellReuseIdentifier: "system")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.delegate = self
        tableView.dataSource = self
         view.addSubview(tableView)
        return tableView
    }()
    
    lazy var emptyView: UIView = {
        var emptyView: UIView = createEmptyView("")
        view.insertSubview(emptyView, at: 0)
        return emptyView
    }()
}

extension WPSystemNoticeController {
 
    func deleteAction(_ notice:WPNoticeModel) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "") {[weak self]  action, view, block in
            block(true)
            notice.deleted()
            let index = self?.systemDatas.firstIndex { no in
               return notice.id == no.id
            }
            
            if let index = index {
                if index < (self?.systemDatas.count ?? 0) {
                   self?.systemDatas.remove(at: index)
                }
            }
            self?.tableView.reloadData()
        }

        let img = UIImage(named: "notice_delete_icon")?.withRenderingMode(.alwaysOriginal)
        delete.image = img
        delete.backgroundColor = rgba(245, 245, 245, 1)
        return delete
    }
    
    func reMarkAction(_ notice:WPNoticeModel) -> UIContextualAction {
        let mark = UIContextualAction(style: .normal, title: "") {[weak self] action, view, block in
            block(true)
            notice.saveIsRead()
            self?.tableView.reloadData()
        }

        let markImg = UIImage(named: "notice_red_icon")?.withRenderingMode(.alwaysOriginal)
        mark.image = markImg
        mark.backgroundColor = rgba(245, 245, 245, 1)
        return mark
    }
}


extension WPSystemNoticeController {
    func makeSubViews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245, 1)
        self.title = "系统通知"
        setNavColor(rgba(245, 245, 245, 1))
        emptyView.isHidden = true
        WPUmeng.um_event_me_click_notification(true)
    }
    
    func makeConstraints() -> Void {
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.reloadData()
    }
}

extension WPSystemNoticeController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WPNoticeCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WPNoticeCell
        if indexPath.section < systemDatas.count {
            let model = systemDatas[indexPath.section]
            
            cell.messageBade.isHidden = (model.isRead)
            cell.label.text = model.title?.wp.trim()
            cell.subLabel.text = model.content?.wp.trim()
            cell.timeLabel.text = "-"
            if let createdTime = model.createdTime {
                let date:Date = Date.jk.formatterTimeStringToDate(timesString: createdTime, formatter: "yyyy-MM-dd HH:mm:ss")
                cell.timeLabel.text = date.jk.callTimeAfterNow()
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.systemDatas.count
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
        if indexPath.section < systemDatas.count {
            let model = systemDatas[indexPath.section]
            let delete = deleteAction(model)
            let mark = reMarkAction(model)
            
            if model.isRead == false {
                let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [delete,mark])
                swipeActionsConfiguration.performsFirstActionWithFullSwipe = false
                return swipeActionsConfiguration
                
            } else {
                let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [delete])
                swipeActionsConfiguration.performsFirstActionWithFullSwipe = false
                return swipeActionsConfiguration
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section < systemDatas.count {
            let model = systemDatas[indexPath.section]
            let showView:WPMeInspectNoticeView = WPMeInspectNoticeView()
            showView.label.text = model.title?.wp.trim()
            showView.textView.text = model.content?.wp.trim()
            showView.show()
            
            model.saveIsRead()
            tableView.reloadData()
        }
    }
}
