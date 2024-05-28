//
//  WPAnimationTransitioning.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit

extension WPAnimationTransitioning {
    enum WPAnimationType {
        case present
        case dismiss
    }

    enum WPAnimationOrientation {
        case left
        case right
        case fullRight
    }
}

class WPAnimationTransitioning: NSObject {
    private weak var player: WPPlayerView?
    private weak var parentView: UIStackView?
    private var centerInParent: CGPoint = .zero
    private var originSize: CGSize = .zero
    private var orientation: WPAnimationOrientation = .left
    var animationType: WPAnimationType = .present
    

    private let keyWindow: UIWindow? = {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.last
        } else {
            return UIApplication.shared.keyWindow
        }
    }()
    
    init(playView: WPPlayerView, orientation: WPAnimationOrientation) {
        player = playView
        self.orientation = orientation
        parentView = playView.superview as? UIStackView
        centerInParent = playView.center
        originSize = playView.frame.size
    }
}


extension WPAnimationTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let playView = player else { return }
        if animationType == .present {
            guard let toView = transitionContext.view(forKey: .to) else { return }
            guard let fromController = transitionContext.viewController(forKey: .from) else { return }

            let fromCenter = transitionContext.containerView.convert(playView.center, from: playView.superview)
            let fromSize = transitionContext.containerView.convert(playView.frame, from: nil).size

            transitionContext.containerView.addSubview(toView)
            toView.addSubview(playView)
            toView.backgroundColor = .black

            if orientation == .left,
               !(fromController.shouldAutorotate && fromController.supportedInterfaceOrientations.contains(.landscapeLeft))
            {
                toView.transform = .init(rotationAngle: -Double.pi * 0.5)
            } else if orientation == .right,
                      !(fromController.shouldAutorotate && fromController.supportedInterfaceOrientations.contains(.landscapeRight))
            {
                toView.transform = .init(rotationAngle: Double.pi * 0.5)
            } else if orientation == .fullRight {
                toView.transform = .init(rotationAngle: -Double.pi * 0.5)
            }

            toView.snp.remakeConstraints { make in
                make.center.equalTo(fromCenter)
                make.size.equalTo(fromSize)
            }
            playView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            transitionContext.containerView.setNeedsLayout()
            transitionContext.containerView.layoutIfNeeded()

            toView.snp.updateConstraints { make in
                make.center.equalTo(transitionContext.containerView.center)
                make.size.equalTo(transitionContext.containerView.bounds.size)
            }
            
            playView.contentView.animationLayout(safeAreaInsets: keyWindow?.safeAreaInsets ?? .zero, to: .fullScreen)
            
//            if #available(iOS 11.0, *) {
//                playView.contentView.animationLayout(safeAreaInsets: keyWindow?.safeAreaInsets ?? .zero, to: .fullScreen)
//            } else {
//                playView.contentView.animationLayout(safeAreaInsets: .zero, to: .fullScreen)
//            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews, animations: {
                toView.transform = .identity
                transitionContext.containerView.setNeedsLayout()
                transitionContext.containerView.layoutIfNeeded()
                playView.contentView.setNeedsLayout()
                playView.contentView.layoutIfNeeded()
            }) { _ in
                toView.transform = .identity
                transitionContext.completeTransition(true)
                UIViewController.attemptRotationToDeviceOrientation()
            }
        } else {
            guard let parentView = parentView else { return }
            guard let fromView = transitionContext.view(forKey: .from) else { return }
            guard let toView = transitionContext.view(forKey: .to) else { return }

            toView.frame = transitionContext.containerView.bounds
            toView.backgroundColor = .black

            let fromCenter = CGPoint(x: toView.frame.width * 0.5, y: toView.frame.height * 0.5)
            let fromSize = transitionContext.containerView.convert(playView.frame, from: nil).size

            transitionContext.containerView.addSubview(toView)
            transitionContext.containerView.addSubview(fromView)
            fromView.addSubview(playView)

            fromView.snp.remakeConstraints { make in
                make.center.equalTo(fromCenter)
                make.size.equalTo(fromSize)
            }
            playView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            transitionContext.containerView.setNeedsLayout()
            transitionContext.containerView.layoutIfNeeded()

            let center = transitionContext.containerView.convert(centerInParent, from: parentView)
            fromView.snp.updateConstraints { make in
                make.center.equalTo(center)
                make.size.equalTo(originSize)
            }

            playView.contentView.animationLayout(safeAreaInsets: .zero, to: .small)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .layoutSubviews, animations: {
                fromView.transform = .identity
                transitionContext.containerView.setNeedsLayout()
                transitionContext.containerView.layoutIfNeeded()
                playView.contentView.setNeedsLayout()
                playView.contentView.layoutIfNeeded()
            }) { _ in
                fromView.transform = .identity
                parentView.addArrangedSubview(playView)
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }
}
