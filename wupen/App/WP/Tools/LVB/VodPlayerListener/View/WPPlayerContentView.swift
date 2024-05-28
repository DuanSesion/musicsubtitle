//
//  WPPlayerContentView.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit
import AVKit
import MediaPlayer

extension WPPlayerContentView {
    public enum WPPlayerScreenState {
        case small
        case animating
        case fullScreen
    }

    public enum WPPlayerPlayState {
        case unknow
        case waiting
        case readyToPlay
        case playing
        case buffering
        case failed
        case pause
        case ended
    }

    public enum WPPanDirection {
        case unknow
        case horizontal
        case leftVertical
        case rightVertical
    }
}

//public class WPPlayerVolumView: MPVolumeView {
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//    
//    func setup() -> Void {
//         
//    }
//}

public class WPPlayerContentView: UIImageView {
    weak var delegate: WPPlayerContentViewDelegate?
    var rate:Float = 1
    var sessionVolumObserve :Any?
    
    deinit {
//        let session = AVAudioSession.sharedInstance()
//        session.removeObserver(self, forKeyPath: "outputVolume")
        debugPrint("WPPlayerContentView========>",self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        makeNotificationCenter()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        makeNotificationCenter()
    }
    
//    private lazy var placeholderStackView: UIStackView = {
//        let view = UIStackView()
//        view.isHidden = true
//        view.axis = .horizontal
//        view.distribution = .fill
//        view.alignment = .fill
//        view.insetsLayoutMarginsFromSafeArea = false
//        view.isLayoutMarginsRelativeArrangement = true
//        view.layoutMargins = .zero
//        view.spacing = 0
//        return view
//    }()
    
    private lazy var loadingView: WPRotateAnimationView = {
        let view = WPRotateAnimationView(frame: .init(x: 0, y: 0, width: 40, height: 40))
        view.startAnimation()
        return view
    }()
    
    private lazy var topToolView: WPColorAlphaView = {
        let view = WPColorAlphaView()
        view.colors = [rgba(0, 0, 0,0.5).cgColor,rgba(0, 0, 0,0.01).cgColor]
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var bottomToolView: WPColorAlphaView = {
        let view = WPColorAlphaView()
        view.colors = [rgba(255, 0, 0,0.01).cgColor,rgba(255, 0, 0,0.5).cgColor]
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var bottomContentView: WPColorAlphaView = {
        let view = WPColorAlphaView()
        view.colors =  [rgba(0, 0, 0,0.01).cgColor,rgba(0, 0, 0,0.5).cgColor]
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var backButton: UIButton = {//当前返回
        let view = UIButton()
        view.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var playButton: UIButton = {//当前播放键
        let view = UIButton()
        view.addTarget(self, action: #selector(playButtonAction(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var nextButton: UIButton = {//当前播放视频下一个
        let view = UIButton()
        view.isHidden = true
        view.addTarget(self, action: #selector(nextButtonAction(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var fullButton: UIButton = {//当前播放视频放大屏幕
        let view = UIButton()
        view.addTarget(self, action: #selector(fullButtonAction(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var languageButton: UIButton = {//当前播放视频切换语言字幕
        let view = UIButton()
        view.addTarget(self, action: #selector(languageButtonAction(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var moreButton: UIButton = {//查看更多
        let view = UIButton()
        view.isHidden = true
        view.addTarget(self, action: #selector(moreAction(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var changeRateButton: UIButton = {//播放率切换
        let view = UIButton()
        view.layer.cornerRadius = 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.font = .systemFont(ofSize: 12)
        view.addTarget(self, action: #selector(changeRateAction(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var currentDurationLabel: UILabel = {//当前播放视频进度时间
        let view = UILabel()
        view.text = "-:-"
        view.font = .monospacedDigitSystemFont(ofSize: 10, weight: .regular)
        view.textColor = .white
        view.textAlignment = .center
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()

    private lazy var totalDurationLabel: UILabel = {//当前播放视频总时长
        let view = UILabel()
        view.text = "-:-"
        view.font = .monospacedDigitSystemFont(ofSize: 10, weight: .regular)
        view.textColor = .white
        view.textAlignment = .center
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()
    
    private lazy var srtTextLabel: UILabel = {//当前播放视频字幕显示
        let view = UILabel()
        view.text = ""
        view.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        view.textColor = .white
        view.textAlignment = .center
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
        view.backgroundColor = rgba(0, 0, 0, 0.5)
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        view.isHidden = true // 默认不显示
        addSubview(view)
        return view
    }()
    
    private lazy var stateTextLabel: UILabel = {//当前播放视频加载状态
        let view = UILabel()
        view.text = "缓冲..."
        view.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        view.textColor = UIColor.init(red: 254/255.0, green: 143/255.0, blue: 11/255.0, alpha: 1)  
        view.textAlignment = .center
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
        view.isHidden = true
        addSubview(view)
        return view
    }()
    
    private lazy var videoTitletLabel: UILabel = {//当前播放视频标题
        let view = UILabel()
        view.text = ""
        view.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        view.textColor = .white
        view.textAlignment = .left
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.numberOfLines = 2
        view.adjustsFontSizeToFitWidth = true
        view.isHidden = true
        addSubview(view)
        return view
    }()
    
    private lazy var sliderView: WPSlider = {//当前播放视频进度条
        let view = WPSlider()
        view.minimumTrackTintColor = rgba(254, 176, 83, 1)
        view.maximumTrackTintColor = rgba(255, 255, 255, 1)
        view.setThumbImage(.init(named: "play_progress_dot_icon"), for: .normal)
        view.addTarget(self, action: #selector(progressSliderTouchBegan(_:)), for: .touchDown)
        view.addTarget(self, action: #selector(progressSliderValueChanged(_:)), for: .valueChanged)
        view.addTarget(self, action: #selector(progressSliderTouchEnded(_:)), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        addSubview(view)
        return view
    }()
    
    lazy var playRouteView: WPPlayRouteView = {//播放速率选择菜单
        let playRouteView:WPPlayRouteView = WPPlayRouteView()
        return playRouteView
    }()
    
    lazy var subtitleView: WPSubtitleView = {//播放选择语言
        let subtitleView:WPSubtitleView = WPSubtitleView()
        subtitleView.didisOnBlock = .some({[weak self] isOn in
            guard let weakSelf = self else {return }
            weakSelf.srtTextLabel.isHidden = !isOn
        })
        return subtitleView
    }()
    
    var screenState: WPPlayerScreenState = .small {
        didSet {
            guard screenState != oldValue else { return }
            switch screenState {
            case .small:
                break
            case .animating:
                break
            case .fullScreen:
                break
            }
        }
    }
    
    var playState: WPPlayerPlayState = .unknow {
        didSet {
            guard playState != oldValue else { return }
            switch playState {
            case .unknow:
//                sliderView.isUserInteractionEnabled = false
//                failButton.isHidden = true
//                playButton.isSelected = false
//                placeholderStackView.isHidden = placeholderView == nil
                loadingView.startAnimation()
                stateTextLabel.isHidden = false
                playButton.isSelected = false
                break
            case .waiting:
//                sliderView.isUserInteractionEnabled = false
//                failButton.isHidden = true
//                placeholderStackView.isHidden = true
                loadingView.startAnimation()
                stateTextLabel.isHidden = false
                playButton.isSelected = true
                break
            case .readyToPlay:
//                sliderView.isUserInteractionEnabled = true
                playButton.isSelected = true
                break
            case .playing:
//                sliderView.isUserInteractionEnabled = true
//                failButton.isHidden = true
//                playButton.isSelected = true
//                placeholderStackView.isHidden = true
                loadingView.stopAnimation()
                stateTextLabel.isHidden = true
                playButton.isSelected = true
                break
            case .buffering:
//                sliderView.isUserInteractionEnabled = true
//                failButton.isHidden = true
//                placeholderStackView.isHidden = true
                loadingView.startAnimation()
                stateTextLabel.isHidden = false
                playButton.isSelected = true
                
                break
            case .failed:
//                sliderView.isUserInteractionEnabled = false
//                failButton.isHidden = false
                loadingView.stopAnimation()
                stateTextLabel.isHidden = true
                playButton.isSelected = false
                
                break
            case .pause:
//                sliderView.isUserInteractionEnabled = true
                playButton.isSelected = false
                
                
                break
            case .ended:
//                sliderView.isUserInteractionEnabled = true
//                failButton.isHidden = true
//                playButton.isSelected = false
//                placeholderStackView.isHidden = placeholderView == nil
                
                loadingView.stopAnimation()
                totalDurationLabel.text = "-"
                currentDurationLabel.text = "-"
                srtTextLabel.text = ""
                stateTextLabel.isHidden = true
                playButton.isSelected = false
                loadingView.stopAnimation()
                break
            }
        }
    }
    
    var model:WPLectureVideosModel?{
        didSet {
            //self.sd_setImage(with: .init(string: model?.video?.coverImage ?? ""))
            self.videoTitletLabel.text = model?.video?.title
            defaultSRT()
        }
    }
    
    func defaultSRT() -> Void {
        guard let smodel = self.model, let lanKey = self.subtitleView.lanKey else { return  }
        if smodel.captionMapModel.values.count > 0 {
            getShowLectureLangMaps(smodel.captionMapModel) {[weak self] datas in
                guard let weakSelf = self  else { return  }
                for item in datas {
                    if item.key == lanKey {
                        weakSelf.downloadLanguageSRTFile(lang: item)
                        break
                    }
                }
            }
        }
    }
    
    private var isShowMorePanel: Bool = true {
        didSet {
            guard isShowMorePanel != oldValue else { return }
            var topToolH = 44.0
            if  screenState == .fullScreen {
                topToolH = 54
            }
            
            if isShowMorePanel {
                topToolView.snp.updateConstraints { make in
                    make.top.equalToSuperview()
                }
             
                bottomToolView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview()
                }
                
            } else {
                topToolView.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(-topToolH)
                }

                bottomToolView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(65)
                }
            }
            
            UIView.animate(withDuration: 0.25) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
}

extension WPPlayerContentView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first?.view == self {
            isShowMorePanel = !isShowMorePanel
        }
    }
}

extension WPPlayerContentView {
    func setup() -> Void {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        clipsToBounds = true
        autoresizesSubviews = true
        
        initSubViews()
        updateConfig()
    }
    
    func initSubViews() {
        addSubview(srtTextLabel)
        addSubview(topToolView)
        addSubview(bottomToolView)
        addSubview(loadingView)
        
        bottomToolView.addSubview(bottomContentView)
        
        bottomContentView.addSubview(fullButton)
        bottomContentView.addSubview(currentDurationLabel)
        bottomContentView.addSubview(totalDurationLabel)
        bottomContentView.addSubview(playButton)
        bottomContentView.addSubview(nextButton)
        bottomContentView.addSubview(sliderView)
        bottomContentView.addSubview(changeRateButton)
        
        topToolView.addSubview(languageButton)
        topToolView.addSubview(backButton)
        topToolView.addSubview(moreButton)
        
        
        
        backButton.isHidden = true
        makeConstraints()
    }
    
    func makeConstraints() {
        topToolView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.height.equalTo(44)
            make.top.equalToSuperview()
        }
        bottomToolView.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom)
        }
        loadingView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(40)
        }
        
        bottomContentView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(65)
        }
        
        srtTextLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.lessThanOrEqualToSuperview().offset(-32)
            make.bottom.equalTo(self).offset(-15)
        }
        
        stateTextLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(5)
        }
        
        languageButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(30)
            make.height.equalTo(44)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(-61)
            make.width.equalTo(30)
            make.height.equalTo(44)
        }
        
        
        videoTitletLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.lessThanOrEqualTo(languageButton.snp.left)
            make.left.equalTo(backButton.snp.right)
        }
        
        playButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.left.equalTo(playButton.snp.right).offset(5)
            make.centerY.equalTo(playButton)
        }
        
        fullButton.snp.makeConstraints { make in
            make.right.equalTo(bottomContentView).offset(-16)
            make.size.equalTo(20)
            make.centerY.equalTo(playButton)
        }
        
        changeRateButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-48)
            make.size.equalTo(CGSize(width: 30, height: 18))
            make.centerY.equalTo(playButton)
        }
        
        sliderView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(25)
            make.width.equalToSuperview().offset(-208)
        }
        
        currentDurationLabel.snp.makeConstraints { make in
            make.right.equalTo(sliderView.snp.left).offset(-3)
            make.centerY.equalTo(sliderView)
        }
        
        totalDurationLabel.snp.makeConstraints { make in
            make.left.equalTo(sliderView.snp.right).offset(3)
            make.centerY.equalTo(sliderView)
        
        }
    }
    
    func updateConfig() {
        fullButton.setImage(.init(named: "play_full_icon"), for: .normal)
        languageButton.setImage(.init(named: "play_change_language_icon"), for: .normal)
        
        let back:UIImage? = .init(named: "nav_back")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        backButton.setImage(back, for: .normal)
        
        moreButton.setImage(.init(named: "player_more_icon"), for: .normal)
        nextButton.setImage(.init(named: "player_next_icon"), for: .normal)
        
        playButton.setImage(.init(named: "play_pause_icon"), for: .selected)
        playButton.setImage(.init(named: "play_is_stop"), for: .normal)
        
        
        changeRateButton.setTitle("x\(self.rate)", for: .normal)
    }
}


extension WPPlayerContentView {
    func makeNotificationCenter() -> Void {//音量变化监听
        registerAudioSession()
    }
    
    func registerAudioSession() -> Void {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
            try session.overrideOutputAudioPort(.none)
            try session.setActive(true)
            
        } catch {
            print("Could not hide audio volume view: \(error)")
        }
    }
}


extension WPPlayerContentView {
    @objc func backButtonAction() {
         delegate?.didClickBackButton(in: self)
    }
 

    @objc func playButtonAction(_ button: UIButton) {
         delegate?.contentView(self, didClickPlayButton: !button.isSelected)
    }
    
    @objc func nextButtonAction(_ button: UIButton) {
        delegate?.didClickNextAction(in: self)
    }

    @objc func fullButtonAction(_ button: UIButton) {
         delegate?.contentView(self, didClickFullButton: button.isSelected)
         button.isSelected = !button.isSelected
        
    }
    
    @objc func progressSliderTouchBegan(_ slider: WPSlider) {
         delegate?.contentView(self, sliderTouchBegan: slider)
    }
    
    @objc func progressSliderValueChanged(_ slider: WPSlider) {
         delegate?.contentView(self, sliderValueChanged: slider)
    }
    
    @objc func progressSliderTouchEnded(_ slider: WPSlider) {
         delegate?.contentView(self, sliderTouchEnded: slider)
    }
    
    @objc func moreAction(_ button: UIButton) {
        delegate?.didClickMoreAction(in: self)
//        courseVideosView.show(screenState: self.screenState, videos: self.v)
    }
    
    @objc func changeRateAction(_ button: UIButton) {
        playRouteView.show(screenState: self.screenState)
        playRouteView.didSelectedBlock = .some({[weak self] rate in
            guard let weakSelf = self else { return  }
            weakSelf.delegate?.contentView(weakSelf, didChangeRate: rate)
            weakSelf.rate = rate
            
            if rate == 1.0 {
                button.setTitle("x1", for: .normal)
                
            } else if rate == 1.25 {
                button.setTitle("x1.25", for: .normal)
                
            } else if rate == 1.5 {
                button.setTitle("x1.5", for: .normal)
                
            } else if rate == 1.75 {
                button.setTitle("x1.75", for: .normal)
                
            } else if rate == 2.0 {
                button.setTitle("x2", for: .normal)
            }
        })
    }
    

    @objc func languageButtonAction(_ button: UIButton) {//切换字幕
        self.srtTextLabel.text = ""
        
        if let  model:WPLectureVideosModel = self.model {
            if model.captionMapModel.values.count > 0 {
                getLectureLangMap(model.captionMapModel)
                
            } else {
                self.showMessage("该视频无可选字幕")
            }
        }
    }
}

extension WPPlayerContentView {
    func getLectureLangMap(_ captionMapModels:[String:WPLectureVideosLanguageModel]) -> Void {
        getShowLectureLangMaps(captionMapModels) {[weak self] datas in
            guard let weakSelf = self  else { return  }
            if datas.count > 0 {
                weakSelf.subtitleView.show(screenState: weakSelf.screenState,datas: datas, isOn: !weakSelf.srtTextLabel.isHidden)
                weakSelf.subtitleView.didSelectedBlock = .some({[weak self]  lang in
                    guard let weakSelf = self else { return  }
                    weakSelf.downloadLanguageSRTFile(lang: lang)
                })
            }
        }
    }
    
    func getShowLectureLangMaps(_ captionMapModels:[String:WPLectureVideosLanguageModel],_ hanld:@escaping(_ datas:[WPLectureVideosLanguageModel])->Void) {
        WPLectureLangMap.getLectureLangMap {[weak self] datas in
            guard let weakSelf = self , datas.count > 0 else { return  }
            let lan = WPLanguage.chinessLanguage()
            var list:[WPLectureVideosLanguageModel] = []
            for (k,item) in captionMapModels {
                if let mo = datas[k] {
                    if lan {
                        item.title = mo.chineseName
                    } else {
                        item.title = mo.englishName
                    }
                    list.append(item)
                }
            }
            hanld(list)
        }
    }
    
    func downloadLanguageSRTFile(lang:WPLectureVideosLanguageModel) -> Void {
        WPDownLoadManager.downloadAssetBundle(lang.src) {[weak self] filePath in
            guard let weakSelf = self else { return  }
            if let filePath = filePath {
                weakSelf.delegate?.contentView(weakSelf, changeLanguage: filePath)
            }
        }
    }
}

extension WPPlayerContentView {
   public func animationLayout(safeAreaInsets: UIEdgeInsets, to screenState: WPPlayerScreenState) {
       self.screenState = screenState
       isShowMorePanel = true
       
       if  screenState == .fullScreen {
           self.fullButton.isHidden = true
           self.backButton.isHidden = false
           videoTitletLabel.isHidden = false
           moreButton.isHidden = false
           nextButton.isHidden = false
           srtTextLabel.backgroundColor = rgba(0, 0, 0, 0.8)
           
           topToolView.snp.updateConstraints { make in
               make.height.equalTo(54)
           }
           
           backButton.snp.updateConstraints { make in
               make.top.equalToSuperview().offset(10)
           }
           
           playButton.snp.updateConstraints { make in
               make.left.equalToSuperview().offset(46)
           }
           
           sliderView.snp.updateConstraints { make in
               make.width.equalToSuperview().offset(-240)
           }
           
           languageButton.snp.updateConstraints { make in
               make.right.equalToSuperview().offset(-105)
           }
           
           changeRateButton.snp.updateConstraints { make in
               make.right.equalToSuperview().offset(-81)
           }
           
           sliderView.snp.updateConstraints { make in
               make.top.equalToSuperview().offset(5)
               make.width.equalToSuperview().offset(-264)
               make.centerX.equalToSuperview().offset(0)
           }
           
           srtTextLabel.snp.updateConstraints { make in
               make.bottom.equalTo(self).offset(-15)
           }
           
       } else if  screenState == .small {
           self.fullButton.isHidden = false
           self.backButton.isHidden = true
           videoTitletLabel.isHidden = true
           moreButton.isHidden = true
           nextButton.isHidden = true
           srtTextLabel.backgroundColor = rgba(0, 0, 0, 0.8)
           
           topToolView.snp.updateConstraints { make in
               make.height.equalTo(44.0)
           }
           
           backButton.snp.updateConstraints { make in
               make.top.equalToSuperview().offset(0)
           }
           
           playButton.snp.updateConstraints { make in
               make.left.equalToSuperview().offset(16)
           }
           
           sliderView.snp.updateConstraints { make in
               make.width.equalToSuperview().offset(-96)
           }
           
           languageButton.snp.updateConstraints { make in
               make.right.equalToSuperview().offset(-16)
           }
           
           changeRateButton.snp.updateConstraints { make in
               make.right.equalToSuperview().offset(-48)
           }
           
           sliderView.snp.updateConstraints { make in
               make.top.equalToSuperview().offset(25)
               make.width.equalToSuperview().offset(-208)
               make.centerX.equalToSuperview().offset(-20)
           }
           
           srtTextLabel.snp.updateConstraints { make in
               make.bottom.equalTo(self).offset(-15)
           }
           
       } else if  screenState == .animating {
           
       }
       
       
//        bottomSafeView.snp.updateConstraints { make in
//            make.height.equalTo(safeAreaInsets.bottom)
//        }
//        backButton.snp.updateConstraints { make in
//            make.left.equalTo(screenState == .small ? -40 : safeAreaInsets.left + 10)
//        }
//        titleLabel.snp.updateConstraints { make in
//            make.left.equalTo(backButton.snp.right).offset(screenState == .small ? 15 : 10)
//            make.right.equalTo(moreButton.snp.left).offset(screenState == .small ? -15 : -10)
//        }
//        moreButton.snp.updateConstraints { make in
//            make.right.equalTo(screenState == .small ? 40 : -safeAreaInsets.left - 10)
//        }
//        playButton.snp.updateConstraints { make in
//            make.left.equalTo(safeAreaInsets.left + 10)
//        }
//        fullButton.snp.updateConstraints { make in
//            make.right.equalTo(-safeAreaInsets.right - 10)
//        }
//
//        fullButton.isSelected = screenState == .fullScreen
//
//        topToolView.isHidden = screenState == .small ? config.topBarHiddenStyle != .never : config.topBarHiddenStyle == .always
    }

    func setProgress(_ progress: Float, animated: Bool) {
//        progressView.setProgress(min(max(0, progress), 1), animated: animated)
    }

    func setSliderProgress(_ progress: Float, animated: Bool) {
        sliderView.setValue(min(max(0, progress), 1), animated: animated)
    }


}

 
extension WPPlayerContentView {
    func setTotalDuration(_ totalDuration: TimeInterval) {
        let time = Int(totalDuration)//ceil()
        let hours = time / 3600
        let minutes = time / 60
        let seconds = time % 60
        totalDurationLabel.text = hours == .zero ? String(format: "%02ld:%02ld", minutes, seconds) : String(format: "%02ld:%02ld:%02ld", hours, minutes, seconds)
    }

    func setCurrentDuration(_ currentDuration: TimeInterval) {
        let time = Int(currentDuration)//ceil()
        let hours = time / 3600
        let minutes = time / 60
        let seconds = time % 60
        currentDurationLabel.text = hours == .zero ? String(format: "%02ld:%02ld", minutes, seconds) : String(format: "%02ld:%02ld:%02ld", hours, minutes, seconds)
    }
    
    func setCurrentSrtText(_ currentSrtText: String?) {//字幕
        srtTextLabel.text = currentSrtText
    }
    
    func resetTextViews() -> Void {
        totalDurationLabel.text = "-:-"
        totalDurationLabel.text = "-:-"
        srtTextLabel.text = ""
    }
}
