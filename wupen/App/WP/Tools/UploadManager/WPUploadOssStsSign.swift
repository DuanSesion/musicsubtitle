//
//  WPUploadOssStsSign.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/11.
//

import UIKit

//MARK: 上传---凭证
class WPUploadOssStsSign: Convertible {
    required init() {}
    var securityToken:String = ""
    var accessKeySecret:String = ""
    var accessKeyId:String = ""
    var dir:String = ""
    var accessId:String = ""
    var host:String = ""
    var endpoint:String = ""
    var bucket:String = ""
    var cdnPrefix:String = ""
    var expire:String = ""
}

extension WPUploadOssStsSign {
    //MARK: 获取 上传---凭证
    class func getOssStsSign(_ hanld:@escaping(_ model:WPUploadOssStsSign?)->Void) {
        Session.request(CommonOssStsSignURL) { model in
            if let json:[String:Any] = model.jsonModel?.data as? [String:Any]  {
                let model:WPUploadOssStsSign = json.kj.model(WPUploadOssStsSign.self)
                hanld(model)
                
            } else {
                hanld(nil)
                WPKeyWindowDev?.showError(model.msg ?? model.jsonModel?.msg)
            }
        }
    }
}
 
    
/**
 "data": {
     "securityToken": "CAISygJ1q6Ft5B2yfSjIr5bsL+/ZhexJzqXcW0OCkXZseMpevKHBuzz2IH9Pe3RqBesWsfQ0nmhT7Pcalr10UIQAR0XaZI5r4pcS/BOoZpLFtpQ6Z1bCFsT3d1KIAjvXgeXwAYygPv6/F96pb1fb7FwRpZLxaTSlWXG8LJSNkuQJR98LXw6+H1EkbZUsUWkEksIBMmbLPvuAKwPjhnGqbHBloQ1hk2hym8/dq4++kkOO1A2rk75K/t6oe8T/N5ZWUc0hA4vv7otfbbHc1SNc0R9O+ZptgbZMkTW95Y7GXAQLv07WbLqPqIU0dl4hfMogEqtDt+PgmOZkqgd2B2ogBeUm14h3JMe/LOjIqKOscGi5gAQt0OnQcvJBhmUF0jUhL+eIRTN6Uk0DMpF6CSRrKj8nMWqBcdTcwzuBGWrNBtbDvuhYvpQdIZrIxYTiTzAagAFAUIJFJvvehoBhpvNnlBDoQlOYP4AE1MRFb1hR/kcNBRegXUGlhEBLmDCjuf0wEfcDZH4hbiBJ/8p5euyCYTgBsNhm1Ia5nl4AUEWIJQ1eHR3JeOaUA7GxrfYeGHO60/hUNflAddQCCVeonPEfxjeRyr2nzDe/xhgL3Oe99NoGLSAA",
     "accessKeySecret": "CCUz2suS8FcD8Cp7cngKLm3gKZrNfLZHGK2KeVEijemX",
     "accessKeyId": "STS.NUYdUmh3hyg7Ye3uv9tErSdjY",
     "dir": "test/",
     "accessId": "LTAI5tCRaRKYdJHPvyEmJka4",
     "host": "http://wupen-video.oss-cn-shanghai.aliyuncs.com",
     "endpoint": "oss-cn-shanghai.aliyuncs.com",
     "bucket": "wupen-video",
     "cdnPrefix": "",
     "expire": 1715399078
   }
 */
