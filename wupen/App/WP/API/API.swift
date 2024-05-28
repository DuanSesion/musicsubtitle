//
//  API.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/28.
//

// let HOST = "http://192.168.50.250:19000"
 let HOST = "http://139.224.100.163/api"


 let AIURL = "http://58.33.91.82:18502/chat/knowledge_base_chat"
/**
 {
   "query": "马海夏",
   "knowledge_base_name": "wus",
   "top_k": 3,
   "score_threshold": 1,
  
   "stream": false,
   "model_name": "zhipu-api",
   "temperature": 0.7,
   "max_tokens": 0,
   "prompt_name": "default"
 }
 */


// ------------- 公共控制器

//MARK: 验证码 - target validType - PHONE_LOGIN
let SendValidURL = HOST + "/common/sendValid"
//MARK: 最近10条通知
let PublicNoticeURL = HOST + "/notice"
//MARK: 系列课程查询列表内容
let SeriesURL = HOST + "/series/list"
//MARK: 全局查询
let CommonQueryURL = HOST + "/common/query"
//MARK: 热门搜索词
let CommonHotKeywordURL = HOST + "/common/hotKeyword"
//MARK: 获取上传凭证
let CommonOssStsSignURL = HOST + "/common/ossStsSign"

// ------------- Banner控制器
//MARK: banner
let BannerPageURL = HOST + "/banner/page"


// ------------- 用户控制器
//MARK: 授权登录
let UserAuthURL = HOST + "/user/auth"
//MARK: 查询用户信息
let UserDetailURL = HOST + "/user/userDetail"
//MARK: 修改用户信息
let UserEditUserDetailURL = HOST + "/user/editUserDetail"

//MARK: 收藏
let UserCollectURL = HOST + "/user/collect"
//MARK: 取消收藏
let UserDeCollectURL = HOST + "/user/deCollect"
//MARK: 分页查询收藏
let UserPageMyCollectURL = HOST + "/user/pageMyCollect"
//MARK: 查询收藏ID 集 /user/collectAllId/{contentType}
let UserCollectAllIdURL = HOST + "/user/collectAllId/"

//MARK: 删除通知 /user/deleteNotice/{id}
let UserDeleteNoticeURL = HOST + "/user/deleteNotice/"
//MARK: 读取通知-/user/readNotice/{id}
let UserReadNoticeURL = HOST + "/user/readNotice/"
//MARK: 分页查询通知
let UserPageMyNoticeURL = HOST + "/user/pageMyNotice"


//MARK: 查询学分记录
let UserQueryCreditRecordURL = HOST + "/user/queryCreditRecord"
//MARK: 查询学xi时长记录
let UserQueryDurationRecordURL = HOST + "/user/queryDurationRecord"


// ------------- 课程控制器
//MARK: 添加人次 - /lecture/visitors/{lectureId}
let LectureVisitorsURL = HOST + "/lecture/visitors/"
//MARK: 查询课程
let LectureListURL = HOST + "/lecture"
//MARK: 看课计算时间心跳
let LectureWatchHeartbeatURL = HOST + "/lecture/watchHeartbeat"
//MARK: 查询课程详情/lecture/{id}
let LectureDetailURL = HOST + "/lecture/"
//MARK: 领取积分/lecture/receiveCredit/{lectureId}
let LectureReceiveCreditURL = HOST + "/lecture/receiveCredit/"
//MARK: 查询使用的语言
let LectureLangURL = HOST + "/lecture/lang"
//MARK: 查询使用的语言MAp
let LectureLangMapURL = HOST + "/lecture/langMap" 
//MARK: 查询课程分类
let LectureClassificationsURL = HOST + "/lecture/classifications"


// ------------- 直播控制器
//MARK: 直播编辑
let LiveEditURL = HOST + "/live/edit"
//MARK: 查询直播
let LiveCheckURL = HOST + "/live"
//MARK: 创建直播
let LiveSaveURL = HOST + "/live/save"
//MARK: 最近的一条直播
let LiveNextURL = HOST + "/live/next"
//MARK: 直播详情-/live/detail/{id}
let LiveDetailURL = HOST + "/live/detail/"


// ------------- 直播控制器
