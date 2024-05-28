//
//  SGPagingCollectionView.swift
//  MarkUniverse
//
//  Created by Mark on 2022/11/28.
//

import UIKit

class SGPagingCollectionView: UICollectionView,UIGestureRecognizerDelegate {

    @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         if self.contentOffset.x <= 45 {
             return true
         }
         return false
     }

}
