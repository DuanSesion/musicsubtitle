//
//  WPMenuItemListView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/9.
//

import UIKit

class WPMenuItemListView: UIView {
    var hiddenBlock:(()->Void)?
    var didSelectedBlock:((_ :Any)->Void)?
    
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
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(238, 238, 238, 1)
        addSubview(line)
        return line
    }()
    
    lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0.01, width: 0, height: 0))
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WPCustomHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "group")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
         addSubview(tableView)
        return tableView
    }()
    
    var datas:[Any]? {
        didSet {
          tableView.setCorners([.bottomLeft,.bottomRight], cornerRadius: 12)
          tableView.reloadData()
        }
    }
}
extension WPMenuItemListView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesBegan(touches, with: event)
         if touches.first?.view == self {
            hidden()
         }
    }
}
extension WPMenuItemListView {
    func show(view:UIView) -> Void {
        view.addSubview(self)
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.alpha = 1
            self?.tableView.y = 0
        }
    }
    
    func hidden() -> Void {
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.tableView.y = -446.0
            
        } completion: {[weak self] r in
            self?.alpha = 0
            self?.hiddenBlock?()
            self?.removeFromSuperview()
        }
    }
}

extension WPMenuItemListView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (datas?.count ?? 0) > indexPath.row {
            let model = datas?[indexPath.row]
            self.didSelectedBlock?(model as Any)
            debugPrint(model, "=====>",indexPath.row)
        }
        self.hidden()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 13)
        cell.textLabel?.textColor = rgba(51, 51, 51, 1)
        
        if (datas?.count ?? 0) > indexPath.row {
            let model = datas?[indexPath.row]
            if let model:WPClassificationsModel = model as? WPClassificationsModel {
                cell.textLabel?.text = (WPLanguage.chinessLanguage()) ? model.chineseName : model.englishName
                
            } else if let model:WPCouserModel = model as? WPCouserModel {
                cell.textLabel?.text = (WPLanguage.chinessLanguage()) ? model.chineseName : model.englishName
            }
        }
        return cell
    }
}

extension WPMenuItemListView {
    func makeSubviews() {
        self.backgroundColor = rgba(0, 0, 0, 0.5)
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.alpha = 0
        
        let h = kNavigationBarHeight + 44
        self.frame = .init(x: 0, y: h, width: WPScreenWidth, height: WPScreenHeight - h)
        tableView.frame = CGRect(x: 0, y: -446.0, width: WPScreenWidth, height: 446.0)
        tableView.setCorners([.bottomLeft,.bottomRight], cornerRadius: 12)
    }
    
    func makeConstraints() -> Void {
        line.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview().offset(-32)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
