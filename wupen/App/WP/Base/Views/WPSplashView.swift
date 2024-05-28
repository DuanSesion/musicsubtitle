//
//  WPSplashView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

class WPSplashView: UIImageView {
    private var timeObserve: DispatchSourceTimer!
    private let timeInterval:Double = 6.0

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    lazy var label: UILabel = {
        var label: UILabel = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "跳过(3s)"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = rgba(254, 143, 11, 1)
        label.backgroundColor = rgba(255, 237, 211, 1)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        self.addSubview(label)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    lazy var textLabel: UILabel = {
        var label: UILabel = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "Hi!新同学！\n欢迎加入WUPEN!"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = .black
        label.backgroundColor = .clear
        label.layer.cornerRadius = 20
        label.numberOfLines = 0
        label.clipsToBounds = true
        self.addSubview(label)
        return label
    }()
    
    var timeNum:Int! {
        didSet {
            let attr = NSMutableAttributedString.init(string:"跳过\(timeNum ?? 6)s")
            attr.yy_color = rgba(254, 143, 11, 1)
            attr.addAttributes([NSAttributedString.Key.foregroundColor : rgba(51, 51, 51, 1)], range: NSRange(location: 2,length: attr.length-2))
            self.label.attributedText = attr
        }
    }
}

extension WPSplashView {
    func setup () {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        
        self.label.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 40))
            make.bottom.equalTo(self).offset(-40)
            make.right.equalTo(self).offset(-20)
        }
        
        self.textLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(50)
            make.top.equalTo(self).offset(200)
            make.right.equalTo(self).offset(-50)
        }
        
        dispatchTimer(timeInterval: 0.1, repeatCount: 4) {[weak self] t, i in
            guard let weakSelf = self else {return}
            weakSelf.timeNum = Int(i)
            if weakSelf.timeNum <= 0 {
                weakSelf.dissmiss()
            }
        }
    }
    
    func dissmiss() -> Void {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
            self.removeFromSuperview()
            
        } completion: { r in
            NotificationCenter.default.post(name:.init("SplashDissmiss"), object: nil)
        }
    }
    
    func show(_ inView:UIView?) -> Void {
        inView?.addSubview(self)
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
            
        } completion: { r in }
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer) {
        timeObserve.cancel()
        self.dissmiss()
    }
}

extension WPSplashView {
    func dispatchTimer(timeInterval: Double, repeatCount: Double, handler: @escaping (DispatchSourceTimer?, Double) -> Void) {
        if repeatCount <= 0 {
            return
        }
        if timeObserve != nil {
            timeObserve.cancel()//销毁旧的
        }
        // 初始化DispatchSourceTimer前先销毁旧的，否则会存在多个倒计时
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timeObserve = timer
        var count = repeatCount
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler {
            count -= timeInterval
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count <= 0 {
                timer.cancel()
            }
        }
        timer.resume()
  }
}
