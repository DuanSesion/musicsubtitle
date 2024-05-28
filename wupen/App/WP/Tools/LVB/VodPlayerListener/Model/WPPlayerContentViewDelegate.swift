//
//  WPPlayerContentViewDelegate.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/25.
//

import UIKit
import AVFoundation

protocol WPPlayerContentViewDelegate: AnyObject {
    
    func didClickFailButton(in contentView: WPPlayerContentView)

    func didClickBackButton(in contentView: WPPlayerContentView)
    
    func didClickMoreAction(in contentView: WPPlayerContentView)
    
    func didClickNextAction(in contentView: WPPlayerContentView)

    func contentView(_ contentView: WPPlayerContentView, didClickPlayButton isPlay: Bool)

    func contentView(_ contentView: WPPlayerContentView, didClickFullButton isFull: Bool)

    func contentView(_ contentView: WPPlayerContentView, didChangeRate rate: Float)

    func contentView(_ contentView: WPPlayerContentView, didChangeVideoGravity videoGravity: AVLayerVideoGravity)

    func contentView(_ contentView: WPPlayerContentView, sliderTouchBegan slider: WPSlider)

    func contentView(_ contentView: WPPlayerContentView, sliderValueChanged slider: WPSlider)

    func contentView(_ contentView: WPPlayerContentView, sliderTouchEnded slider: WPSlider)
    
    func contentView(_ contentView: WPPlayerContentView, changeLanguage fileURL:String)
    
   
    
}
