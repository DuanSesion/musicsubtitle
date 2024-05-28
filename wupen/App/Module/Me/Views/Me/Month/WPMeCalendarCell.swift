//
//  WPMeCalendarCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/2.
//

import UIKit

protocol WPMeCalendarDelegate:NSObjectProtocol {
    func calendar(_ view:WPMeCalendarCell, _ calendar :FSCalendar, didSelectDate:Date, filterBlock:@escaping MeDateFilterBlock) -> Void
    func calendar(_ view:WPMeCalendarCell, _ calendar :FSCalendar, update:Bool, filterBlock:@escaping MeDateFilterBlock) -> Void
    func calendar(_ view:WPMeCalendarCell, _ calendar :FSCalendar, updateMonth:Date, filterBlock:@escaping MeDateFilterBlock) -> Void
}

class WPMeCalendarCell: WPMeBaseCell {
    override class func collectionViewWithCell(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[WPLiveModel],updateBlock:@escaping(_ :Bool)->Void)->WPMeCalendarCell {
        let cell:WPMeCalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WPMeCalendarCell", for: indexPath) as! WPMeCalendarCell
        cell.updateBlock = updateBlock
        if datas.count > indexPath.row {
 
        }
        return cell
    }
    
    override class func didSelectItemAt(_ collectionView:UICollectionView,indexPath:IndexPath,datas:[WPLiveModel])->Void { }
    var updateBlock:((_ :Bool)->Void)?
    public weak var deleagte:WPMeCalendarDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.calendar.scope == .month {
            self.calendar.height = 436.0
            
        } else {
            self.calendar.height = 120.0
        }
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
    
    lazy var currentDate: Date = {
        return  Date.jk.currentDate
    }()
    
    lazy var bgView: UIView = {
        var bgView: UIView = UIView()
        bgView.isUserInteractionEnabled = true
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 12
        bgView.layer.cornerRadius = 12
        bgView.layer.shadowOffset = .init(width: -1, height: -2)
        bgView.layer.shadowColor = rgba(225, 241, 255, 0.50).cgColor
        bgView.layer.shadowRadius = 10
        bgView.layer.shadowOpacity = 1
        bgView.layer.backgroundColor = UIColor.white.cgColor
        
        let img = UIImage.wp.jianBian(colors: [rgba(255, 212, 127, 1).cgColor, rgba(255, 255, 255, 1).cgColor], size: CGSize(width: WPScreenWidth-32, height: 60))?.wp.roundCorner(12)
        var imgView: UIImageView = UIImageView(image: img)
        imgView.frame = CGRect(x: 0, y: 0, width: WPScreenWidth-32, height: 60)
        bgView.addSubview(imgView)
        
        contentView.addSubview(bgView)
        return bgView
    }()
    
    lazy var calendar: FSCalendar = {
        var calendar: FSCalendar = FSCalendar(frame: CGRect(x: 16, y: 0, width: WPScreenWidth-32, height: 420+15))
        calendar.isUserInteractionEnabled = true
        calendar.backgroundColor = .clear
        calendar.layer.cornerRadius = 12
        calendar.clipsToBounds = true
     
        calendar.today = self.currentDate
        calendar.scope = .week
        //calendar.allowsSelection = true
        calendar.scrollEnabled = true
        calendar.headerHeight = 16
        calendar.weekdayHeight = 25
        calendar.rowHeight = 63
        //calendar.setValue(1, forKeyPath: "fakedSelectedDay")

        calendar.appearance.weekdayTextColor = rgba(136, 136, 136, 1)
        calendar.appearance.titleWeekendColor = rgba(51, 51, 51, 1)
        calendar.appearance.weekdayFont = .systemFont(ofSize: 15)
        calendar.appearance.titleDefaultColor = rgba(51, 51, 51, 1)
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 16)
        calendar.appearance.titleTodayColor = .red
        calendar.appearance.todayColor = .red
        
        calendar.appearance.eventSelectionColor = .clear
        calendar.appearance.eventDefaultColor = .clear
        calendar.appearance.selectionColor = .clear
        calendar.appearance.todaySelectionColor = .clear
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        calendar.autoresizesSubviews = true
        calendar.locale = .current
        
        calendar.select(self.currentDate)
        calendar.firstWeekday = 1
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "FSCell")
        calendar.delegate = self
        calendar.dataSource = self
        calendar.accessibilityIdentifier = "calendar"
        bgView.addSubview(calendar)
        return calendar
    }()
    
    lazy var goToPlance: UIButton = {
        var goToPlance: UIButton = UIButton()
        goToPlance.backgroundColor = .clear
        goToPlance.setTitle("我的日历计划", for: .normal)
        goToPlance.setImage(.init(named: "me_more_icon"), for: .normal)
        goToPlance.setTitleColor(rgba(51, 51, 51, 1), for: .normal)
        goToPlance.titleLabel?.font = .boldSystemFont(ofSize: 16)
        goToPlance.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
//            WPUmeng.um_event_me_click_dailyPlanView()
      
        }).disposed(by: disposeBag)
        bgView.addSubview(goToPlance)
        return goToPlance
    }()
    
    lazy var bashLine: UIImageView = {
        var bashLine: UIImageView = UIImageView(image: .init(named: "me_bash_line_icon"))
        contentView.addSubview(bashLine)
        return bashLine
    }()
    
    lazy var weakLine: UIImageView = {
        var weakLine: UIImageView = UIImageView()
        weakLine.backgroundColor = rgba(230, 230, 230, 1)
        contentView.addSubview(weakLine)
        return weakLine
    }()
    
    lazy var monthLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = String(format: "%ld月", self.currentDate.month)
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        self.bgView.addSubview(label)
        return label
    }()
    
    lazy var yearLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = String(format: "%ld", self.currentDate.year)
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        self.bgView.addSubview(label)
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = String(format: "%02ld", self.currentDate.day)
        label.textColor = rgba(51, 51, 51, 1)
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        self.bgView.addSubview(label)
        return label
    }()
    
    lazy var panGestureView: UIImageView = {
        let img = UIImage(systemName: "chevron.down")?.sd_resizedImage(with: CGSize(width: 20, height: 20), scaleMode: .aspectFit)?.withTintColor(rgba(168, 171, 181, 1), renderingMode: .alwaysOriginal)
        var panGestureView: UIImageView = UIImageView(image: img)
        panGestureView.isUserInteractionEnabled = true
        panGestureView.contentMode = .scaleAspectFit
        self.bgView.addSubview(panGestureView)
        return panGestureView
    }()
    
    lazy var monthPageView: WPMeMonthPageView = {
        var monthPageView: WPMeMonthPageView = WPMeMonthPageView(frame: CGRect(x: 0, y: 60, width: WPScreenWidth-32, height: 38))
        monthPageView.didBlock = .some({[weak self] month in
            guard let date = self?.currentDate,
                  let calendar = self?.calendar else {
                return
            }
            
            var year:Int = date.year
            let currentMonth:Int = date.month
             
           if currentMonth != month {
               if currentMonth <= 2 {
                   if month >= 11 {
                       year -= 1
                   }
                   
               } else if currentMonth >= 11 {
                   if month <= 2 {
                       year += 1
                   }
               }
            
               var currentPageDate:Date = Date(year: year, month: month, day: 1, hour: 16, minute: 0)
               self?.calendar.setCurrentPage(currentPageDate, animated: false)
               self?.calendar.reloadData()
               
//               self?.currentDate = currentPageDate
//               self?.updateCurrentDateUI(currentPageDate)
            }
        })
        
        self.contentView.addSubview(monthPageView)
        return monthPageView
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    var datas:[WPLiveModel]! {
        didSet {
            calendar.reloadData()
        }
    }
}

extension WPMeCalendarCell:UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let velocity = self.scopeGesture.velocity(in: self.panGestureView)
        switch self.calendar.scope {
        case .month:
            return velocity.y < 0
        case .week:
            return velocity.y > 0
        @unknown default:
            return true
        }
    }
}

extension WPMeCalendarCell:FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        updateCalendarCell(cell, date: date)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.currentDate = date.date.nowToLocalDate()
        updateCurrentDateUI(self.currentDate)
        self.deleagte?.calendar(self, calendar, didSelectDate: self.currentDate, filterBlock: {[weak self] datas in
            self?.datas = datas
        })
        if calendar.currentPage.nowToLocalDate().month != self.currentDate.month {
            calendar.setCurrentPage(self.currentDate, animated: true)
        }
        calendar.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage.date.nowToLocalDate()
        self.monthPageView.index = currentPageDate.month
        
        self.currentDate = currentPageDate
        updateCurrentDateUI(self.currentDate)
        self.deleagte?.calendar(self, calendar, updateMonth: currentPageDate, filterBlock: {[weak self] datas in
            self?.datas = datas
        })
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        var height = bounds.height
        if height <= 120 {height = 120}
        self.calendar.height = height
        let s  = height <= 120 ? false : true
        updateBlock?(s)
        self.deleagte?.calendar(self, calendar, update: s,filterBlock: {[weak self]  datas in
            self?.datas = datas
        })
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

extension WPMeCalendarCell:FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        let gregorian: NSCalendar? = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        return (gregorian?.isDateInToday(date) == true) ? "今" : nil
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "FSCell", for: date, at: .current)
        updateCalendarCell(cell, date: date)
        return cell
    }
}

extension WPMeCalendarCell {
    func updateCalendarCell(_ cell:FSCalendarCell, date: Date) -> Void {
        cell.isToday = false
        cell.dotState = .none
       
        let now = date.nowToChinaDate()
        let current = now.toFormat("yyyy-MM-dd", locale:Locales.chinese)
         
        let month = calendar.currentPage.nowToLocalDate().month
        if now.jk.month == month  {
            cell.titleLabel.textColor = rgba(51, 51, 51, 1)
        }
        
        for item in self.datas {
            if item.startTime?.contains(current) == true {
                item.checkUpdateState()
                if item.status == 1 {
                    cell.dotState = .gay
                } else if item.status == 0 {
                    cell.dotState = .red
                }
               break
            }
        }
        
        if date.jk.isSameDay(date: self.currentDate) {
            cell.isToday = true
            cell.sizeToFit()
        }
    }
}

extension WPMeCalendarCell {
    @objc func openAndHidden()->Void {
        if self.calendar.height <= 120.0 {
            self.calendar.height = 436.0
            self.calendar.scope = .month
            self.updateBlock?(true)
            
        } else {
            self.calendar.height = 120.0
            self.calendar.scope = .week
            self.updateBlock?(false)
        }
        self.calendar.reloadData()
        self.layoutIfNeeded()
    }
}


extension WPMeCalendarCell {
    func makeSubviews() -> Void {
        self.backgroundColor = .clear
        self.panGestureView.addGestureRecognizer(self.scopeGesture)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openAndHidden))
        self.panGestureView.addGestureRecognizer(tap)
        
        self.datas = []
    }
    
    func makeConstraints() -> Void {
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.height.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        
        bashLine.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.width.equalTo(WPScreenWidth - 50)
            make.height.equalTo(1)
        }
        
        monthPageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(bgView)
            make.top.equalToSuperview().offset(60)
            make.height.equalTo(38)
        }
        
        weakLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(WPScreenWidth - 76)
            make.height.equalTo(1)
            make.bottom.equalTo(monthPageView.snp.bottom)
        }
        
        calendar.frame = CGRect(x: 0, y: 92, width: WPScreenWidth-32, height: 120.0)
        
        goToPlance.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(21)
            make.height.equalTo(60)
            make.width.equalTo(126)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-15)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom)
            make.right.equalToSuperview().offset(-15)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(21)
            make.right.equalTo(yearLabel.snp.left).offset(-6)
        }
        
        panGestureView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 20))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        goToPlance.jk.setImageTitleLayout(.imgRight,spacing: 5)
        self.clipsToBounds = false
    }
}

extension WPMeCalendarCell {
    func updateCurrentDateUI(_ date:Date?) -> Void {
        guard let date = date else { return  }
        monthLabel.text = String(format: "%ld月",date.month)
        yearLabel.text = String(format: "%ld", date.year)
        dayLabel.text = String(format: "%02ld", date.day)
    }
}
