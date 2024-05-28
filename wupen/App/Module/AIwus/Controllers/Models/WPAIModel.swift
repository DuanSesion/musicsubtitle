//
//  WPAIModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/5.
//

import UIKit

class WPAIModel: Convertible {
    required init() {}
    
    var isMe:Bool = false
    var isSend:Bool = false
    var needAnimate:Bool = false
    var textMsg:String = ""
    var time:String?
    var resultBlock:(()->Void)?
    
    class func caches() -> [WPAIModel]? {
        let userId = (WPUser.user()?.userInfo?.userId ?? "")  + "_ai"
        return read([WPAIModel].self, from: FileManager.default.wp.usersPath() + "/\(userId)")
    }
    
    class func save(_ datas:[WPAIModel]) -> Void {
        let userId = (WPUser.user()?.userInfo?.userId ?? "") + "_ai"
        write(datas, to: FileManager.default.wp.usersPath() + "/\(userId)")
    }
}

class WPAIResponse: Convertible {
    required init() {}
    var answer:String = ""
    var docs:[String] = []
}


extension WPAIModel {
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
    func sendAIMessage(_ text:String?,history:[[String:Any]] = [], _ hanld:@escaping(_ model:APIResponse)->Void) {
        var parm:[String:Any] = [:]
        parm["query"] = text
        parm["knowledge_base_name"] = "wus"
        parm["top_k"] = 3
        parm["score_threshold"] = 1
        parm["stream"] = false
        parm["model_name"] = "zhipu-api"
        parm["temperature"] = 0.7
        parm["max_tokens"] = 0
        parm["prompt_name"] = "default"
        
        var history = history
        
        var s:[String:Any] = [:]
        s["role"] = "user"
        s["content"] = "你好"
        
        var s1:[String:Any] = [:]
        s1["role"] = "assistant"
        s1["content"] = "你好！请问有什么问题我可以帮您解答吗？"
       
        history.append(contentsOf: [s,s1])
        parm["history"] = history
        
        self.isSend = true
        Session.requestBody(AIURL,method: .post,parameters: parm) {[weak self] model in
            debugPrint("=======================>", model.code)
            if let result = model.data?.kj.model(WPAIResponse.self) {
                self?.textMsg = result.answer
            }
            
            self?.needAnimate = true
//            self?.resultBlock?()
            self?.isSend = false
            hanld(model)
            
        }
    }
}
