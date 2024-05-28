//
//  WPVodPlayerListenerController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/23.
//

import UIKit
import AVFoundation
import CoreText

class WPVodPlayerListenerController: WPBaseController {
    
    lazy var playerView: WPPlayer = {
        var playerView: WPPlayer = WPPlayer()
        view.addSubview(playerView)
        return playerView
    }()
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        return label
    }()
    
    deinit {
         debugPrint(self)
        self.playerView.stop()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.playerView.pause()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        makeConstraints()
       
        
        let url = "https://wupen-video.oss-cn-shanghai.aliyuncs.com/course-video%2F4-Smarter%2520Yangpu%252C%2520Better%2520Life-WU%2520Zhiqiang-part1.mp4"
        let srtStr:String = Bundle.main.path(forResource: "b85f0510-0b7b-11eb-b39f-4fa6101a26c8_ln.vtt", ofType: nil) ?? ""
        
        self.playerView.setPlayerURL(url)
        self.playerView.setSRTURL(srtStr)
        self.playerView.pause()
 
        
        label.snp.makeConstraints { make in
            make.centerX.width.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
        
 
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
////        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterPlayground), name: UIApplication.didBecomeActiveNotification, object: nil)
//        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
//            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
//        }
//        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
 
    }
    
 
}


extension WPVodPlayerListenerController {
    
    func makeConstraints() {
        self.playerView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(280.0)
        }
    }
}


extension WPVodPlayerListenerController {
   @objc func didPlaybackEnds() {
        DispatchQueue.main.async {[weak self] in
            guard let weakSelf = self else { return }
            weakSelf.label.text = ""
            debugPrint("======结束")
        }
    }
}

 
