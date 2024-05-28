//
//  WPSearchInHistoryView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPSearchInHistoryView: UIView {
    // news数据
    let historyPath = FileManager.default.wp.searchCachePath() + "/searchCache_History.data"
    public var didSelectItemBlock:((_ item:String?)->Void)?
    public var didCleanBlock:(()->Void)?
    
    var serachHistorys:[String] = []
    lazy var historys: [UIButton] = {
        return []
    }()

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
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.text = "最近搜索"
        label.textColor = rgba(51, 51, 51, 1)
        label.font = .boldSystemFont(ofSize: 16)
        self.addSubview(label)
        return label
    }()
    
    lazy var cleanButton: UIButton = {
        var cleanButton: UIButton = UIButton()
        cleanButton.setImage(.init(named: "search_clean_icon"), for: .normal)
        cleanButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.cleanAction()
 
        }).disposed(by: disposeBag)
        self.addSubview(cleanButton)
        return cleanButton
    }()
    

}

extension WPSearchInHistoryView {
    func makeSubviews() -> Void {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
    }
    
    func makeConstraints() -> Void {
        self.label.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.top.equalTo(self).offset(12)
        }
        
        self.cleanButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.label)
            make.right.equalTo(self).offset(-16)
            make.width.height.equalTo(35)
        }
    }
    
    func getSerachHistorys() -> [String] {
        let datas:[String]? = read(Array<String>.self, from: historyPath)
        let sets:NSMutableSet = NSMutableSet(array: datas ?? [])
        
        let serachHistorys:[String] = (sets.allObjects as? [String]) ?? []
        return serachHistorys
    }
    
   
}


extension WPSearchInHistoryView {
    public func updateLoads ()->Void {
        let serachHistorys:[String] = getSerachHistorys()
        self.serachHistorys = serachHistorys
        
        self.historys.forEach { button in
            button.removeFromSuperview()
        }
        
        var y:CGFloat = 49.0
        let x:CGFloat = 16.0
        var lastBtn:UIButton? = nil
        var isTowLine:Bool = false
        for i in 0..<(serachHistorys.count) {
            var text:String = serachHistorys[i]
            if text.count > 12 {
                let range = text.index(text.startIndex, offsetBy: 12)
                text = String(text[..<range]) + ".."
            }
            
            let button:UIButton = createItem(text: text)
            button.tag = i
            
            var width:CGFloat = button.width + 32.0
            if width >= 200 {
               width = 200
            }
            
            var leftX:CGFloat = x
            if lastBtn != nil {
                leftX = (lastBtn?.right ?? 0) + 10
            }
            
            if (leftX + width) > (WPScreenWidth-32) {
                if isTowLine {
                    button.removeFromSuperview()
                    break
                }
                
                leftX = x
                y += 40 + 16
                isTowLine = true
            }
            
            button.width = width
            button.x = leftX
            button.y = y
            lastBtn = button
            self.historys.append(button)
        }
        
        if serachHistorys.count > 0 {
            self.height = 21 + (self.historys.last?.bottom ?? 0)
            
        } else {
            self.height = 0
        }
    }
    
   func cleanAction()->Void {
        self.historys.forEach { button in
            button.removeFromSuperview()
        }
        self.historys.removeAll()
       
        KakaJSON.write([], to: URL.init(fileURLWithPath: historyPath))
        self.height = 0
        guard let cleanBlock = self.didCleanBlock else { return}
        cleanBlock()
    }
    
    func createItem(text:String) -> UIButton {
        let button:UIButton = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = rgba(245, 245, 245, 1)
        button.setTitle(text, for: .normal)
        button.setTitleColor(rgba(102, 102, 102, 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.sizeToFit()
        button.height = 40
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let block = self?.didSelectItemBlock, let serachHistorys = self?.serachHistorys else {return}
            let i:Int = button.tag
            if i < (serachHistorys.count) {
                var text:String = serachHistorys[i]
                block(text.wp.trim())
            }
            
        }).disposed(by: disposeBag)
        self.addSubview(button)
        return button
    }
    
    func saveHistory(keyWorld:String?) -> Void {
        if keyWorld?.wp.trim().isEmpty == false {
            let datas:[String]? = read(Array<String>.self, from: historyPath)
            let newDatas:NSMutableArray = NSMutableArray(array: datas ?? [])
          
            newDatas.insert(keyWorld?.wp.trim() as Any, at: 0)
            if newDatas.count >= 15 {
               newDatas.removeLastObject()
            }
            
            let sets:NSMutableSet = NSMutableSet(array: newDatas as! [Any])
            KakaJSON.write(sets.allObjects, to: URL.init(fileURLWithPath: historyPath))
        }
    }
}
