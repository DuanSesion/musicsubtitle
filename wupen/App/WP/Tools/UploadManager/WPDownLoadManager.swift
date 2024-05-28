//
//  WPDownLoadManager.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/11.
//

import UIKit

class WPDownLoadManager: NSObject {
    public static let `default` = WPDownLoadManager()
    var dowloadReques:DownloadRequest?
}


extension WPDownLoadManager {
    public class func downloadAssetBundle(_ convertible: URLConvertible, 
                                          downloadProgress:((_ progress:Float)->Void)? = nil,
                                          errorBlock:((_ error:Error?)->Void)?=nil,
                                          completionHandler: @escaping (_ filePath:String?) -> Void){
        
        let fileURL:String = "\(convertible)"
        guard let url:URL = URL(string: fileURL) else { return  }
        let name:NSString = NSString(string: fileURL)
        let path:String = FileManager.default.wp.subtitlesPath() + "/" + name.lastPathComponent
        let tempCachePath:String = path
        
        debugPrint(fileURL)
        
        if FileManager.default.fileExists(atPath: path){
            completionHandler(path)
        } else {
            let dowloadReques = AF.download(convertible, method: .get , to:  { (url, response) -> (destinationURL: URL, options: DownloadRequest.Options) in
                return (URL(fileURLWithPath: tempCachePath), [.createIntermediateDirectories, .removePreviousFile])
            })
            WPDownLoadManager.default.dowloadReques = dowloadReques
            
            dowloadReques.downloadProgress {  (pro) in
                let percent = Float(pro.completedUnitCount) / Float(pro.totalUnitCount)
                downloadProgress?(percent)
                
            }.response { response in
                WPDownLoadManager.default.dowloadReques = nil
                
                switch response.result {
                    case .success:
                        completionHandler(path)
                        break
                        
                    case .failure:
                        errorBlock?(response.error)
                        break
                }
            }
        }
    }
}
