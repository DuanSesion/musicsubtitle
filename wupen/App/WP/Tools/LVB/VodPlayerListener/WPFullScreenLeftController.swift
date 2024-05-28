//
//  WPFullScreenLeftController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

class WPFullScreenLeftController: WPPlayerFullScreenController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }

    deinit {
        print("WPFullScreenLeftController deinit")
    }

}
