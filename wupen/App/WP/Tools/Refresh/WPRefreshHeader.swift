//
//  WPRefreshHeader.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/29.
//

import UIKit

class WPRefreshHeader: MJRefreshGifHeader {
    
    lazy var animationView: WPRotateAnimationView = {
        var animationView: WPRotateAnimationView = WPRotateAnimationView()
        addSubview(animationView)
        return animationView
    }()

    override func prepare() {
         super.prepare()
        
//        var imgs:[UIImage] = []
//        if let img = UIImage(systemName: "arrow.2.circlepath") {
//            imgs.append(img)
//        }
//        
//        if let img = UIImage(systemName: "arrow.2.circlepath.circle.fill") {
//            imgs.append(img)
//        }
//        
//        if let img = UIImage(systemName: "arrow.2.circlepath.circle") {
//            imgs.append(img)
//        }
        
        self.lastUpdatedTimeLabel?.isHidden = true
//        self.setImages(imgs, for: .pulling)
//        self.setImages(imgs, for: .refreshing)
        self.setTitle("", for: .idle)
        self.setTitle("有教无类，创意无疆", for: .pulling)
        self.setTitle("有教无类，创意无疆", for: .refreshing)
        self.stateLabel?.font = .boldSystemFont(ofSize: 12)
        self.stateLabel?.textColor = rgba(120, 120, 120)
        self.gifView?.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
    
    }
 
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                animationView.stopAnimation()
                break
            case .noMoreData:
                animationView.stopAnimation()
                break
            case .pulling:
                animationView.startAnimation()
                break
            case .refreshing:
                animationView.startAnimation()
                break
            case .willRefresh:
                animationView.startAnimation()
                break
            default:
                animationView.stopAnimation()
                break
            }
        }
    }
}
