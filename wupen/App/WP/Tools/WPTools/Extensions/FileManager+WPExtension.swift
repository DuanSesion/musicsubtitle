//
//  FileManager+WPExtension.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

extension FileManager: WPPOPCompatible { }
extension FileHandle: WPPOPCompatible { }


public extension WPPOP where Base == FileManager {
    
    func cachePath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
    
    func documentDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    }
    
    func tempCachePath() -> String {
        return NSTemporaryDirectory()
    }
    
    func appPath() -> String {
        return cachePath() + "/com.lllmark.wupenapp.caches"
    }
    
    func usersPath() -> String {
        return cachePath() + "/com.lllmark.wupenapp.caches/users"
    }
    
    func videosPath() -> String {
        return cachePath() + "/com.lllmark.wupenapp.caches/videos"
    }
    
    func subtitlesPath() -> String {
        return cachePath() + "/com.lllmark.wupenapp.caches/subtitles"
    }
    
    func searchCachePath() -> String {
        return cachePath() + "/com.lllmark.wupenapp.caches/searchcache"
    }
    
    func sqliteCachePath() -> String {
        return cachePath() + "/com.lllmark.wupenapp.caches/sqlitechcache"
    }
    
    func languagesCachePath() -> String {
        return cachePath() + "/com.lllmark.wupenapp.caches/languagesCachePath"
    }
    
    func collectIDsCachePath() -> String {
        return cachePath() + "/com.lllmark.wupenapp.caches/collectIDs"
    }
    
    func createFileFolder() -> Void {
        //let pointer = UnsafeMutablePointer<ObjCBool>.allocate(capacity:1)
        let manager = FileManager.default
        do {
            let appPath = appPath()
            if !manager.fileExists(atPath: appPath){
               try? manager.createDirectory(atPath: appPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            let usersPath = usersPath()
            if !manager.fileExists(atPath: usersPath) {
               try? manager.createDirectory(at: URL(fileURLWithPath: usersPath), withIntermediateDirectories: true, attributes: nil)
            }
            
            let subtitlesPath = subtitlesPath()
            if !manager.fileExists(atPath: subtitlesPath) {
               try? manager.createDirectory(at: URL(fileURLWithPath: subtitlesPath), withIntermediateDirectories: true, attributes: nil)
            }
            
            let videosPath = videosPath()
            if !manager.fileExists(atPath: videosPath) {
               try? manager.createDirectory(at: URL(fileURLWithPath: videosPath), withIntermediateDirectories: true, attributes: nil)
            }
            
            let searchCache = searchCachePath()
            if !manager.fileExists(atPath: searchCache) {
               try? manager.createDirectory(at: URL(fileURLWithPath: searchCache), withIntermediateDirectories: true, attributes: nil)
            }
            
            let sqliteCache = searchCachePath()
            if !manager.fileExists(atPath: sqliteCache) {
               try? manager.createDirectory(at: URL(fileURLWithPath: sqliteCache), withIntermediateDirectories: true, attributes: nil)
            }
            
            let collectIDsCache = collectIDsCachePath()
            if !manager.fileExists(atPath: collectIDsCache) {
               try? manager.createDirectory(at: URL(fileURLWithPath: collectIDsCache), withIntermediateDirectories: true, attributes: nil)
            }
            
            let languagesCachePath = languagesCachePath()
            if !manager.fileExists(atPath: languagesCachePath) {
               try? manager.createDirectory(at: URL(fileURLWithPath: languagesCachePath), withIntermediateDirectories: true, attributes: nil)
            }
            
            try "1".write(toFile: usersPath + "/1.txt", atomically: true, encoding: .utf8)
            
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
}
