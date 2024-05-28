//
//  WPCourseDetailView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/15.
//

import UIKit
import WebKit

class WPCourseDetailView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubviews()
        makeConstraints()
    }

    lazy var contentView: UIView = {
        var contentView: UIView = UIView()
        contentView.backgroundColor = .white
        contentView.isUserInteractionEnabled = true
        addSubview(contentView)
        return contentView
    }()
    
    lazy var downButton: UIButton = {
        var downButton: UIButton = UIButton()
        downButton.setImage(.init(named: "play_submite_down_icon"), for: .normal)
        downButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.hidden()
        }).disposed(by: disposeBag)
//        let panGest:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGest(pan:)))
//        downButton.addGestureRecognizer(panGest)
        contentView.addSubview(downButton)
        return downButton
    }()
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(153, 153, 153, 0.20)
        contentView.addSubview(line)
        return line
    }()
    
    private lazy var titletLabel: UILabel = {//标题
        let view = UILabel()
        view.text = "课程简介"
        view.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        view.textColor = rgba(51, 51, 51, 1)
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.adjustsFontSizeToFitWidth = true
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var couserTitletLabel: UILabel = {
        let view = UILabel()
        view.text = "课程xxx"
        view.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        view.textColor = rgba(51, 51, 51, 1)
        view.textAlignment = .left
        view.numberOfLines = 0
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.adjustsFontSizeToFitWidth = true
        contentView.addSubview(view)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy var userHeder: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 9
        icon.clipsToBounds = true
        icon.backgroundColor = .gray
        contentView.addSubview(icon)
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        var nameLabel: UILabel = UILabel()
        nameLabel.text = "吴志强"
        nameLabel.textColor = rgba(51, 51, 51, 1)
        nameLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(nameLabel)
        return nameLabel
    }()
    
    lazy var lineX: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(211, 211, 211, 1)
        contentView.addSubview(line)
        return line
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "天府教育平台"
        textLabel.textColor = rgba(136, 136, 136, 1)
        textLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var webView: WKWebView = {
       
        
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
     
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true

        // 创建并设置用户内容控制器
        let contentController = WKUserContentController()
        let scriptMessageHandler = WPScriptMessageHandler()
        contentController.add(scriptMessageHandler, name: "nativeMethod") // 将方法名与处理程序关联
        contentController.add(scriptMessageHandler, name: "clickEvent")
        configuration.userContentController = contentController
        if #available(iOS 17.0, *) {
            configuration.allowsInlinePredictions = true
        }
 
        var webView: WKWebView = WKWebView(frame: .zero, configuration: configuration)
        webView.layer.cornerRadius = 10
        webView.contentMode = .scaleAspectFill
        webView.clipsToBounds = true
        webView.backgroundColor = .white

        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
            webView.pageZoom = 1
        }
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = false
        webView.allowsLinkPreview = true
        contentView.addSubview(webView)
        return webView
    }()
}

extension WPCourseDetailView {
    func show(_ couser:WPCouserDetailModel ) -> Void {
        WPKeyWindowDev?.addSubview(self)
        updateUI()
        updateCourse(couser)
        
        self.alpha = 1
        let h = 608.0/812 * WPScreenHeight
        contentView.y = WPScreenHeight
        UIView.animate(withDuration: 0.25) {
            self.contentView.y = WPScreenHeight - h
        }
    }
    
    func hidden() -> Void {
        UIView.animate(withDuration: 0.25) {
            self.contentView.y = WPScreenHeight
            self.alpha = 0
            
        } completion: { r in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self {
            hidden()
        }
    }
}

extension WPCourseDetailView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.5)
        updateUI()
        WPUmeng.um_event_course_Click_CourseIntro()
    }
    
    func updateUI() -> Void {
        self.frame = UIScreen.main.bounds
        let h = 608.0/812 * WPScreenHeight
        contentView.frame = .init(x: 0, y: WPScreenHeight - h, width: WPScreenWidth, height: h)
        contentView.setCorners([.topLeft,.topRight], cornerRadius: 12)
    }
    
    func makeConstraints () {
        downButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.centerX.top.equalToSuperview()
        }
        line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.width.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(75.0/812 * WPScreenHeight)
        }
        titletLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(37.0/812 * WPScreenHeight)
        }
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(193.0/812 * WPScreenHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(line.snp.bottom).offset(13.0/812 * WPScreenHeight)
        }
        couserTitletLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(line)
            make.top.equalTo(imageView.snp.bottom).offset(12.0/812 * WPScreenHeight)
        }
        userHeder.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(couserTitletLabel.snp.bottom).offset(12.0/812 * WPScreenHeight)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(userHeder.snp.right).offset(2)
            make.centerY.equalTo(userHeder)
        }
        lineX.snp.makeConstraints { make in
            make.centerY.equalTo(userHeder)
            make.right.equalTo(nameLabel.snp.right).offset(10)
            make.width.equalTo(0.5)
            make.height.equalTo(9)
        }
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(line.snp.right).offset(10)
            make.centerY.equalTo(userHeder)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(userHeder.snp.bottom).offset(15.0/812 * WPScreenHeight)
            make.bottom.centerX.equalToSuperview()
            make.width.equalTo(line)
        }
    }
}

extension WPCourseDetailView {
    func updateCourse(_ couser:WPCouserDetailModel) -> Void {
        imageView.sd_setImage(with: .init(string: couser.lecture?.coverImage ?? ""))
        userHeder.sd_setImage(with: .init(string: couser.couser?.scholarAvatar ?? ""))
        nameLabel.text = WPLanguage.chinessLanguage() ? couser.couser?.scholarName : couser.couser?.scholarNameEn
        textLabel.text = couser.lecture?.university
        couserTitletLabel.text = WPLanguage.chinessLanguage() ? couser.lecture?.chineseTitle : couser.lecture?.englishTitle
        
        let htmlStr = WPLanguage.chinessLanguage() ? couser.lecture?.chineseIntroduce : couser.lecture?.englishIntroduce
        if let htmlStr = htmlStr {
            self.webView.loadHTMLString(htmlStr, baseURL: URL(string: HOST))
        }
    }
}

extension WPCourseDetailView:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let injectionJSString = "var script = document.createElement('meta');script.name = 'viewport';script.content=\"width=device-width, user-scalable=no\";document.getElementsByTagName('head')[0].appendChild(script);"
        webView.evaluateJavaScript(injectionJSString)
    }
 
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        let url = navigationAction.request.url
        debugPrint(url as Any)
    }
}

extension WPCourseDetailView:WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}
