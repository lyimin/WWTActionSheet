//
//  WWTActionSheetTransition.swift
//  WWTita
//
//  Created by EamonLiang on 2019/7/17.
//  Copyright © 2019 wewave Inc. All rights reserved.
//

import UIKit
import Foundation


enum WWTActionSheetTransitonMode {
    case present
    case dismiss
}

class WWTActionSheetTransiton: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    fileprivate var mode: WWTActionSheetTransitonMode = .present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.24
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if mode == .present {
            
            let toVC = transitionContext.viewController(forKey: .to) as! WWTActionSheetController
            let fromVC = transitionContext.viewController(forKey: .from)
            let containerView = transitionContext.containerView
            containerView.insertSubview(toVC.view, aboveSubview: fromVC!.view)
            
            toVC.coverView.alpha = 0
            
            let contentViewH = UIScreen.main.bounds.height - toVC.contentView.frame.origin.y
            toVC.contentView.transform = CGAffineTransform(translationX: 0, y: contentViewH)
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                toVC.coverView.alpha = 1
                toVC.contentView.transform = .identity
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        else if mode == .dismiss {
            let fromVC = transitionContext.viewController(forKey: .from) as! WWTActionSheetController
            let toVC = transitionContext.viewController(forKey: .to)
            let containerView = transitionContext.containerView
            containerView.insertSubview(fromVC.view, aboveSubview: toVC!.view)
            
            let contentViewX = fromVC.contentView.frame.origin.x
            let contentViewH = fromVC.contentView.frame.height
            let contentViewW = fromVC.contentView.frame.width
            let screenH = UIScreen.main.bounds.height
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                fromVC.coverView.alpha = 0
                fromVC.contentView.frame = CGRect(x: contentViewX, y: screenH, width: contentViewW, height: contentViewH)
                
            }) { (finished) in transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        mode = .present
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        mode = .dismiss
        return self
    }
}
