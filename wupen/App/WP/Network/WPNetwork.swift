//
//  WPNetwork.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

public var ApiHeaders: HTTPHeaders {
    get {
        let head: HTTPHeaders = [
            "deviceModel": UIDevice.current.model,
            "uuidString": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "systemName": UIDevice.current.systemName,
            "system_version": UIDevice.current.systemVersion,
            "version": WPVersion,
            "Accept": "*/*",
            "Content-Type": "application/x-www-form-urlencoded;application/octet-stream;multipart/form-data; boundary=FormBoundary;application/json;application/xml;text/plain;charset=UTF-8",
            "Authorization": ""
        ]
        return head
    }
}

class WPResponse: Convertible {
    required init() {}
    var code:Int = 0
    var success:Bool = false
    var msg:String?
    var time:String?
    var data:Any?
    
    var pageNum:Int = 0
    var pageSize:Int = 0
    var totalElements:Int = 0
    var totalPage:Int = 0
}

class APIResponse:NSObject {
    var data:Data?
    var code:Int = 0
    var msg:String?
    var jsonModel:WPResponse?
    
    init(_ response:AFDataResponse<Data?>) {
        self.code = response.response?.statusCode ?? 0
        self.data = response.data
        self.msg = response.error?.errorDescription ?? response.error?.localizedDescription
        if let data = response.data {
            self.jsonModel = data.kj.model(WPResponse.self)
            
            guard let user = WPUser.user() else { return  }
            if self.jsonModel?.code == 401 {//失效token
                WPUser.clean()
                debugPrint(user.token as Any)
            }
        }
    }
}

extension Session {
    class func request(_ convertible: URLConvertible,
                       method: HTTPMethod = .get,
                       parameters: [String:Any]? = nil,
                       timeout:TimeInterval = 5,
                       completionHandler: @escaping (_ model:APIResponse) -> Void)->Void  {

        var headers: HTTPHeaders = ApiHeaders
        let user:WPUser? = WPUser.user()
        headers["Authorization"] = user?.token
        
        AF.sessionConfiguration.timeoutIntervalForRequest = timeout
        AF.sessionConfiguration.timeoutIntervalForResource = timeout
        
        AF.session.configuration.timeoutIntervalForRequest = timeout
        AF.session.configuration.timeoutIntervalForResource = timeout
        AF.request(convertible, method: method, parameters: parameters, headers: headers).response { response in
            let model = APIResponse(response)
            completionHandler(model)
            
            debugPrint(response)
        }
    }
    
   class func requestBody(_ convertible: URLConvertible,
                       method: HTTPMethod = .post,
                       parameters: Parameters? = nil,
                       timeout:TimeInterval = 5,
                       completionHandler: @escaping (_ model:APIResponse) -> Void)  {
        
   
        var headers: HTTPHeaders = ApiHeaders
        headers["Content-Type"] = "application/json;application/xml;text/plain"
        
        let user:WPUser? = WPUser.user()
        headers["Authorization"] = user?.token
        
        var request = URLRequest(url: URL(string: convertible as! String)!)
        request.httpMethod = method.rawValue
        request.headers = headers
 
        if let json:[String:Any] = parameters, 
           let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed) {
//            let parame:NSMutableDictionary = NSMutableDictionary(dictionary: json)
            request.httpBody = data
        }
        
        AF.sessionConfiguration.timeoutIntervalForRequest = timeout
        AF.sessionConfiguration.timeoutIntervalForResource = timeout

        AF.session.configuration.timeoutIntervalForRequest = timeout
        AF.session.configuration.timeoutIntervalForResource = timeout
        AF.request(request).response { response in
            let model = APIResponse(response)
            completionHandler(model)
            debugPrint(response)
          
            switch response.result {

                case .success:
                
                    break
                    
                case .failure:
 
                         
                    break
                }
        }
    }
    
    class func requestArrayBody(_ convertible: URLConvertible,
                       method: HTTPMethod = .post,
                       array: [Any]? = nil,
                       timeout:TimeInterval = 5,
                       completionHandler: @escaping (_ model:APIResponse) -> Void)  {
        
        var headers: HTTPHeaders = ApiHeaders
        headers["Content-Type"] = "application/json;application/xml;text/plain"
        
        let user:WPUser? = WPUser.user()
        headers["Authorization"] = user?.token
        
        var request = URLRequest(url: URL(string: convertible as! String)!)
        request.httpMethod = method.rawValue
        request.headers = headers
        if let datas = array, 
           let data = try? JSONSerialization.data(withJSONObject: datas, options: .fragmentsAllowed) {
           request.httpBody = data
        }

        AF.sessionConfiguration.timeoutIntervalForRequest = timeout
        AF.sessionConfiguration.timeoutIntervalForResource = timeout
       
        AF.session.configuration.timeoutIntervalForRequest = timeout
        AF.session.configuration.timeoutIntervalForResource = timeout
        AF.request(request).response { response in
            let model = APIResponse(response)
            completionHandler(model)
        }
    }
}
