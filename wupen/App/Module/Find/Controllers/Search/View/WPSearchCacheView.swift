//
//  WPSearchCacheView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit

class WPSearchCacheView: UIView {
    
    public var didSelectItemBlock:((_ item:String?)->Void)?

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
    
    lazy var searchInHistoryView: WPSearchInHistoryView = {
        var searchInHistoryView: WPSearchInHistoryView = WPSearchInHistoryView()
        searchInHistoryView.width = WPScreenWidth
        searchInHistoryView.didSelectItemBlock = .some({[weak self] item in
            self?.didSelectItemBlock?(item)
        })
        addSubview(searchInHistoryView)
        return searchInHistoryView
    }()
    
    lazy var hotView: WPSearchHotView = {
        var hotView: WPSearchHotView = WPSearchHotView()
        hotView.width = WPScreenWidth
        hotView.didSelectItemBlock = .some({[weak self] item in
            self?.didSelectItemBlock?(item)
        })
        addSubview(hotView)
        return hotView
    }()
    
    var hotkeyworld:[String]!{
        didSet {
            hotView.hotkeyworld = hotkeyworld
        }
    }
    
}

extension WPSearchCacheView{
    func saveHistory(keyWorld:String?) -> Void {
        searchInHistoryView.saveHistory(keyWorld: keyWorld)
    }
    
    func update() -> Void {
        searchInHistoryView.updateLoads()
    }
}

extension WPSearchCacheView {
    func makeSubviews() -> Void {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        update()
    }
    
    func makeConstraints() -> Void {
        searchInHistoryView.isHidden = false
        hotView.snp.makeConstraints { make in
            make.left.width.bottom.equalToSuperview()
            make.top.equalTo(searchInHistoryView.snp.bottom).offset(15)
        }
    }
}
