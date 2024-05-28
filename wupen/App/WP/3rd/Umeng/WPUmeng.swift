//
//  WPUmeng.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/26.
//

import UIKit
 

class WPUmeng: NSObject {
    //MARK: 系统启动友盟
    public static  func initUmeng() -> Void {
        let config:UMAPMConfig = UMAPMConfig.default()
        config.crashAndBlockMonitorEnable = true
        config.launchMonitorEnable = true
        config.memMonitorEnable = true
        config.oomMonitorEnable = true
        config.networkEnable = true
        
        let kUmengAppkey = "6298277788ccdf4b7e8435be"
        let kUmengChannel = "tlnqegwjvdxhc3pgdjcp9mcpoa1rrpny"
        
        UMCrashConfigure.setAPMConfig(config)
        UMConfigure.initWithAppkey(kUmengAppkey, channel:kUmengChannel)
        
        MobClick.setAutoPageEnabled(true)
        UMLaunch.setLaunchEnable(true)
        UMLaunch.setPredefineLaunchType(.didFinishLaunchingEnd)
    }

}

/**
 //MARK :进入启动闪屏加载
 class func um_star_splash()->Void {
     var param:[String:Any] = [:]
     param["Um_Key_SourcePage"] = "进入加载页"
     param["Um_Key_UserID"] = MKUser.user()?.userId
     MobClick.beginEvent("home.loading.Show", primarykey: "home.loading.Show", attributes: param)
 }
 
 //MARK :退出闪屏加载
 class func um_end_splash()->Void {
     MobClick.endEvent("home.loading.Show", primarykey: "home.loading.Show")
 }
 
 //MARK : 手机登录
 class func um_event_phone_login()->Void {
     var param:[String:Any] = [:]
     param["Um_Key_SourcePage"] = "手机登录"
     param["Um_Key_UserID"] = MKUser.user()?.userId
     MobClick.event("home.visitor.Phone", attributes:param)
 }
 */


//MARK: 登陆注册
extension WPUmeng {
    //MARK: 手机号验证码登录数
    class func um_event_phone_login(username:String?,sucesse:Bool=true)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "手机登录"
        param["username"] = username
        param["sucesse"] = sucesse
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("PhoneNumberLogin", attributes:param)
    }
    
    //MARK: 苹果账号登录数
    class func um_event_Apple_login(username:String?,sucesse:Bool=true)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "苹果账号登录数"
        param["username"] = username
        param["sucesse"] = sucesse
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("AppleAccountLogin", attributes:param)
    }
    
    //MARK: 账号登录数
    class func um_event_login(_ isPhone:Bool=true,username:String?,sucesse:Bool=true)->Void {
        if isPhone {
            um_event_phone_login(username: username, sucesse: sucesse)
        } else {
            um_event_Apple_login(username: username, sucesse: sucesse)
        }
    }
    
    //MARK: 自动注册新用户 ***** ⚠️
    class func um_event_login_AutoRegistration(username:String?,sucesse:Bool=true)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "自动注册新用户"
        param["username"] = username
        param["sucesse"] = sucesse
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("AutoRegistration", attributes:param)
    }
    
    //MARK: 用户登录成功时
    class func um_event_login_LoginSuccess(username:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "登录成功"
        param["username"] = username
        param["sucesse"] = true
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("LoginSuccess", attributes:param)
    }
    
    //MARK: 用户登录尝试失败时
    class func um_event_login_LoginFailure(error:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "用户登录尝试失败时"
        param["error"] = error
        param["sucesse"] = false
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("LoginFailure", attributes:param)
    }
}

//MARK: 发现
extension WPUmeng {
    
    //MARK: Banner滑动 - 用户在Banner区域进行左右滑动时
    class func um_event_find_BannerSwipe(_ isLeft:Bool = false)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "Banner滑动"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["direction"] = isLeft ? "left" : "right"
        MobClick.event("BannerSwipe", attributes: param)
    }
    
    //MARK: Banner点击-用户点击Banner上的内容时
    class func um_event_find_BannerClick(_ id:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "Banner点击"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["BannerID"] = id
        MobClick.event("BannerClick", attributes: param)
    }
    
    //MARK: 用户点击“最近直播”板块的直播卡片时
    class func um_event_find_LiveCardClick(_ id:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "最近直播卡片点击数"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["LiveID"] = id
        MobClick.event("LiveCardClick", attributes: param)
    }
    
    //MARK: 热门课程点击数
    class func um_event_find_HotCourseClick(_ id:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "热门课程点击数"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["CourseID"] = id
        MobClick.event("HotCourseClick", attributes: param)
    }
    
    //MARK: 系列课程点击数
    class func um_event_find_SeriesCourseClick(_ id:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "系列课程点击数"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["CourseID"] = id
        MobClick.event("SeriesCourseClick", attributes: param)
    }

    //MARK: 查看更多热门课程
    class func um_event_find_HotCoursesViewMore()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "查看更多热门课程"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("HotCoursesViewMore", attributes: param)
    }
    
    //MARK: 热门课程滚动
    class func um_event_find_HotCourseScroll()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "用户在热门课程列表滚动时"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("HotCourseScroll", attributes: param)
    }
    
    //MARK: 系列课程滚动-用户在系列课程列表滚动时
    class func um_event_find_SeriesCourseScroll()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "用户在系列课程列表滚动时"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("SeriesCourseScroll", attributes: param)
    }
    
    //MARK: 用户进入发现页
    class func um_event_find_DiscoverPageEntry(_ index:Int)->Void {
        var param:[String:Any] = [:]
        if index == 0{
            param["SourcePage"] = "用户进入发现页"
        }
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("DiscoverPageEntry", attributes: param)
    }
    
    //MARK: 发现页搜索
    class func um_event_find_DiscoverSearch()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "发现页搜索"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("DiscoverSearch", attributes: param)
    }
    
    //MARK: 从发现页进入课程详情
    class func um_event_find_CourseDetailsFromDiscover()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "从发现页进入课程详情"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("CourseDetailsFromDiscover", attributes: param)
    }
    
    //MARK: 从发现页进入直播详情
    class func um_event_find_LiveDetailsFromDiscover()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "从发现页进入直播详情"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("LiveDetailsFromDiscover", attributes: param)
    }
    
    //MARK: 搜索词及结果点击 - 用户提交搜索及点击搜索结果时
    class func um_event_find_SearchAndClick(_ keyworld:String?)->Void {
        guard let keworld = keyworld, keworld.count > 0  else { return  }
        var param:[String:Any] = [:]
        param["SourcePage"] = "搜索词及结果点击"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["keyworld"] = keyworld
        MobClick.event("SearchAndClick", attributes: param)
    }
}
 
//MARK: 课程详情页
extension WPUmeng {
    //MARK: 课程详情返回点击
    class func um_event_course_detail_click_back()->Void {
        guard let vc = UIViewController.wp.TopViewController(base: WPKeyWindowDev?.rootViewController) else { return  }
        
        var param:[String:Any] = [:]
        param["SourcePage"] = "课程详情"
        param["userId"] = WPUser.user()?.userInfo?.userId
        
        if vc is WPSearchController {
            param["from"] = "全局搜索"
            
        } else if vc is WPCourseListController {
            param["from"] = "课程列表"
            
        } else if vc is WPFindCourseController {
            param["from"] = "课程详情页面"
            
        } else if vc is WPFindController {
            param["from"] = "首页发现"
            
        } else {
            param["from"] = String(describing: vc)
        }
        MobClick.event("BackClick", attributes:param)
    }
    
    //MARK: 字幕点击 - 选择的字幕语言
    class func um_event_course_Click_Subtitle(_ language:String)->Void {
        MobClick.event("SubtitleClick", label: language)
    }
    
    //MARK: 字幕点击 - 选择的字幕语言
    class func um_event_course_Click_PlayPause(_ play:Bool=false,current:Double=0)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "视频播放&暂停"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["current"] = current
        if play {
            param["play"] = "播放"
            
        } else {
            param["pause"] = "暂停"
        }
        MobClick.event("PlayPauseClick", attributes: param)
    }
    
    //MARK: 字幕点击 - 用户点击上一个或下一个视频时
    class func um_event_course_Click_Navigation(_ current:WPVideoModel?,to:WPVideoModel?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "视频播放上一个或下一个视频"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["current"] = current?.id
        param["to"] = to?.id
        MobClick.event("NavigationClick", attributes: param)
    }
    
    //MARK: 用户更改视频播放速度时
    class func um_event_course_speed_change(_ currentRate:Float=1,rate:Float=1)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "视频播放速率"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["原始速率"] = currentRate
        param["新速率"] = rate
        MobClick.event("SpeedChange", attributes: param)
    }
    
    //MARK: 用户更改视频播放全屏
    class func um_event_course_FullscreenToggle(_ fullscreen:Bool=true,video:WPLectureVideosModel?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "视频播放速率"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["fullscreen"] = fullscreen ? "全屏" : "退出全屏"
        param["video_currentTime"] = video?.player?.currentItem?.currentTime().seconds
        param["video_id"] = video?.video?.id
        MobClick.event("FullscreenToggle", attributes: param)
    }
    
    //MARK: 用户点击查看课程简介时
    class func um_event_course_Click_CourseIntro()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "用户点击查看课程简介时"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        MobClick.event("CourseIntroClick", attributes: param)
    }
    
    //MARK: 用户加入学习统计 - 显示加入学习的用户人次时
    class func um_event_course_JoinStudyCount(_ person:Int=0)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "显示加入学习的用户人次时"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["JoinStudyCount"] = person
        MobClick.event("JoinStudyCount", attributes: param)
    }
    
    //MARK: 积分与学习进度显示 - 用户查看积分数和学习进度时 ****** ⚠️
    class func um_event_course_PointsAndProgress(_ points:Int=0,progress:Float=0)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "积分与学习进度显示"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["points"] = points
        param["progress"] = progress
        MobClick.event("PointsAndProgress", attributes: param)
    }
    
    //MARK: 知识点列表显示 - 用户查看课程的知识点列表时
    class func um_event_course_KnowledgePointsList(_ text:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "知识点列表显示"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["KnowledgePoints"] = text
        MobClick.event("KnowledgePointsList", attributes: param)
    }
    
    //MARK: 课程推荐 —— 根据课程标签显示推荐课程时
    class func um_event_course_CourseRecommendation(_ courseLabel:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "课程推荐"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["courseLabel"] = courseLabel
        MobClick.event("CourseRecommendation", attributes: param)
    }
    
    //MARK: 推荐课程点击 —— 用户点击推荐课程时
    class func um_event_course_ClickRecommendation(_ courseID:String?)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "推荐课程点击"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["courseID"] = courseID
        MobClick.event("RecommendationClick", attributes: param)
    }
}

//MARK: 直播详情页
extension WPUmeng {
    //MARK: live返回点击
    class func um_event_live_detail_click_back()->Void {
        guard let vc = UIViewController.wp.TopViewController(base: WPKeyWindowDev?.rootViewController) else { return  }
        
        var param:[String:Any] = [:]
        param["SourcePage"] = "直播详情"
        param["userId"] = WPUser.user()?.userInfo?.userId
        
        if vc is WPSearchController {
            param["from"] = "全局搜索"
            
        } else if vc is WPLiveStatusController {
            param["from"] = "全部直播课列表"
            
        } else if vc is WPMeController {
            param["from"] = "我的页面"
            
        } else if vc is WPFindController {
            param["from"] = "首页发现"
            
        } else {
            param["from"] = String(describing: vc)
        }
        MobClick.event("BackClick", attributes:param)
    }
    
    //MARK: 视频区域状态切换
    class func um_event_live_status_change(_ status:Int=0)->Void {
        var label:String = ""
        if status == 0 {
            label = "倒计时"
            
        } else if status == 1 {
            label = "直播即将上线"
            
        } else if status == 2 {
            label = "暂时离开"
        }
        
        var param:[String:Any] = [:]
        param["SourcePage"] = "直播详情"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["status"] = label
        MobClick.event("VideoStatusChange", attributes: param)
    }
    
    //MARK: 查看直播·详情
    class func um_event_live_details_view()->Void {
        //debugPrint(Date.jk.currentDate.addingTimeInterval(8*60*60).toString())
        let time:String? = Date.chinaDate()
        var param:[String:Any] = [:]
        param["SourcePage"] = "直播详情"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["time"] = time
        MobClick.event("LiveDetailsView", attributes: param)
    }
    
    //MARK: 预约直播·取消预约
    class func um_event_live_button_click(_ event:Bool=false)->Void {
        MobClick.event("BookLiveButtonClick", label: event ? "预约直播" : "取消预约直播")
    }
    
    //MARK: AIWUS互动记录 - 识别最受欢迎的直播内容和吸引用户的直播事件
    class func um_event_live_Entry(_ label:String)->Void {
        MobClick.event("LiveEntry", label: label)
    }
}

//MARK: AIWUS
extension WPUmeng {
    
    //MARK: AIWUS访问量
    class func um_event_AIWUS_Visits(_ total:Int=0)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "AIWUS"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["total"] = total
        MobClick.event("AIWUSVisits", attributes:param)
    }
    
    //MARK: AIWUS访问
    class func um_event_AIWUS_Access(_ isHome:Bool=true)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "AIWUS"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["isHome"] = isHome ? "首页悬浮" : "导航栏"
        MobClick.event("AIWUSAccess", attributes:param)
    }
    
    //MARK: AIWUS关闭
    class func um_event_AIWUS_Close(_ isBegin:Bool=true)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "AIWUS"
        param["userId"] = WPUser.user()?.userInfo?.userId
        if isBegin {
            MobClick.beginEvent("AIWUSClose", primarykey: "AIWUS开始", attributes: param)
        } else {
            MobClick.endEvent("AIWUSClose", primarykey: "AIWUS结束")
        }
    }
}

//MARK: 我的
extension WPUmeng {
    //MARK: 查看个人信息
    class func um_event_me_profile_view()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "我的"
        param["userId"] = WPUser.user()?.userInfo?.userId
        
        let time = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["time"] = time
        
        MobClick.event("ProfileView", attributes:param)
    }
    
    //MARK: 通知点击
    class func um_event_me_click_notification(_ sys:Bool=false)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "我的"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["type"] = sys ? "系统" : "用户"
        
        let time = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["time"] = time
        
        MobClick.event("NotificationClick", attributes:param)
    }
    
    //MARK: 学分点击
    class func um_event_me_click_credits()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "我的"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["credit"] = WPUser.user()?.userInfo?.credit
        
        let time = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["time"] = time
        
        MobClick.event("CreditsClick", attributes:param)
    }
    
    //MARK: 累计学时点击
    class func um_event_me_click_learningHours()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "我的"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["learningHours"] = WPUser.user()?.userInfo?.creditDuration
        
        let time = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["time"] = time
        
        MobClick.event("LearningHoursClick", attributes:param)
    }
    
    //MARK: 查看我的日常计划
    class func um_event_me_click_dailyPlanView(planNum:Int = 0 , taskFinish:Bool = false)->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "我的"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["planNum"] = planNum
        param["taskFinish"] = taskFinish ? "是" : "否"
        
        let time = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["time"] = time
        
        MobClick.event("DailyPlanView", attributes:param)
    }
    
    //MARK: 关于wupen点击
    class func um_event_me_click_aboutWupen()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "我的"
        param["userId"] = WPUser.user()?.userInfo?.userId
 
        let time = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["time"] = time
        
        MobClick.event("AboutWupenClick", attributes:param)
    }
    
    //MARK: 检查更新点击
    class func um_event_me_click_checkUpdate()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "我的"
        param["userId"] = WPUser.user()?.userInfo?.userId
        param["current_Version"] = WPVersion
 
        let time = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["time"] = time
        
        MobClick.event("CheckUpdateClick", attributes:param)
    }
    
    //MARK: 反馈建议点击
    class func um_event_me_click_Feedback()->Void {
        var param:[String:Any] = [:]
        param["SourcePage"] = "我的"
        param["userId"] = WPUser.user()?.userInfo?.userId

        let time = Date.chinaDate("yyyy-MM-dd HH:mm:ss z")
        param["feedtime"] = time
        
        MobClick.event("FeedbackClick", attributes:param)
    }
}
