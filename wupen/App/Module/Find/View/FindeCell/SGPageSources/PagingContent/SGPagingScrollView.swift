//
//  SGPagingScrollView.swift
//  MarkUniverse
//
//  Created by Mark on 2022/11/28.
//

import UIKit

class SGPagingScrollView: UIScrollView,UIGestureRecognizerDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isMultipleTouchEnabled = true
        self.delaysContentTouches = true
        self.canCancelContentTouches = true
        self.isDirectionalLockEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.scrollsToTop = true
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if self.contentOffset.x <= 45 {
//            return true
//        }
//        return false
//    }
}
