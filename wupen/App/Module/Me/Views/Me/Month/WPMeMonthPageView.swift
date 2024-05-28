//
//  WPMeMonthPageView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/2.
//

import UIKit
import FSPagerView

class WPMeMonthPageView: UIView {

    public var didBlock:((_ month:Int)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var datas: [String] = {
        if "zh_CN" == Locale.current.identifier {
            return ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月", "十一月", "十二月"]
        }
        //January, February, March, April, May, June, July, August, September, October, November, December
        return ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct", "Nov", "Dec"]
    }()
    
    private var currentIndex:Int = 1
    
    public var index:Int? {
        didSet {
            var i:Int = index ?? 0
            i = i - 1
            
            if (i < 0) || (i >= 12 ){
                i = 0
            }
            
            self.currentIndex = i
            self.pagerView.reloadData()
 
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.23) {
                self.pagerView.scrollToItem(at: self.currentIndex, animated: true)
            }
        }
    }
    
    lazy var pagerView: FSPagerView = {
        let pagerView: FSPagerView = FSPagerView()
        pagerView.isUserInteractionEnabled = true
        pagerView.frame = CGRect(x: 0, y: 0, width: self.width, height: 25)
        
        pagerView.register(WPHomeMonthPageCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.itemSize = CGSize(width: self.width/5, height: 25)
 
        pagerView.interitemSpacing = 0
        pagerView.automaticSlidingInterval = 0
        pagerView.isScrollEnabled = false
        pagerView.clipsToBounds = true
        pagerView.isInfinite = true
        pagerView.delegate = self
        pagerView.dataSource = self
        
        self.addSubview(pagerView)
        return pagerView
    }()
    
    
    func setup() -> Void {
        self.isUserInteractionEnabled = true
        self.pagerView.reloadData()
        self.currentIndex = 1
        
    }
}

extension WPMeMonthPageView:FSPagerViewDelegate,FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.datas.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell:WPHomeMonthPageCell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! WPHomeMonthPageCell
        if index < self.datas.count {
            let text = self.datas[index]
            cell.hotNewsTextLabel.text = text
            if (self.currentIndex == index) {
                cell.isIndex = true
            } else {
                cell.isIndex = false
            }
        }
        return cell
    }
    
    // MARK: FSPagerViewDelegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        guard let didBlock = self.didBlock else { return}
        didBlock(index+1)
        
        self.currentIndex = index
        self.pagerView.reloadData()
    }
}
