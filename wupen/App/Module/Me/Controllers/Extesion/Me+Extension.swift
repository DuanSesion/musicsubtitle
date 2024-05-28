//
//  Me+Extension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/20.
//

import Foundation

// [WPLiveModel]
typealias MeDateFilterBlock = ((_ datas:[WPLiveModel])->Void)

extension WPMeController {
    func makeNotificationCenter() -> Void {
        NotificationCenter.default.rx.notification(.init("LoginOK")).subscribe(onNext: { [weak self] notice in
            guard let weakSelf = self else { return  }
            weakSelf.myCollect { datas in }
            if let user = WPUser.user() {
                let us = user.getFirst(user.userInfo?.userId)
                if  us == nil && user.userInfo?.interestTags == nil {
                    weakSelf.presentToMarkController()
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension WPMeController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.datas.count == 0 && indexPath.row == 1 {
            return CGSize(width: WPScreenWidth, height: 74.0)
        }
        return indexPath.row == 0 ? CGSize(width: WPScreenWidth, height: isExpend ? (436 + 133.0 - 20) : (198.0+35)) : CGSize(width: WPScreenWidth, height: 94.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: WPScreenWidth, height: 240 + kNavigationBarHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: WPScreenWidth, height: 0.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = WPMeHeaderView.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        if let mheaderView = headerView as? WPMeHeaderView {
            self.headerView = mheaderView
        }
       return headerView
    }
}

extension WPMeController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        WPMeBaseCell.didSelectItemAt(collectionView, indexPath: indexPath, datas: self.datas)
    }
}

extension WPMeController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (datas.count > 0) ? (datas.count + 1) : (2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = WPMeBaseCell.collectionViewWithCell(collectionView, indexPath: indexPath, datas: self.datas, updateBlock: {isExpend in})
        guard let calendarCell :WPMeCalendarCell = cell as? WPMeCalendarCell else { return cell }
        calendarCell.deleagte = self
        self.calendarCell = calendarCell
        return calendarCell
    }
}

extension WPMeController:WPMeCalendarDelegate {
    func calendar(_ view: WPMeCalendarCell, _ calendar: FSCalendar, didSelectDate: Date, filterBlock: @escaping ([WPLiveModel]) -> Void) {
        self.currentDate = didSelectDate
        myCollect(filterBlock)
    }
    
    func calendar(_ view: WPMeCalendarCell, _ calendar: FSCalendar, update: Bool, filterBlock:@escaping ([WPLiveModel]) -> Void) {
        self.isExpend = update
        collectionView.reloadData()
        myCollect(filterBlock)
    }
    
    func calendar(_ view: WPMeCalendarCell, _ calendar: FSCalendar, updateMonth: Date, filterBlock:@escaping ([WPLiveModel]) -> Void) {
        self.currentDate = updateMonth
        myCollect(filterBlock)
    }
}

extension WPMeController {
    func makeSubviews() -> Void {
        setNavColor(.clear)
        self.view.backgroundColor = rgba(245, 245, 245)
        self.edgesForExtendedLayout = .top
        collectionView.reloadData()
    }
    
    func makeConstraints() -> Void {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
}

extension WPMeController {
    func updateCurrentDate() -> Void {
        if now.isToday == false {
            now = Date.jk.currentDate.nowToLocalDate()
            currentDate = now
            self.calendarCell?.calendar.today = now
            
            self.calendarCell?.calendar.setCurrentPage(now, animated: false)
            self.calendarCell?.calendar.reloadData()
        }
        loadData()
    }
}

extension WPMeController {
    func loadData() -> Void {
        collectionView.reloadData()
        WPUser.userDetail {[weak self] user in
            self?.readNotice()
            self?.myCollect({ datas in })
        }
    }
    
    func readNotice() -> Void {
        WPNoticeModel.getNotice {[weak self] r, d in
            guard let weakSelf = self else { return }
            weakSelf.headerView?.messageBade.isHidden = !r
            weakSelf.collectionView.reloadData()
        }
    }
    
    func myCollect(_ filterBlock:@escaping(_ datas:[WPLiveModel])->Void) -> Void {
        WPMyCollectModel.getMyCollectLives {[weak self] datas in
            guard let weakSelf = self, datas.count >= 0 else { return }
//            weakSelf.reloadData(datas) { datas in
//                filterBlock(datas)
//            }
            weakSelf.reloadData(datas,filterBlock)
        }
    }
    
    func reloadData(_ datas:[WPLiveModel], _ filterBlock:@escaping MeDateFilterBlock) -> Void {
        /**某一天的预约数据**/
        let lists = datas.filter { live in //"Asia/Shanghai"
            guard let startTime = live.startTime else {return false}
            let current = currentDate.toFormat("yyyy-MM-dd", locale:Locales.chinese)
            debugPrint(startTime.contains(current),startTime,current)
            return startTime.contains(current)
        }

        self.datas.removeAll()
        self.datas.append(contentsOf: lists)
        collectionView.reloadData()
        
        /**对应的某一周或某一个月的预约数据**/
        guard let scope = self.calendarCell?.calendar.scope else { return }
        var myCollections:[WPLiveModel] = []
        
        if scope == .week {
//            let week = 7 - currentDate.weekday
            let week = currentDate.weekday
            let startDate = currentDate.addingTimeInterval(-24*60*60*Double(week))
            var weakDates:[String] = []
            
            for i in 0..<8 {
                let date = startDate.addingTimeInterval(24*60*60*Double(i))
                let current = date.toFormat("yyyy-MM-dd", locale:Locales.chinese)
                weakDates.append(current)
            }
            
            let lists = datas.filter { live in
                guard let startTime = live.startTime else {return false}
                let has = weakDates.filter { str in
                    return startTime.contains(str)
                }
                return has.count > 0
            }
            myCollections.append(contentsOf: lists)
            
        } else if scope == .month {
            guard let date = self.calendarCell?.calendar.currentPage.nowToLocalDate() else {return}
            let current = date.toFormat("yyyy-MM", locale:Locales.chinese)
            
            let lists = datas.filter { live in
                guard let startTime = live.startTime else {return false}
                return startTime.contains(current)
            }
            myCollections.append(contentsOf: lists)
        }
        filterBlock(myCollections)
    }
}



