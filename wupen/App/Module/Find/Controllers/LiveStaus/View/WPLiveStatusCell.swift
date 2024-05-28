//
//  WPLiveStatusCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/6.
//

import UIKit
import WebKit

class WPLiveStatusCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeSubviews()
        makeConstraints()
    }
    
    lazy var countLabel: UILabel = {
        var countLabel: UILabel = UILabel()
        countLabel.text = "详情"
        countLabel.font = .systemFont(ofSize: 18)
        countLabel.textColor = rgba(51, 51, 51, 1)
        contentView.addSubview(countLabel)
        return countLabel
    }()
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(245, 245, 245, 1)
        contentView.addSubview(line)
        return line
    }()
    
    lazy var iconImageView: UIImageView = {
        var iconImageView: UIImageView = UIImageView()
        iconImageView.layer.cornerRadius = 10
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.backgroundColor = .white
        contentView.addSubview(iconImageView)
        return iconImageView
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
    
    var  detail:WPLiveDetailModel?{
        didSet {
            if let htmlStr = detail?.description {
                self.webView.loadHTMLString(htmlStr, baseURL: URL(string: HOST))
            }
        }
    }
}

extension WPLiveStatusCell {
    func makeSubviews() {
        self.backgroundColor = .white
        self.selectionStyle = .none
    }
    
    func makeConstraints() -> Void {
        line.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(8)
        }
        
        countLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(line.snp.bottom).offset(18)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(countLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        
        webView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(countLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
}

extension WPLiveStatusCell:WKNavigationDelegate {
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

extension WPLiveStatusCell:WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}

