//
//  AnimationHelper.swift
//  SJCoinsVendingMachine
//
//  Created by Oleg Pankiv on 11/15/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class AnimationHelper {
    
    // MARK: Motion effect.
    func applyMotionEffect(toView view: UIView, magnitude: Float) {
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }

    //MARK: Transparency effect.
    func showHidden(_ element: UIView, delay: TimeInterval) {
        
        UIView.animate(withDuration: 0.5, delay: delay, options: .showHideTransitionViews, animations: { () -> Void in
            element.alpha = 1
        }, completion: nil)
    }
    
    //MARK: Scaling effect.
    func show(_ logo: UIImageView) {
        
        UIView.animate(withDuration: 0.6 ,
                       animations: { logo.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) }) { finish in
                        UIView.animate(withDuration: 0.6) { logo.transform = CGAffineTransform.identity }
        }
    }
}
