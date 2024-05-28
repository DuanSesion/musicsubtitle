//
//  WPFindTopView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/28.
//

import UIKit

class WPScanViewController:LBXScanViewController,WPHiddenNavigationDelegate {
    
    lazy var button: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(.init(systemName: "chevron.left"), for: .normal)
        button.imageView?.tintColor = .white
        button.clipsToBounds = true
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isOpenInterestRect = true
        self.scanStyle?.anmiationStyle = .LineMove
        self.scanStyle?.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        self.scanStyle?.colorRetangleLine = .clear
        self.scanStyle?.photoframeAngleStyle = .On
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.left.equalToSuperview()
            make.top.equalTo(view).offset(kStatusBarHeight)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(button)
    }
}
 
class WPFindTopView: UIView {
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
    

    
    lazy var searchButton: UIButton = {
        let icon:UIImage? = .init(systemName: "magnifyingglass")?.sd_resizedImage(with: CGSize(width: 24, height: 24), scaleMode: .aspectFill)
        var searchButton: UIButton = createButton(icon?.withTintColor(rgba(55, 55, 55), renderingMode: .alwaysOriginal), tag: 10)
        searchButton.backgroundColor = .clear
        searchButton.tintColor = rgba(55, 55, 55)
        return searchButton
    }()
    
    lazy var scanButton: UIButton = {
        let icon:UIImage? = .init(systemName: "qrcode.viewfinder")?.sd_resizedImage(with: CGSize(width: 24, height: 24), scaleMode: .aspectFill)
        var scanButton: UIButton = createButton(icon?.withTintColor(rgba(55, 55, 55), renderingMode: .alwaysOriginal), tag: 11)
        scanButton.backgroundColor = .clear
        scanButton.tintColor = rgba(55, 55, 55)
        return scanButton
    }()
}

extension WPFindTopView {
    func createButton(_ img:UIImage?,tag:Int) -> UIButton {
        let button: UIButton = UIButton()
        button.tag = tag
        button.setImage(img, for: .normal)
        button.clipsToBounds = true
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            weakSelf.buttonAction(button)
        }).disposed(by: disposeBag)
        addSubview(button)
        return button
    }
}

extension WPFindTopView {
    func buttonAction(_ button:UIButton) -> Void {
        if button == self.scanButton {
            let vc:WPScanViewController = WPScanViewController()
            vc.scanResultDelegate = self
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            
        } else if button == self.searchButton {
            let vc:WPSearchController = WPSearchController()
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension WPFindTopView:LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        if let str = scanResult.strScanned, let URLs = URL(string: str) {
            if URLs.scheme == "http" || URLs.scheme == "https" {
                let web:WPWebController = WPWebController()
                if URLs.scheme == "http" {
                    let url = str.replacingOccurrences(of: "http://", with: "https://")
                    web.url = url
                    
                } else {
                    web.url = str
                }
                self.yy_viewController?.navigationController?.pushViewController(web, animated: true)
                
            } else {
                self.yy_viewController?.view.showSucceed(str)
            }
        }
    }
}

extension WPFindTopView {
    func makeSubviews() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
    }
    
    func makeConstraints() -> Void {
        scanButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-12)
            make.width.height.equalTo(24)
        }
        
        searchButton.snp.makeConstraints { make in
            make.right.equalTo(scanButton.snp.left).offset(-18)
            make.centerY.size.equalTo(scanButton)
        }
    }
}

