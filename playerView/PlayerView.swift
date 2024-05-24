//
//  PlayerView.swift
//  player
//
//  Created by 栾昊辰 on 2024/5/23.
//

import UIKit
import AVKit

class PlayerView: UIView {

    override class var layerClass: AnyClass {
        return AVPlayerLayer.classForCoder()
    }
    
    
    var playerLayer:AVPlayerLayer!{
        get {
            return (self.layer as! AVPlayerLayer)
        }
    }
    
}
