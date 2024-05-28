//
//  Date+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/14.
//

import Foundation

public extension Date {
  static func chinaDate(dateString:String,dateFormat:String="yyyy-MM-dd HH:mm:ss")->String? {
        let dateString = dateString // 这是一个UTC时间的例子

        // 定义日期格式器并设置输入日期字符串的格式
        let dateFormatter = DateFormatter()

        // 设置日期格式，这里根据你的字符串时间格式进行调整
        dateFormatter.dateFormat = dateFormat

        // 解析字符串中的时区，并设置为UTC
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        // 将字符串转换为Date
        if let date = dateFormatter.date(from: dateString) {
            print("Original date: \(date)")
            // 转换为中国时区
            let chinaTimeZone = TimeZone(identifier: "Asia/Shanghai")!
            dateFormatter.timeZone = chinaTimeZone

            // 重新格式化日期为字符串以验证时区转换，可选步骤
            let formattedDateInChina = dateFormatter.string(from: date)
            return formattedDateInChina
            
        } else {
            print("Failed to convert string to date.")
            return nil
        }
    }
    
     static func chinaDate(dateString:String,dateFormat:String="yyyy-MM-dd HH:mm:ss")->Date {
        let dateString = dateString// 这是一个UTC时间的例子

        // 定义日期格式器并设置输入日期字符串的格式
        let dateFormatter = DateFormatter()

        // 设置日期格式，这里根据你的字符串时间格式进行调整
        dateFormatter.dateFormat = dateFormat

        // 解析字符串中的时区，并设置为UTC
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        // 将字符串转换为Date
        if let date = dateFormatter.date(from: dateString) {
            print("Original date: \(date)")
            // 转换为中国时区
            let chinaTimeZone = TimeZone(identifier: "Asia/Shanghai")!
            dateFormatter.timeZone = chinaTimeZone

            // 重新格式化日期为字符串以验证时区转换，可选步骤
            if let formattedDateInChina = dateFormatter.date(from: dateString) {
                return formattedDateInChina
            }
            return Date.jk.currentDate
            
        } else {
            print("Failed to convert string to date.")
            return Date.jk.currentDate
        }
    }
    
    static func chinaDate(_ dateFormat:String = "yyyy-MM-dd HH:mm:ss z")->String {
        // 获取当前本地时间的Date对象
        let localDate = Date()

        // 创建一个DateFormatter用于格式化
        let dateFormatter = DateFormatter()

        // 设置输出的日期格式，根据需要自定义
        dateFormatter.dateFormat = dateFormat

        // 设置时区为中国的时区（上海）
        let chinaTimeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.timeZone = chinaTimeZone

        // 使用DateFormatter将Date转换为字符串，这时会体现为中国时区的时间
        let chinaTimeStr = dateFormatter.string(from: localDate)

        print("Local Date: \(localDate.description(with: .current))") // 输出本地
        print("china Date: \(localDate.description(with: .init(identifier: "Asia/Shanghai")))") // 输出本地
        
        return chinaTimeStr
    }
    
   static func chinaDate()->Date {
        // 获取当前本地时间的Date对象
        let localDate = Date()

        // 创建一个DateFormatter用于格式化
        let dateFormatter = DateFormatter()

        // 设置输出的日期格式，根据需要自定义
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"

        // 设置时区为中国的时区（上海）
        let chinaTimeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.timeZone = chinaTimeZone

        // 使用DateFormatter将Date转换为字符串，这时会体现为中国时区的时间
        let chinaTimeDate = dateFormatter.date(from: chinaDate())

        print("Local Date: \(localDate.description(with: .current))") // 输出本地
       
        if  let chinaTimeDate = chinaTimeDate {
            return chinaTimeDate
        }
       return Date.jk.currentDate.nowToLocalDate()
    }
    
    //MARK: 非服务器转化成当地时区时间 (日历)
    func nowToLocalDate() -> Date {
        //设置源日期时区
       let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
       ///或GMT
       //设置转换后的目标日期时区
        let chinaTimeZone = TimeZone.autoupdatingCurrent
        
       let destinationTimeZone = chinaTimeZone
       //得到源日期与世界标准时间的偏移量
        let sourceGMTOffset: Int = sourceTimeZone?.secondsFromGMT(for: self) ?? 0
       //目标日期与本地时区的偏移量
        let destinationGMTOffset: Int = destinationTimeZone.secondsFromGMT (for: self) 
       //得到时间偏移量的差值
       let interval:TimeInterval = TimeInterval((destinationGMTOffset) - (sourceGMTOffset))
       ///转为现在时间
        let destinationDateNow: Date  =  Date(timeInterval: interval, since: self)
       return destinationDateNow
    }
    
    //MARK: 非服务器转化成当地时区时间 (日历)
    func nowToChinaDate() -> Date {
        //设置源日期时区
       let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
       ///或GMT
       //设置转换后的目标日期时区
        let chinaTimeZone = TimeZone(identifier: "Asia/Shanghai")
        
       let destinationTimeZone = chinaTimeZone
       //得到源日期与世界标准时间的偏移量
        let sourceGMTOffset: Int = sourceTimeZone?.secondsFromGMT(for: self) ?? 0
       //目标日期与本地时区的偏移量
        let destinationGMTOffset: Int = destinationTimeZone?.secondsFromGMT (for: self) ?? 0
       //得到时间偏移量的差值
       let interval:TimeInterval = TimeInterval((destinationGMTOffset) - (sourceGMTOffset))
       ///转为现在时间
        let destinationDateNow: Date  =  Date(timeInterval: interval, since: self)
       return destinationDateNow
    }
    
     func chinaDate(_ dateFormat:String = "yyyy-MM-dd HH:mm:ss z")->String {
        // 获取当前本地时间的Date对象
        let localDate = self

        // 创建一个DateFormatter用于格式化
        let dateFormatter = DateFormatter()

        // 设置输出的日期格式，根据需要自定义
        dateFormatter.dateFormat = dateFormat

        // 设置时区为中国的时区（上海）
        let chinaTimeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.timeZone = chinaTimeZone

        // 使用DateFormatter将Date转换为字符串，这时会体现为中国时区的时间
        let chinaTimeStr = dateFormatter.string(from: localDate)

        print("Local Date: \(localDate.description(with: .current))") // 输出本地
        print("china Date: \(localDate.description(with: .init(identifier: "Asia/Shanghai")))") // 输出本地
        
        return chinaTimeStr
    }
}
