//
//  WPMenuCheckView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/7.
//

import UIKit

enum WPMenuCheckType:Int {
    case live
    case cause
}

enum WPMenuCheckLiveType:Int {
    case all = 0
    case wait = 1
    case end = 3
}

enum WPMenuCheckCourseType:Int {
    case courseClass = 0 // 课程分类
    case courseSeries = 1 // 课程系列
}

class WPMenuCheckView: UIView {
    private var type:WPMenuCheckType = .cause
    private var searchBlock:((_ searchText:String?)->Void)?
    
    public var checkSequenceBlock:((_ aes:Bool)->Void)?
    public var liveBlock:((_ :WPMenuCheckLiveType)->Void)?
    public var checkCouresBlock:((_ index:Int)->Void)?
    public var textDidBeginEditingBlock:(()->Void)?
    
    var currentButon: UIButton = UIButton()
    init(_ menuType:WPMenuCheckType,searchBlock:((_ searchText:String?)->Void)?=nil) {
        super.init(frame: .zero)
        self.type = menuType
        makeSubviews()
        makeConstraints()
        self.searchBlock = searchBlock
    }
    
    deinit {
        debugPrint("---init---", self)
    }

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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setCorners([.bottomLeft, .bottomRight], cornerRadius: 12)
    }
    
    lazy var back: UIButton = {
        var button: UIButton = UIButton()
        let img = UIImage(named: "nav_back")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(img, for: .normal)
        button.contentHorizontalAlignment = .left
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            weakSelf.yy_viewController?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.isUserInteractionEnabled = true
        textLabel.text = "全部课程"
        textLabel.textColor = rgba(51, 51, 51, 1)
        textLabel.font = .boldSystemFont(ofSize: 16)
        let tap:UITapGestureRecognizer = .init()
        tap.rx.event.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.yy_viewController?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        textLabel.addGestureRecognizer(tap)
        addSubview(textLabel)
        return textLabel
    }()
    
    
    lazy var searchBar: UISearchBar = {
        var searchBar: UISearchBar = UISearchBar(frame: .zero)
        searchBar.backgroundColor = rgba(245, 245, 245, 1)
        searchBar.layer.cornerRadius = 17
        searchBar.clipsToBounds = true
        searchBar.returnKeyType = .search
        searchBar.searchTextField.font = .systemFont(ofSize: 14)
        searchBar.searchTextField.textColor = rgba(51, 51, 51)
        
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = rgba(51, 51, 51, 1)
        searchBar.setImage(.init(named: "search_clean_button"), for: .clear, state: .normal)
        
        let leftView:UIImageView? = searchBar.searchTextField.leftView as? UIImageView
        leftView?.tintColor = rgba(168, 171, 181, 1)
        
        let size = CGSize(width: 226, height: 34)
        let img = UIImage.wp.createColorImage(rgba(245, 245, 245, 1), size: size).wp.roundCorner(17)
        searchBar.setBackgroundImage(img, for: .any, barMetrics: .default)
        
        searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            weakSelf.textDidBeginEditingBlock?()
            
        }).disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            weakSelf.searchBlock?(searchBar.text?.wp.trim())
        }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            searchBar.resignFirstResponder()
        }).disposed(by: disposeBag)
         addSubview(searchBar)
        return searchBar
    }()
    
    lazy var checkSequence: UIButton = {
        var button: UIButton = UIButton()
        let img = UIImage(named: "menu_sequence_icon")
        button.setImage(img, for: .normal)
        
        let imghi = UIImage(named: "menu_sequence_icon")?.withTintColor(rgba(188, 188, 188))
        button.setImage(imghi, for: .selected)
        
        button.rx.tap.subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return }
            button.isSelected = !button.isSelected
            weakSelf.checkSequenceBlock?(button.isSelected)
            if weakSelf.type == .cause {
                
            }
            
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }()
    
    
    //课程分类
    lazy var courseClassDatas: [WPClassificationsModel] = {
        return []
    }()
    //课程系列
    lazy var courseSeriesDatas: [WPCouserModel] = {
        return []
    }()
    
    var selectedModel:Any? {
        didSet {
            if let model:WPClassificationsModel = selectedModel as? WPClassificationsModel {
                if WPLanguage.chinessLanguage() {
                    currentButon.setTitle(model.chineseName, for: .normal)
                } else {
                    currentButon.setTitle(model.englishName, for: .normal)
                }
                
            } else if let model:WPCouserModel = selectedModel as? WPCouserModel {
                if WPLanguage.chinessLanguage() {
                    currentButon.setTitle(model.chineseName, for: .normal)
                } else {
                    currentButon.setTitle(model.englishName, for: .normal)
                }
                
                currentButon.sizeToFit()
                currentButon.jk.setImageTitleLayout(.imgRight, spacing: 4)
                if currentButon.width > 200 {
                    currentButon.width = 200
                }
                
                let x:CGFloat = 16.0 + 52 + 19 + 23.0
                currentButon.x = x
            }
        }
    }
    
    var defaultModel:WPCouserModel? {
        didSet {
            if let model = defaultModel {
                if let button: UIButton = self.viewWithTag(101) as? UIButton {
                    if WPLanguage.chinessLanguage() {
                        button.setTitle(model.chineseName, for: .normal)
                    } else {
                        button.setTitle(model.englishName, for: .normal)
                    }
                    
                    button.sizeToFit()
                    button.jk.setImageTitleLayout(.imgRight, spacing: 4)
                    if button.width > 200 {
                        button.width = 200
                    }
                    
                    let x:CGFloat = 16.0 + 52 + 19 + 23.0
                    button.x = x
                }
            }
        }
    }
}

extension WPMenuCheckView {
    func makeMarkButtons() -> Void {
        if type == .cause {
            makeCousesItem()
            getItemDatas()
            
        } else {
            let marks = ["全部","待开始","已结束"]
            for (i,text) in marks.enumerated() {
                let button: UIButton = UIButton()
                button.setTitle(text, for: .normal)
                button.setTitleColor(rgba(51, 51, 51, 1), for: .selected)
                button.setTitleColor(rgba(136, 136, 136, 1), for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 14)
                button.titleLabel?.lineBreakMode = .byTruncatingTail
                button.sizeToFit()
                let lineHi = UIImage.wp.createColorImage(rgba(254, 143, 11, 1), size: CGSize(width: 12, height: 3)).wp.roundCorner(1.5)
                let lineNo = UIImage.wp.createColorImage(.clear, size: CGSize(width: 12, height: 3)).wp.roundCorner(1.5)
                
                button.setImage(lineHi, for: .selected)
                button.setImage(lineNo, for: .normal)
                
                let yy:CGFloat = 13 + kNavigationBarHeight
                let ww:CGFloat = 52 + 19
                let xx:CGFloat = 16.0 + CGFloat(i)*ww + CGFloat(i)*23.0
                button.frame = .init(x: xx, y: yy, width: ww, height: 26)
                addSubview(button)
                button.jk.setImageTitleLayout(.imgBottom, spacing: 3)
                
                button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
                    guard let weakSelf = self else { return }
                    
                    if weakSelf.currentButon != button {
                        weakSelf.currentButon.titleLabel?.font = .systemFont(ofSize: 14)
                        weakSelf.currentButon.isSelected = false
                        weakSelf.currentButon.jk.setImageTitleLayout(.imgBottom, spacing: 3)
                        
                        weakSelf.currentButon = button
                        
                        button.isSelected = true
                        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
                        button.sizeToFit()
                        button.jk.setImageTitleLayout(.imgBottom, spacing: 3)
                        
                        var type:WPMenuCheckLiveType = .all
                        if i == 1 { type = .wait}
                        else if i == 2 { type = .end}
                        
                        weakSelf.liveBlock?(type)
                    }
                    
                }).disposed(by: disposeBag)
                
                if i == 0 {
                    button.titleLabel?.font = .boldSystemFont(ofSize: 14)
                    self.currentButon = button
                    self.currentButon.isSelected = true
                }
            }
        }

    }
}

extension WPMenuCheckView {
    func makeCousesItem(_ datas:[String] = ["课程分类","课程系列"]) -> Void {
        let marks = datas
        for (i,text) in marks.enumerated() {
            let button: UIButton = UIButton()
            button.setTitle(text, for: .normal)
            button.setTitleColor(rgba(51, 51, 51, 1), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13)
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.setImage(.init(named: "menu_up_icon"), for: .selected)
            button.setImage(.init(named: "menu_down_icon"), for: .normal)
            button.sizeToFit()
            let yy:CGFloat = 13 + kNavigationBarHeight
            let ww:CGFloat = 52 + 19
            let xx:CGFloat = 16.0 + CGFloat(i)*ww + CGFloat(i)*23.0
            button.frame = .init(x: xx, y: yy, width: ww, height: 18)
            addSubview(button)
            button.jk.setImageTitleLayout(.imgRight, spacing: 4)
            button.tag = 100 + i
            
            button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
                guard let weakSelf = self else { return }
                weakSelf.currentButon.isSelected = false
                
                button.isSelected = !button.isSelected
                weakSelf.currentButon = button
                weakSelf.getItemDatas()
                weakSelf.checkCouresBlock?(i)
                
            }).disposed(by: disposeBag)
        }
    }
}

extension WPMenuCheckView {
    func makeSubviews() {
        makeMarkButtons()
        
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        let h = kNavigationBarHeight + 44
        self.frame = .init(x: 0, y: 0, width: WPScreenWidth, height: h)
        var text = "搜索"
        
        if type == .cause {
            textLabel.text = "全部课程"
            text = "搜索课程"
            
        } else {
            textLabel.text = "全部直播"
            text = "搜索直播"
        }
        
        let atr:NSMutableAttributedString = NSMutableAttributedString(string: text)
        atr.yy_font = .systemFont(ofSize: 14)
        atr.yy_color = rgba(168, 171, 181, 1)
        searchBar.searchTextField.attributedPlaceholder = atr
    }
    
    func makeConstraints() -> Void {
        back.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(kStatusBarHeight+10)
            make.width.height.equalTo(24)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(back.snp.right).offset(7)
            make.centerY.equalTo(back)
        }
        
        searchBar.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 226, height: 34))
            make.centerY.equalTo(back)
            make.right.equalToSuperview().offset(-16)
        }
        
        checkSequence.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(back.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-16)
        }
    }
}

extension WPMenuCheckView {
    func getItemDatas() -> Void {
        if type == .cause {
            if self.courseClassDatas.count == 0 {
                WPClassificationsModel.getClassificationsDatas(num: 100) {[weak self] model in
                    guard let weakSelf = self else { return }
                    if let list: [WPClassificationsModel] = model.jsonModel?.data as? [WPClassificationsModel]  {
                        weakSelf.courseClassDatas.removeAll()
                        weakSelf.courseClassDatas.append(contentsOf: list)
                    }
                }
            }
            
            if self.courseSeriesDatas.count == 0 {
                WPSeriesModel.seriesGetDatas(isHome: false) {[weak self] model in
                    guard let weakSelf = self else { return }
                    if let list: [WPCouserModel] = model.jsonModel?.data as? [WPCouserModel]  {
                        weakSelf.courseSeriesDatas.removeAll()
                        weakSelf.courseSeriesDatas.append(contentsOf: list)
                    }
                }
            }
        }
    }
}
