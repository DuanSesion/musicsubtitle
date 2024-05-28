//
//  WPCustomHeaderFooterView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPCustomHeaderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
       // self.backgroundColor = .clear // 设置你想要的背景颜色
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
}
