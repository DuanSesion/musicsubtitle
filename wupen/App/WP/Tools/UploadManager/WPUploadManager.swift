//
//  WPUploadManager.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/11.
//

import UIKit

typealias WPUploadSuccessBlock = (String)->Void
typealias WPUploadErrorBlock = (String)->Void
typealias WPUploadProgressBlock = (Float)->Void

enum WPUploadFileType:Int {
    case image
    case video
    case text
    case data
    case json
    case audio
}

class WPUploadManager: NSObject {
    public static let `default` = WPUploadManager()
    
    var client:OSSClient?
    public var dowloadReques:DownloadRequest?
    public var downloadProgress:((_ progress:Float)->Void)? = nil
    public var completionHandler: ((_ filePath:String?, _ error:Error?) -> Void)? = nil
    public var key:String = ""
    public var progress:Float = 0
}

extension WPUploadManager {
    func stopUpload() -> Void {
        self.client?.networking.session.invalidateAndCancel()
    }
}

extension WPUploadManager {
   class func uploadData(fileData:Data,
                    fileType:WPUploadFileType = .image,
                    success:WPUploadSuccessBlock?=nil,
                    errorBlock:WPUploadErrorBlock?=nil,
                    progressBlock:WPUploadProgressBlock?=nil) -> Void {
       WPUploadManager.default.uploadData(fileData: fileData, fileType: fileType, success: success,errorBlock: errorBlock,progressBlock:progressBlock)
    }
    
    class func uploadFilePath(filePath:String,
                        fileType:WPUploadFileType = .image,
                        success:WPUploadSuccessBlock?=nil,
                        errorBlock:WPUploadErrorBlock?=nil,
                        progressBlock:WPUploadProgressBlock?=nil) -> Void {
        WPUploadManager.default.uploadFilePath(filePath: filePath, fileType: fileType, success: success,errorBlock: errorBlock,progressBlock:progressBlock)
    }
    
    func uploadData(fileData:Data,
                    fileType:WPUploadFileType = .image,
                    success:WPUploadSuccessBlock?=nil,
                    errorBlock:WPUploadErrorBlock?=nil,
                    progressBlock:WPUploadProgressBlock?=nil) -> Void {
        var fileName:String = "ios_img\(Date().timeIntervalSince1970)"
        fileName = fileName + ".png"
        
        let fullPath =  FileManager.default.wp.tempCachePath() + "/" + fileName
        try? fileData.write(to: URL.init(fileURLWithPath: fullPath))
        if FileManager.default.fileExists(atPath: fullPath) {
            uploadFilePath(filePath: fullPath, fileType: fileType, success: success,errorBlock: errorBlock,progressBlock:progressBlock)
        }
    }
    
    func uploadFilePath(filePath:String,
                        fileType:WPUploadFileType = .image,
                        success:WPUploadSuccessBlock?=nil,
                        errorBlock:WPUploadErrorBlock?=nil,
                        progressBlock:WPUploadProgressBlock?=nil) -> Void {
        if FileManager.default.fileExists(atPath: filePath) {
            WPUploadOssStsSign.getOssStsSign { model in
                if let ossStsSign = model {
                    let fileName:String = NSString(string: filePath).lastPathComponent
                    
                    let accessKeyId:String = ossStsSign.accessKeyId
                    let accessKeySecret:String =  ossStsSign.accessKeySecret
                    let securityToken:String = ossStsSign.securityToken
                    let dir:String = ossStsSign.dir
                    let bucketName:String = ossStsSign.bucket
                    let endpoint:String = ossStsSign.endpoint
                    
                    let put = OSSPutObjectRequest()
                    put.bucketName = bucketName
                    put.objectKey = dir + fileName
                    put.uploadingFileURL = URL(fileURLWithPath: filePath)
                    
                    if fileType == .image {
                        put.contentType = "image/png"
                    } else if fileType == .video {
                        put.contentType = "video/mp4"
                    } else if fileType == .text {
                        put.contentType = "text/plain"
                    } else if fileType == .json {
                        put.contentType = "application/json"
                    } else if fileType == .audio {
                        put.contentType = "audio/wav"
                    } else {
                        put.contentType = "multipart/form-data"
                    }
                    
                    put.uploadProgress = { (bytesSent, totalByteSent, totalBytesExpectedToSend) in
                        let progress:Float = Float(CGFloat(bytesSent)/CGFloat(totalByteSent))
                        debugPrint("上传进度:-------->", progress)
                    }
                    
                    //上传成功返回文件地址URL cdnPrefix
                    var remoteURL:String = ossStsSign.host + "/" + ossStsSign.dir + fileName
                    if  ossStsSign.cdnPrefix.isEmpty == false {
                        remoteURL = ossStsSign.cdnPrefix + "/" + ossStsSign.dir + fileName
                    }
                    
                    debugPrint("上传完文件地址：", remoteURL)
                    
                    DispatchQueue.global().async {
                        let oss = OSSStsTokenCredentialProvider.init(accessKeyId: accessKeyId, secretKeyId: accessKeySecret, securityToken: securityToken)
                        let config = OSSClientConfiguration()
                  
                        let client = OSSClient.init(endpoint: endpoint, credentialProvider: oss, clientConfiguration: config)
                        let putTask:OSSTask = client.putObject(put)
                        self.client = client
                      
                        putTask.continue({ (task) -> Any? in
                            DispatchQueue.main.async {[weak self] in
                                guard let weakSelf = self else { return }
                                if task.error == nil {//成功
                                    success?(remoteURL)
                                    
                                } else {
                                    errorBlock?("upload error")
                                }
                                //MARK: 删除临时文件
                                try? FileManager.default.removeItem(atPath: filePath)
                            }
                            return task
                            
                        }).waitUntilFinished()
                    }
                }
            }
            
        } else {
            errorBlock?("file not exit")
        }
    }
}
