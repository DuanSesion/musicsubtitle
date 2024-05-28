//
//  WPFindeCell1.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/3.
//

import UIKit

class WPFindeCell1: UICollectionViewCell {
    private var currentIndex:Int = 0
    
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
    
    lazy var cycleScrollView: SDCycleScrollView = {
        var cycleScrollView: SDCycleScrollView = SDCycleScrollView()
        cycleScrollView.backgroundColor = .clear
        cycleScrollView.delegate = self
        cycleScrollView.autoScrollTimeInterval = 3
        cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
        contentView.addSubview(cycleScrollView)
        return cycleScrollView
    }()
    
    lazy var datas: [URL]  = {
        var datas:[URL] = []
//        if let url = URL(string: "https://hbimg.b0.upaiyun.com/3d5b11e0b5693b6576b4e86243fbc5c7b59a732825148-16PKyA_fw658") {
//            datas.append(url)
//        }
//        
//        if let url = URL(string: "https://img2.baidu.com/it/u=806019338,30866415&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=281") {
//            datas.append(url)
//        }
//        
//        if let url = URL(string: "https://img2.baidu.com/it/u=2584602181,1684311270&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=500") {
//            datas.append(url)
//        }
        return datas
    }()
    
    var model:WPFindeCellModel!{
        didSet {
            self.datas.removeAll()
            if let datas:[WPBanner] = model.datas as? [WPBanner] {
                for item in datas {
                    if let url = URL(string: item.image) {
                        self.datas.append(url)
                    }
                }
            }
            cycleScrollView.imageURLStringsGroup = datas
        }
    }
}

extension WPFindeCell1:SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, left index: Int) {
        WPUmeng.um_event_find_BannerSwipe(true)
        debugPrint("left")
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, right index: Int) {
        WPUmeng.um_event_find_BannerSwipe(false)
        debugPrint("right")
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let datas:[WPBanner] = model.datas as? [WPBanner] {
            if index < datas.count {
                let mode = datas[index]
                let web:WPWebController = WPWebController()
                debugPrint(mode.h5_link as Any,mode.links)
                if let h5 = mode.h5_link {
                    web.url = h5
                    
                } else {
                    web.url = mode.links
                }
                self.yy_viewController?.navigationController?.pushViewController(web, animated: true)
                WPUmeng.um_event_find_BannerClick(mode.id)
            }
        }
    }
    
    func customCollectionViewCellClass(for view: SDCycleScrollView!) -> AnyClass! {
        return WPBannerCell.self
    }
    
    func setupCustomCell(_ cell: UICollectionViewCell!, for index: Int, cycleScrollView view: SDCycleScrollView!) {
        if let  cell = cell as?  WPBannerCell {
            cell.imageView.sd_setImage(with: datas[index], placeholderImage: nil)
        }
    }
}

extension WPFindeCell1 {
    func makeSubviews() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        let currentImg = UIImage.wp.createColorImage(.white, size: CGSize(width: 12, height: 3)).wp.roundCorner(1.5)
        let pageImg = UIImage.wp.createColorImage(rgba(160, 160, 160), size: CGSize(width: 12, height: 3)).wp.roundCorner(1.5)
        
        cycleScrollView.currentPageDotImage = currentImg
        cycleScrollView.pageDotImage = pageImg
    
        cycleScrollView.imageURLStringsGroup = datas
      
    }
    
    func makeConstraints() -> Void {
        cycleScrollView.snp.makeConstraints { make in
            make.width.equalTo(WPScreenWidth)
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(115.0)
        }
    }
}
