//
//  WPFindPageController+Extension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

extension WPFindPageController { }


extension WPFindPageController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section < self.datas.count {
            let model = self.datas[indexPath.section]
            model.adjustCellSize()
            return CGSize(width: model.cellWidth, height: model.cellHeight)
        }
        return  CGSize(width: WPScreenWidth, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section < self.datas.count {
            let model = self.datas[section]
            return CGSize(width: WPScreenWidth, height: model.headHeight)
        }
        return CGSize(width: WPScreenWidth, height: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: WPScreenWidth, height: 0.01)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if UICollectionView.elementKindSectionHeader == kind {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! WPFindHeaderView
            if indexPath.section < self.datas.count {
                let model = self.datas[indexPath.section]
                view.model = model
            }
            return view
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        }
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section < self.datas.count {
            let model = self.datas[section]
            if model.cell == "cell4" {
                return 16
            }
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section < self.datas.count {
            let model = self.datas[section]
            if model.cell == "cell4" {
                return 13
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if section < self.datas.count {
            let model = self.datas[section]
            if model.cell == "cell4" {
                return .init(top: 13, left: 16, bottom: 16, right: 16)
            }
        }
        return .zero
    }
}

extension WPFindPageController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //WPMeBaseCell.didSelectItemAt(collectionView, indexPath: indexPath, datas: [])
        if indexPath.section < self.datas.count {
            let model = self.datas[indexPath.section]
            if model.cell == "cell4" {//课程系列
                if self.seriesDatas.count > indexPath.row {
                    let model = self.seriesDatas[indexPath.row]
                    let vc:WPCourseListController = WPCourseListController()
                    vc.model = model
                    self.navigationController?.pushViewController(vc, animated: true)
                    WPUmeng.um_event_find_SeriesCourseClick(model.id)
                }
  
            } else if model.cell == "cell2" {//直播详情
                guard let liveModel = self.recentLive.liveModel else { return }
                let vc:WPLiveStatusController = WPLiveStatusController()
                vc.model = liveModel
                self.navigationController?.pushViewController(vc, animated: true)
                WPUmeng.um_event_find_LiveDetailsFromDiscover()
                WPUmeng.um_event_find_LiveCardClick(liveModel.id)
            }
        }
    }
}

extension WPFindPageController:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < 3 {
            if section == 1 {
                return (self.recentLive.liveModel == nil) ? 0 : 1
            }
            return 1
        }
        return self.seriesDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section < self.datas.count {
            let model = self.datas[indexPath.section]
            if model.cell == "cell1" {
                let cell:WPFindeCell1 = collectionView.dequeueReusableCell(withReuseIdentifier: model.cell, for: indexPath) as! WPFindeCell1
                cell.model = self.topModel
                
                return cell
                
            } else if model.cell == "cell2" {
                let cell:WPFindeCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: model.cell, for: indexPath) as! WPFindeCell2
                cell.model = self.recentLive
                return cell
                
            } else if model.cell == "cell3" {
                let cell:WPFindeCell3 = collectionView.dequeueReusableCell(withReuseIdentifier: model.cell, for: indexPath) as! WPFindeCell3
                cell.course = self.course
                return cell
                
            } else if model.cell == "cell4" {
                let cell:WPFindeCell4 = collectionView.dequeueReusableCell(withReuseIdentifier: model.cell, for: indexPath) as! WPFindeCell4
                if self.seriesDatas.count > indexPath.row {
                    cell.model = self.seriesDatas[indexPath.row]
                }
                return cell
            }
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
    }
}

extension WPFindPageController {
    
    func register (_ collectionView:UICollectionView) {
        collectionView.register(WPFindeCell1.self, forCellWithReuseIdentifier: "cell1")
        collectionView.register(WPFindeCell2.self, forCellWithReuseIdentifier: "cell2")
        collectionView.register(WPFindeCell3.self, forCellWithReuseIdentifier: "cell3")
        collectionView.register(WPFindeCell4.self, forCellWithReuseIdentifier: "cell4")

        collectionView.register(WPFindHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(WPMeFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
    }
}

extension WPFindPageController {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if let hview:WPFindHeaderView = view as? WPFindHeaderView {
            debugPrint(hview.textTitleLabel.text as Any, indexPath.section)
            
            if indexPath.section == 2 {
                WPUmeng.um_event_find_HotCourseScroll()
                
            } else if indexPath.section == 3 {
                WPUmeng.um_event_find_SeriesCourseScroll()
            }
        }
    }
}
 
extension WPFindPageController {
    func loadDatas() -> Void {
        loadBanners()
        loadRecentLive()
        loadClassCoures()
        loadSeriesDatas()
    }
    
    //MARK: 顶部banner
    func loadBanners() -> Void {
        WPBanner.getHomeBanner {[weak self] datas in
            guard let weakSelf = self else { return  }
            weakSelf.topModel.datas = datas
            weakSelf.collectionView.reloadData()
        }
    }

    //MARK: 最近直播
    func loadRecentLive() -> Void {
        WPLiveModel.findRecentLive {[weak self]  live in
            guard let weakSelf = self else { return  }
            weakSelf.recentLive.findNewLive(live)
            weakSelf.collectionView.reloadData()
        }
    }

    //MARK: 课程分类
    func loadClassCoures() -> Void {
        WPClassificationsModel.getClassificationsDatas {[weak self] model in
            guard let weakSelf = self else {return}
            if let datas = model.jsonModel?.data as? [WPClassificationsModel] {
                weakSelf.course.updateCousse(datas,doParent: weakSelf)
            }
            weakSelf.collectionView.reloadData()
        }
    }

    //MARK: 系列课程
    func loadSeriesDatas() -> Void {
        WPSeriesModel.seriesGetDatas {[weak self] model in
            guard let weakSelf = self else {return}
            if let datas = model.jsonModel?.data as? [WPCouserModel] {
                weakSelf.seriesDatas.removeAll()
                weakSelf.seriesDatas.append(contentsOf: datas)
            }
            weakSelf.collectionView.reloadData()
        }
    }
}

