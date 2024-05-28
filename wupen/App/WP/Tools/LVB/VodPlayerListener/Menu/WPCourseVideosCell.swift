//
//  WPCourseVideosCell.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/5/14.
//

import UIKit

class WPCourseVideosCell: UITableViewCell {
    private var video:WPLectureVideosModel?
    public var didPlayBlock:((_ video:WPLectureVideosModel)->Void)?

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

    lazy var checkButton: UIButton = {
        var checkButton: UIButton = UIButton()
        checkButton.isUserInteractionEnabled = true
        checkButton.setImage(.init(named: "payer_v_play_icon"), for: .selected)
        checkButton.setImage(.init(named: "payer_v_pause_icon"), for: .normal)
        checkButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] recognizer in
            guard let weakSelf = self else { return  }
            checkButton.isSelected = !checkButton.isSelected
            if checkButton.isSelected {
                weakSelf.video?.player?.play()
                
                let current:Double = weakSelf.video?.player?.currentItem?.currentTime().seconds ?? 0
                WPUmeng.um_event_course_Click_PlayPause(true,current:current)
                
            } else {
                weakSelf.video?.player?.pause()
                
                let current:Double = weakSelf.video?.player?.currentItem?.currentTime().seconds ?? 0
                WPUmeng.um_event_course_Click_PlayPause(false,current:current)
            }
            
            if let video = weakSelf.video {
                weakSelf.didPlayBlock?(video)
            }
        }).disposed(by: disposeBag)
        contentView.addSubview(checkButton)
        return checkButton
    }()
    
    lazy var label: UILabel = {//标题
        let view = UILabel()
        view.text = "x"
        view.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        view.textColor = rgba(255, 255, 255, 1)
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = false
        contentView.addSubview(view)
        return view
    }()
    
    lazy var stateLabel: UILabel = {//标题
        let view = UILabel()
        view.text = ""
        view.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        view.textColor = rgba(254, 143, 11, 1)
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.numberOfLines = 1
        view.adjustsFontSizeToFitWidth = false
        contentView.addSubview(view)
        return view
    }()
    
    lazy var line: UIView = {
        var line: UIView = UIView()
        line.backgroundColor = rgba(211, 211, 211, 1)
        contentView.addSubview(line)
        return line
    }()
    
    lazy var stateButton: UIButton = {
        var stateButton: UIButton = UIButton()
        stateButton.isUserInteractionEnabled = false
        stateButton.setImage(.init(named: "play_time_icon"), for: .normal)
        stateButton.setTitleColor(rgba(255, 255, 255, 0.80), for: .normal)
        stateButton.titleLabel?.font = .systemFont(ofSize: 12)
        contentView.addSubview(stateButton)
        return stateButton
    }()
    
    func setSub(video:WPLectureVideosModel, curretVideo:WPLectureVideosModel?,
                didPlayBlock:((_ video:WPLectureVideosModel)->Void)?,
                _ screenState: WPPlayerContentView.WPPlayerScreenState = .small) -> Void {
        self.video = video
        self.didPlayBlock = didPlayBlock
        
        label.text = video.video?.title
        checkButton.isSelected = false
        stateLabel.text = ""
        line.isHidden = true
        stateButton.setTitle(video.video?.duration.durationStr(), for: .normal)
        stateButton.jk.setImageTitleLayout(.imgLeft, spacing: 3)
        stateButton.snp.remakeConstraints { make in
            make.left.equalTo(label)
            make.top.equalTo(label.snp.bottom).offset(6)
        }
        
        if screenState == .small {
            label.textColor = rgba(51, 51, 51)
            label.numberOfLines = 2
            checkButton.setImage(.init(named: "play_h_play_icon"), for: .selected)
            checkButton.setImage(.init(named: "play_h_pause_icon"), for: .normal)
            stateButton.setTitleColor(rgba(168, 171, 181, 1), for: .normal)
            
        } else {
            label.textColor = .white
            label.numberOfLines = 1
            checkButton.setImage(.init(named: "payer_v_play_icon"), for: .selected)
            checkButton.setImage(.init(named: "payer_v_pause_icon"), for: .normal)
            stateButton.setTitleColor(rgba(255, 255, 255, 0.80), for: .normal)
        }
        
        if curretVideo?.video?.id == video.video?.id {
            label.textColor = rgba(254, 143, 11, 1)
            
            stateLabel.text = (screenState == .fullScreen) ? "正在播放" : ""
            checkButton.isSelected = true
            line.isHidden = (screenState == .fullScreen) ? false : true
            
            if screenState == .fullScreen {
                stateButton.snp.remakeConstraints { make in
                    make.left.equalTo(line.snp.right).offset(4)
                    make.top.equalTo(label.snp.bottom).offset(6)
                }
            }

            if video.player?.status == .readyToPlay {
                checkButton.isSelected = true
            }
        }
    }
}

extension WPCourseVideosCell {
    func makeSubviews () {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        label.font = .systemFont(ofSize: 14)
        self.selectionStyle = .none
    }
    
    func makeConstraints () {
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(25)
        }
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.lessThanOrEqualTo(checkButton.snp.left).offset(-35)
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(6)
            make.left.equalTo(label)
        }
        line.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.height.equalTo(8.5)
            make.left.equalTo(stateLabel.snp.right).offset(8)
            make.top.equalTo(label.snp.bottom).offset(11)
        }
        stateButton.snp.makeConstraints { make in
            make.left.equalTo(line.snp.right).offset(4)
            make.top.equalTo(label.snp.bottom).offset(6)
        }
    }
}
