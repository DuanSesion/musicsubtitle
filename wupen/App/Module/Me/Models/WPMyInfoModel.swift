//
//  WPMyInfoModel.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/30.
//

import UIKit

enum WPMyInfoCellRightType:Int {
    case none
    case arrow
    case copy
    case image
}

enum WPMyInfoType:Int {
    case avatar
    case nickname
    case no
    case sex
    case birthday
    case phone
    case other
    case none
}

class WPMyInfoModel: NSObject {
    var avtar:String = ""
    var title:String = ""
    var text:String = ""
    var cellID:String = ""
    var cellHeight:CGFloat = 50.0
    var rightType:WPMyInfoCellRightType = .none
    var type:WPMyInfoType = .none
    var updateHeaderImageBlock:((_ img:UIImage)->Void)?
    
    class func datas()->[WPMyInfoModel] {
        let userInfo = WPUser.user()?.userInfo
        
        
        let model1 = WPMyInfoModel()
        model1.rightType = .image
        model1.title = "头像"
        model1.cellHeight = 72
        model1.avtar = userInfo?.profilePhoto ?? ""
        model1.type = .avatar
        
        let model2 = WPMyInfoModel()
        model2.rightType = .none
        model2.title = "昵称"
        model2.text = userInfo?.username ?? ""
        model2.type = .nickname
 
        
        let model3 = WPMyInfoModel()
        model3.rightType = .copy
        model3.title = "学号"
        model3.text = userInfo?.userId ?? ""
        model3.type = .no
        
        let model4 = WPMyInfoModel()
        model4.rightType = .arrow
        model4.title = "性别"
        model4.text = "-"
        model4.type = .sex
        if (userInfo?.gender == 1) {
            model4.text = "男"
        } else if (userInfo?.gender == 0) {
            model4.text = "女"
        }
        
        let model5 = WPMyInfoModel()
        model5.rightType = .arrow
        model5.title = "生日"
        model5.text = userInfo?.birthday ?? "-"
        model5.type = .birthday
        
        let model6 = WPMyInfoModel()
        model6.rightType = .none
        model6.title = "登录手机号"
        model6.text = userInfo?.phone ?? "-"
        model6.type = .phone
        
        let model7 = WPMyInfoModel()
        model7.rightType = .arrow
        model7.title = "其他"
        model7.type = .other
 
        return [model1,model2,model3,model4,model5,model6,model7]
    }
}

extension WPMyInfoModel : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true) }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image:UIImage? = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        if picker.sourceType == UIImagePickerController.SourceType.camera {
            image = fixOrientationImage(image)
        }
        
        if let image = image {
            picker.dismiss(animated: false, completion: {
                let vc = PhotoEditCropViewController(photo: image, photoEditCropRatios: .ratio_1_1)
                vc.delegate = self
                WPKeyWindowDev?.rootViewController?.present(vc, animated: true)
            })
        }
    }
}

extension WPMyInfoModel:PhotoEditCropViewControllerDelegate {
    func cropViewControllerDidClickCancel(_ viewController: PhotoEditCropViewController) {
        viewController.dismiss(animated: true)
    }
    
    func cropViewController(_ viewController: PhotoEditCropViewController, didFinishCrop image: UIImage, cropRect: PhotoEditCropRect, orientation: UIImage.Orientation) {
            viewController.dismiss(animated: true)
            viewController.navigationController?.popViewController(animated: false)
        self.didFinishClippingPhoto(image: image.wp.scaleSize(CGSize(width: 180, height: 180))!)
    }
}

extension WPMyInfoModel {
    func didFinishClippingPhoto(image: UIImage) {
        self.updateHeaderImageBlock?(image)
        if let data:Data = image.pngData() {
            WPUploadManager.uploadData(fileData: data) { url in
                WPUser.userSaveMark(profilePhoto: url) { model in
                    SDImageCache.shared.store(image, forKey: url,toDisk:true)
                }
            } errorBlock: { msg in
                WPKeyWindowDev?.showError(msg)
            }
        }
     }
}

extension WPMyInfoModel {
    /// 修正方向图片
    func fixOrientationImage(_ imgae:UIImage?) -> UIImage? {
        guard let imgae = imgae else { return imgae }
        if imgae.imageOrientation == .up {
            return imgae
        }
        UIGraphicsBeginImageContextWithOptions(imgae.size, false, imgae.scale)
        imgae.draw(in: .init(origin: .zero, size: imgae.size))
        
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return imgae
        }
    }
}

