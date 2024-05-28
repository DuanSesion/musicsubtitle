//
//  WPCourseHeadeInfoView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/7.
//

import UIKit

class WPCourseHeadeInfoView: UIView {


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
    
    lazy var userHeder: UIImageView = {
        var icon: UIImageView = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 9
        icon.clipsToBounds = true
        icon.backgroundColor = .gray
        addSubview(icon)
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        var nameLabel: UILabel = UILabel()
        nameLabel.text = "吴志强"
        nameLabel.textColor = rgba(51, 51, 51, 1)
        nameLabel.font = .systemFont(ofSize: 14)
        addSubview(nameLabel)
        return nameLabel
    }()
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(211, 211, 211, 1)
        addSubview(line)
        return line
    }()
    
    lazy var textLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "天府教育平台"
        textLabel.textColor = rgba(136, 136, 136, 1)
        textLabel.font = .systemFont(ofSize: 12)
        addSubview(textLabel)
        return textLabel
    }()
    
    lazy var lookLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "45.5万人观看"
        textLabel.textColor = rgba(168, 171, 181, 1)
        textLabel.font = .systemFont(ofSize: 11)
        addSubview(textLabel)
        return textLabel
    }()
    
    lazy var studyView: UIView = {
        var studyView: UIView = UIView()
        studyView.backgroundColor = rgba(245, 245, 245, 1)
        studyView.layer.cornerRadius = 22
        studyView.clipsToBounds = true
        studyView.isUserInteractionEnabled = true
        addSubview(studyView)
        return studyView
    }()
    
    lazy var button: UIButton = {
        var button: UIButton = .init()
        button.setTitle("0", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let colors = [rgba(254, 143, 11, 1).cgColor,rgba(255, 211, 54, 1).cgColor]
        let img = UIImage.wp.jianBianLeftToRight(colors: colors, size: CGSize(width: 34, height: 34))?.wp.roundCorner(17)
        button.setBackgroundImage(img, for: .normal)
        
        let colors1 = [rgba(211, 211, 211, 1).cgColor,rgba(211, 211, 211, 1).cgColor]
        let img1 = UIImage.wp.jianBianLeftToRight(colors: colors, size: CGSize(width: 34, height: 34))?.wp.roundCorner(17)
        button.setBackgroundImage(img1, for: .disabled)
        
        button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self,let lectureDuration = weakSelf.couserDetail?.lectureDuration else { return  }
            if (lectureDuration ) >= 1.0 {
                WPSearchModel.getLectureReceiveCredit(weakSelf.couserDetail?.lecture?.id) { response in
                    if response.jsonModel?.success == true {
                        weakSelf.finish = true
                        button.isEnabled = false
                        weakSelf.couserDetail?.lecture?.status = 1
                    }
                }
            }
  
        }).disposed(by: disposeBag)
        studyView.addSubview(button)
        return button
    }()
    
    lazy var lineX: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(211, 211, 211, 1)
        studyView.addSubview(line)
        return line
    }()
    
    lazy var finishStudyLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "已领取学分"
        textLabel.textColor = rgba(136, 136, 136, 1)
        textLabel.font = .systemFont(ofSize: 12)
        studyView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var studyProgressLabel: UILabel = {
        var textLabel: UILabel = UILabel()
        textLabel.text = "已学习 90%"
        textLabel.textColor = rgba(136, 136, 136, 1)
        textLabel.font = .systemFont(ofSize: 12)
        textLabel.adjustsFontSizeToFitWidth = true
        studyView.addSubview(textLabel)
        return textLabel
    }()
    
    lazy var progressView : UIProgressView = {
        var progressView : UIProgressView = UIProgressView()
        progressView.progressTintColor = rgba(254, 143, 11, 1)
        progressView.trackTintColor = rgba(222, 219, 219, 0.60)
        progressView.layer.cornerRadius = 3
        studyView.addSubview(progressView)
        return progressView
    }()
    
    var finish:Bool = false {
        didSet {
            if finish {
                finishStudyLabel.isHidden = false
                studyProgressLabel.isHidden = true
                progressView.isHidden = true
            } else {
                finishStudyLabel.isHidden = true
                studyProgressLabel.isHidden = false
                progressView.isHidden = false
            }
        }
    }
    
    var couserDetail:WPCouserDetailModel?{
        didSet {
            userHeder.sd_setImage(with: .init(string: couserDetail?.couser?.scholarAvatar ?? ""))
            let learnNums = couserDetail?.lecture?.learnNums ?? 0
            let learnNumsStr = (learnNums > 10000) ? "\(String(format: ".1f", CGFloat(learnNums)/100))w人观看" : "\(learnNums)人观看"
            button.setTitle("\(couserDetail?.lecture?.credit ?? 0)", for: .normal)
            textLabel.text = couserDetail?.lecture?.university ?? "-"
            lookLabel.text = learnNumsStr
            
            let duration:Float = Float(couserDetail?.duration ?? 0)
            let lectureDuration:Float = Float(couserDetail?.lectureDuration ?? 0)
            if lectureDuration == 0 {
                updateProgress(0.0)
            } else {
                updateProgress(CGFloat(duration/lectureDuration))
            }
            
            if self.couserDetail?.lecture?.status == 0 {
                button.isEnabled = false
                self.finish = false
                
            } else if self.couserDetail?.lecture?.status == 1 {
                button.isEnabled = true
                self.finish = false
                
            } else {
                button.isEnabled = false
                self.finish = true
            }
            
            if WPLanguage.chinessLanguage() {
                nameLabel.text  = couserDetail?.couser?.scholarName ?? (couserDetail?.couser?.universityName ?? "-")
              
            } else {
                nameLabel.text  = couserDetail?.couser?.scholarNameEn ?? (couserDetail?.couser?.universityNameEn ?? "-")
            }
        }
    }
}

extension WPCourseHeadeInfoView {
    func updateProgress(_ progress:CGFloat) -> Void {
         let pro = "\(Int(progress*100))"
         let text = "已学习\(pro)%"
         let atr = NSMutableAttributedString(string: text)
         atr.yy_font = .systemFont(ofSize: 12)
         atr.yy_color = rgba(136, 136, 136, 1)
         atr.yy_setColor(rgba(102, 102, 102, 1), range: .init(location: 3, length: pro.count))
         studyProgressLabel.attributedText = atr
        
         progressView.progress = Float(progress)
    }
}

extension WPCourseHeadeInfoView {
    func makeSubviews() {
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        finish = false
        updateProgress(0.0)
    }
    
    
    func makeConstraints() -> Void {
        userHeder.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(userHeder.snp.right).offset(2)
            make.centerY.equalTo(userHeder)
        }
        
        line.snp.makeConstraints { make in
            make.centerY.equalTo(userHeder)
            make.right.equalTo(nameLabel.snp.right).offset(10)
            make.width.equalTo(0.5)
            make.height.equalTo(9)
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(line.snp.right).offset(10)
            make.centerY.equalTo(userHeder)
        }
        
        lookLabel.snp.makeConstraints { make in
            make.left.equalTo(userHeder)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        
        studyView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 132+40, height: 44))
            make.right.equalToSuperview().offset(40)
            make.top.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.width.height.equalTo(34)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        }
        
        lineX.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(button.snp.right).offset(9)
            make.width.equalTo(0.5)
            make.height.equalTo(9)
        }
        
        finishStudyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-51)
        }
        
        studyProgressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-48)
            make.left.greaterThanOrEqualTo(lineX.snp.right)
        }
        
        progressView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 66, height: 6))
            make.left.equalTo(lineX.snp.right).offset(9)
            make.bottom.equalToSuperview().offset(-9)
        }
    }
}
