//
//  WPTabBarModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

class WPTabBarModel: Convertible {
    required init() {}

    var title:String?
    var imageSel:String?
    var imageUnSel:String?
    var viewController:UIViewController!
}

extension WPTabBarModel {
    class func tabarModels ()->[WPTabBarModel] {
        let findModel = WPTabBarModel()
        findModel.title = localizedString("TabarFindName")
        findModel.imageUnSel = "tb_find_no_icon"
        findModel.imageSel = "tb_find_sel_icon"
        findModel.viewController = WPFindController()
        
        let aiwModel = WPTabBarModel()
        aiwModel.title = "AIwus"
        aiwModel.imageUnSel = "tb_ai_no_icon"
        aiwModel.imageSel = "tb_ai_sel_icon"
        aiwModel.viewController = WPAIController()
        
        let meModel = WPTabBarModel()
        meModel.title = localizedString("TabarMeName")
        meModel.imageUnSel = "tb_me_no_icon"
        meModel.imageSel = "tb_me_sel_icon"
        meModel.viewController = WPMeController()
    
       return [findModel,aiwModel,meModel]
    }
}


