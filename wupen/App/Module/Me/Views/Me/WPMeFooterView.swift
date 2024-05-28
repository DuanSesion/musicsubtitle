//
//  WPMeFooterView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

class WPMeFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

extension WPMeFooterView {
    func setup() -> Void {
        self.backgroundColor = .white
    }
}
