//
//  WPFindeCellModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/28.
//

import UIKit

enum WPFindeCellModelType:Int {
    case banner
    case live
    case course
    case serise
    case none
}

class WPFindeCellModel: NSObject {
    var title:String?
    var cell:String = ""
    var cellWidth:CGFloat = WPScreenWidth
    var cellHeight:CGFloat = 0
    var headHeight:CGFloat = 0
    var hasMore:Bool = false
    var type:WPFindeCellModelType = .none
    
    var datas:[Any] = []
    
    //课程相关
    private var pages:[String:WPFindCourseController] = [:]
    public var pageTitles:[String] = []
    public var currentChirds:[WPFindCourseController] = []
    
    //最新直播
    public var liveModel:WPLiveModel?
    public var starAnimationBlock:(()->Void)?
    
    override init() {
        super.init()
        let hot = WPFindCourseController()
        pages["hot"] = hot
    }
}

extension WPFindeCellModel {
    class func findeCellModels(_ block:@escaping(_ model1:WPFindeCellModel,_ model2:WPFindeCellModel,_ model3:WPFindeCellModel,_ model4:WPFindeCellModel)->Void)->[WPFindeCellModel] {
        var datas:[WPFindeCellModel] = []
        
        let topModel = WPFindeCellModel()
        topModel.title = ""
        topModel.cell = "cell1"
        topModel.cellHeight = 128.0
        topModel.headHeight = 0.0
        topModel.cellWidth = WPScreenWidth
        topModel.type = .banner
        
        let recentLive = WPFindeCellModel()
        recentLive.title = "最近直播"
        recentLive.cell = "cell2"
        recentLive.cellHeight = 258.0
        recentLive.headHeight = 65.0
        recentLive.cellWidth = WPScreenWidth
        recentLive.hasMore = true
        recentLive.type = .live

        let course = WPFindeCellModel()
        course.title = "课程"
        course.cell = "cell3"
        course.cellHeight = 28 + 16.0 + 360.0 + 20.0
        course.cellWidth = WPScreenWidth
        course.headHeight = 65.0
        course.hasMore = true
        course.type = .course
        
        let courseSeries = WPFindeCellModel()
        courseSeries.title = "系列课程"
        courseSeries.cell = "cell4"
        courseSeries.cellHeight = 195
        courseSeries.cellWidth = (WPScreenWidth - 45)/2
        courseSeries.headHeight = 65.0
        courseSeries.type = .serise

        datas.append(contentsOf: [topModel,recentLive,course,courseSeries])
        block(topModel, recentLive, course, courseSeries)
        return datas
    }
    
    func adjustCellSize() -> Void {
        if cell == "cell1" {
            self.cellHeight = 128.0
            self.cellWidth = WPScreenWidth
        }
        
        else if cell == "cell2" {
            self.cellHeight = 258.0
            self.cellWidth = WPScreenWidth
        }
        
        else if cell == "cell3" {
            self.cellHeight = 28 + 16.0 + 360.0 + 20.0
            self.cellWidth = WPScreenWidth
        }
        
        else if cell == "cell4" {
            self.cellHeight = 195
            self.cellWidth = (WPScreenWidth - 45)/2
        }
    }
}

extension WPFindeCellModel {
    func updateCousse(_ datas:[WPClassificationsModel],doParent:UIViewController) -> Void {
        self.datas = datas
        
        currentChirds.removeAll()
        pageTitles.removeAll()
        pageTitles.append(WPLanguage.chinessLanguage() ? "最热" : "HOT")
        
        if let hot = self.pages["hot"] {
            currentChirds.append(hot)
            if hot.parent == nil && hot.isViewLoaded == false {
               hot.didMove(toParent: doParent)
               doParent.addChild(hot)
            }
        }
        
        for (_, model) in datas.enumerated() {
            if WPLanguage.chinessLanguage() {
                pageTitles.append(model.chineseName)
            } else {
                pageTitles.append(model.englishName)
            }
            
            if let vc:WPFindCourseController = self.pages[model.id] {
                vc.model = model
                currentChirds.append(vc)
                
            } else {
                let vc:WPFindCourseController = WPFindCourseController()
                vc.model = model
                currentChirds.append(vc)
                self.pages[model.id] = vc
                
                if vc.parent == nil && vc.isViewLoaded == false  {
                    vc.didMove(toParent: doParent)
                    doParent.addChild(vc)
                }
            }
        }
    }
}

extension WPFindeCellModel {
    func findNewLive(_ live:WPLiveModel) -> Void {//最近直播那一条
        self.liveModel = live
    }
}
