//
//  WPUploadHeadSheetView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/11.
//

import UIKit

class WPUploadHeadSheetView: UIView {
    var didSelectedBlock:((_ x:UIImagePickerController.SourceType)->Void)?

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

    lazy var pickPhotoButton: UIButton = {
        var pickPhotoButton: UIButton = UIButton()
        let img = UIImage.wp.createColorImage(rgba(245, 245, 245, 1), size: CGSize(width: 343, height: 50)).wp.roundCorner(8)
        pickPhotoButton.setBackgroundImage(img, for: .normal)
        pickPhotoButton.setTitle("拍照", for: .normal)
        pickPhotoButton.setTitleColor(rgba(51, 51, 51, 1), for: .normal)
        pickPhotoButton.titleLabel?.font = .systemFont(ofSize: 14)
        pickPhotoButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                weakSelf.didSelectedBlock?(.camera)
                
            } else {
                WPKeyWindowDev?.showMessage("无相机权限，请前往设置授权")
            }
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(pickPhotoButton)
        return pickPhotoButton
    }()
    
    lazy var photoButton: UIButton = {
        var photoButton: UIButton = UIButton()
        let img = UIImage.wp.createColorImage(rgba(245, 245, 245, 1), size: CGSize(width: 343, height: 50)).wp.roundCorner(8)
        photoButton.setBackgroundImage(img, for: .normal)
        photoButton.setTitle("从相册上传", for: .normal)
        photoButton.setTitleColor(rgba(51, 51, 51, 1), for: .normal)
        photoButton.titleLabel?.font = .systemFont(ofSize: 14)
        photoButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                weakSelf.didSelectedBlock?(.photoLibrary)
                
            } else {
                WPKeyWindowDev?.showMessage("无相册权限，请前往设置授权")
            }
            weakSelf.hidden()
 
        }).disposed(by: disposeBag)
        contentView.addSubview(photoButton)
        return photoButton
    }()
}

extension WPUploadHeadSheetView {
    func show() -> Void {
        WPKeyWindowDev?.addSubview(self)
        let h = 132.0 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
        self.alpha = 1
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

extension WPUploadHeadSheetView {
    func makeSubviews () {
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        self.backgroundColor = rgba(0, 0, 0, 0.5)
        let h = 132.0 + (WPKeyWindowDev?.safeAreaInsets.bottom ?? 0)
        contentView.frame = .init(x: 0, y: WPScreenHeight - h, width: WPScreenWidth, height: h)
        contentView.setCorners([.topLeft,.topRight], cornerRadius: 8)
    }
    
    func makeConstraints () {
        pickPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        photoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pickPhotoButton.snp.bottom).offset(7)
        }
    }
}
/**
 if index == 0 {
     if UIImagePickerController.isSourceTypeAvailable(.camera){
         //初始化图片控制器
         let picker = UIImagePickerController()
         picker.modalPresentationStyle = .fullScreen
         picker.modalTransitionStyle = .crossDissolve
         //设置代理
         picker.delegate = self
         //指定图片控制器类型
         picker.sourceType = UIImagePickerController.SourceType.camera
         picker.imageExportPreset = .current
         //弹出控制器，显示界面
         self.yy_viewController?.present(picker, animated: true, completion: nil)
     }

 } else if index == 1 {
     //判断设置是否支持图片库
     if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
         //初始化图片控制器
         let picker = UIImagePickerController()
         picker.modalPresentationStyle = .fullScreen
         picker.modalTransitionStyle = .crossDissolve
         
         //设置代理
         picker.delegate = self
         //指定图片控制器类型
         picker.sourceType = UIImagePickerController.SourceType.photoLibrary

         //弹出控制器，显示界面
         self.yy_viewController?.present(picker, animated: true, completion: nil)
     }
 }
 */
