//
//  WPCalculateTimeController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPCalculateTimeController: WPBaseController {
    private var pageNum:Int = 0

    lazy var topImageView: UIImageView = {
        var topImageView: UIImageView = UIImageView(image: .init(named: "calculate_tiime_top_icon"))
        topImageView.contentMode = .scaleAspectFill
        topImageView.clipsToBounds = true
        view.addSubview(topImageView)
        return topImageView
    }()
    
    lazy var tableViewHeder: UIView = {
        var tableViewHeder: UIView = UIView(frame: .init(origin: .zero, size: CGSize(width: WPScreenWidth, height: 229.0)))
        tableViewHeder.backgroundColor = .clear
        tableViewHeder.isUserInteractionEnabled = true
        tableViewHeder.clipsToBounds = true
        return tableViewHeder
    }()
    
    lazy var tableViewHederBottom: UIView = {
        var tableViewHederBottom: UIView = UIView(frame: .init(x: 0, y: tableViewHeder.height - 42, width: WPScreenWidth, height: 60.0))
        tableViewHederBottom.layer.cornerRadius = 20
        tableViewHederBottom.clipsToBounds = true
        tableViewHederBottom.backgroundColor = .white
        var label: UILabel = UILabel()
        label.text = "全部"
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        tableViewHederBottom.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(18)
        }
        tableViewHeder.addSubview(tableViewHederBottom)
        return tableViewHederBottom
    }()
    
    lazy var calculateTimLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "0"
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .center
        label.font = UIFont(name: "DIN Alternate", size: 32)
        tableViewHeder.addSubview(label)
        return label
    }()
    
    lazy var scoreSubLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "我的累计学时"
        label.textColor = rgba(73, 107, 147, 1)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        tableViewHeder.addSubview(label)
        return label
    }()
    
    lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 50.0
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0.01, width: 0, height: 0))
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(WPCalculateTimeCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableViewHeder
         view.addSubview(tableView)
        return tableView
    }()
    
    lazy var emptyView: UIView = {
        var emptyView: UIView = createEmptyView("",icon: "comm_empty_icon")
        view.insertSubview(emptyView, at: 0)
        return emptyView
    }()
    
    lazy var datas: [WPMyDurationRecordModel] = {
        return []
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubViews()
        makeConstraints()
        loadDatas()
    }
}

extension WPCalculateTimeController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return WPCalculateTimeCell.tableView(tableView, cellForRowAt: indexPath, datas: self.datas)
    }
}

extension WPCalculateTimeController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
         if y >= 0 && y <= 229.0 {
            topImageView.height = 229.0 - y
            
        } else if y < 0 {
            topImageView.height = 229.0 - y
            
        } else if y > 229.0  {
            topImageView.height = 0
        }
    }
}

extension WPCalculateTimeController {
    func makeSubViews() -> Void {
        setNavColor(.clear)
        self.edgesForExtendedLayout = .top
        self.view.backgroundColor = rgba(255, 255, 255, 1)
        tableViewHederBottom.isHidden = false
        WPUmeng.um_event_me_click_learningHours()
    }
    
    func makeConstraints() -> Void {
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        topImageView.frame = .init(origin: .zero, size: CGSize(width: self.view.width, height: 229.0))
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        calculateTimLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(scoreSubLabel.snp.top).offset(-8)
        }
        
        scoreSubLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(tableViewHederBottom.snp.top).offset(-18)
        }
        
        
        let userInfo = WPUser.user()?.userInfo
        let creditDuration:Int = userInfo?.creditDuration ?? 0
     
        let  hour = creditDuration / 60 / 60
        let  min = (creditDuration - hour * 3600) % 60
        calculateTimLabel.attributedText = getLongTime(hour:hour,min: min)
    }
    
    func getLongTime(hour:Int=0, min:Int=0)->NSAttributedString {
        var str = "\(hour)时\(min)分"
        if hour <= 0 {
            str = "\(min)分"
        }
        
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.yy_font = UIFont(name: "DIN Alternate", size: 32)
        attributedString.yy_color = rgba(51, 51, 51, 1)
        
        let font = UIFont(name: "DIN Alternate", size: 12)
        
        if let position:Range<String.Index> = str.range(of: "时"),
            let range = str.nsRange(from: position) {
            attributedString.yy_setFont(font, range: range)
        }
        
        if let position:Range = str.range(of: "分"),
           let range = str.nsRange(from: position) {
            attributedString.yy_setFont(font, range: range)
        }
        return attributedString
    }
}

extension WPCalculateTimeController {
    func loadDatas() -> Void {
        WPMyDurationRecordModel.getMyDurationRecord(self.pageNum) {[weak self] datas, totalElements in
            guard let weakSelf = self else { return }
            weakSelf.tableView.mj_footer?.endRefreshing()
 
            if weakSelf.pageNum <= 1 {
                weakSelf.datas.removeAll()
                weakSelf.tableView.mj_footer?.isHidden = false
                weakSelf.tableView.mj_footer?.resetNoMoreData()
            }
            
            weakSelf.datas.append(contentsOf: datas)
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
            weakSelf.emptyView.isHidden = !(weakSelf.datas.count == 0)
        }
    }
}
