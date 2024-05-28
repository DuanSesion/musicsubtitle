//
//  WPWebController.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/10.
//

import UIKit
import WebKit

class WPScriptMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 处理来自JavaScript的方法调用
        if let body = message.body as? String {
            print("接收到来自JavaScript的方法调用：\(body)")
            // 在这里处理你需要的逻辑
        }
        
        debugPrint("收到的数据：",message.body,message.name, message.frameInfo)
    }
}

class WPWebController: WPBaseController {
    var url:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        makeSubviews()
        makeConstraints()
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    lazy var webView: WKWebView = {
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
     
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.allowsInlineMediaPlayback = true
        if #available(iOS 17.0, *) {
            configuration.allowsInlinePredictions = true
        }
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        // 创建并设置用户内容控制器
        let contentController = WKUserContentController()
        let scriptMessageHandler = WPScriptMessageHandler()
        contentController.add(scriptMessageHandler, name: "nativeMethod") // 将方法名与处理程序关联
        contentController.add(scriptMessageHandler, name: "clickEvent")
        configuration.userContentController = contentController
 
        var webView: WKWebView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", context: nil)
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        self.view.addSubview(webView)
        return webView
    }()
    lazy var progressView: UIProgressView = {
        var progressView: UIProgressView = UIProgressView()
        progressView.isUserInteractionEnabled = false
        progressView.progressTintColor = rgba(254, 143, 11, 1)
        progressView.tintColor = .clear
        progressView.progressViewStyle = .bar
        progressView.isHidden = true
        self.view.addSubview(progressView)
        return progressView
    }()
}

extension WPWebController {
    func requestCamera() {
        AVCaptureDevice.requestAccess(for: .video) { r in }
        AVCaptureDevice.requestAccess(for: .audio) { r in }
    }
}

extension WPWebController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = (webView.title != nil && webView.title?.isEmpty == false) ?  webView.title : self.title
        self.progressView.setProgress(1, animated: true)
        self.progressView.isHidden = true
        
        let injectionJSString = "var script = document.createElement('meta');script.name = 'viewport';script.content=\"width=device-width, user-scalable=no\";document.getElementsByTagName('head')[0].appendChild(script);"
        webView.evaluateJavaScript(injectionJSString)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
        if error.asAFError?.responseCode == -999 {
            return
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
        debugPrint("error-", error)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.progressView.progress = Float(self.webView.estimatedProgress)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        let url = navigationAction.request.url
        
        let host = url?.host
        let payType = "ali" + "pay" + "client"
        if host == payType {
            let replacType = "ali" + "pays"
            let urlstr:String = url?.absoluteString.replacingOccurrences(of: replacType, with: "com.lllmark.wupenapp") ?? ""
            let aurl = URL(string: urlstr)
            UIApplication.shared.open(aurl!)
            self.navigationController?.popViewController(animated: false)
            
        } else if url?.absoluteString.contains("data:image/jpeg;base64,") == true {
            let web = WPWebController()
            web.url = url?.absoluteString ?? ""
            self.navigationController?.pushViewController(web, animated: true)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        debugPrint("====>", message.body)
    }
}

extension WPWebController {
    func makeSubviews() -> Void {
        self.view.backgroundColor = rgba(245, 245, 245)
        
        let urlStr = url.wp.trim()
        if urlStr.isEmpty == false && (urlStr.contains("http://") || urlStr.contains("https://")) {
            guard let url = URL(string: urlStr) else { return }
            let re = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy)
            self.webView.load(re as URLRequest)
            
        } else {
            let htmlStr = urlStr
            self.webView.loadHTMLString(htmlStr, baseURL: URL(string: HOST))
        }
    }
    
    func makeConstraints() -> Void {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.progressView.snp.makeConstraints { make in
            make.right.left.top.equalTo(self.view)
            make.height.equalTo(1.5)
        }
    }
}
