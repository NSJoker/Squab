//
//  SquabProgressIndicator.swift
//  Squab
//
//  Created by Chandrachudh on 20/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

private var progressIndicatorCount:Int = 0
private let progressBGView = UIView()
private let progressView = UIView()
private let progressViewSize:CGFloat = 100.0
private let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x:progressViewSize/4, y:progressViewSize/4, width:progressViewSize/2, height:progressViewSize/2), type: .ballTrianglePath, color: UIColor.rgb(fromHex: 0x434343), padding: 5.0)

class SquabProgressIndicator: UIView {

    class var sharedInstance: SquabProgressIndicator {
        struct Static {
            static let instance: SquabProgressIndicator = SquabProgressIndicator()
        }
        return Static.instance
    }
    
    func show(with message:String) {
        progressIndicatorCount += 1
        
        if progressIndicatorCount < 1 {
            progressIndicatorCount = 1
        }
        else if progressIndicatorCount > 1 {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        progressBGView.frame = (UIApplication.shared.keyWindow?.bounds)!
        progressBGView.backgroundColor = UIColor.rgba(fromHex: 0x000000, alpha: 0.3)
        UIApplication.shared.keyWindow?.addSubview(progressBGView)
        
        if progressView.superview == nil {
            SquabProgressIndicator.sharedInstance.addProgressView()
        }
        loadingIndicator.startAnimating()
        
        progressBGView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            progressBGView.alpha = 1.0
        }) { (finished) in
        }
    }
    
    fileprivate func addProgressView() {
        
        progressView.backgroundColor = UIColor.white
        progressView.frame = CGRect(x: (SCREEN_WIDTH-progressViewSize)/2, y: (SCREEN_HEIGHT-progressViewSize)/2, width: progressViewSize, height: progressViewSize)
        progressView.layer.cornerRadius = 4.0
        progressBGView.addShadowWith(shadowPath: UIBezierPath.init(roundedRect: progressBGView.bounds, cornerRadius: progressBGView.layer.cornerRadius).cgPath, shadowColor: UIColor.rgb(fromHex: 0xFFFFFF).cgColor, shadowOpacity: 1.0, shadowRadius: 2.0, shadowOffset: CGSize.zero)
        
        progressView.addSubview(loadingIndicator)
        progressBGView.addSubview(progressView)
    }
    
    func hide() {
        progressIndicatorCount -= 1
        
        if progressIndicatorCount > 0 {
            return
        }
        progressIndicatorCount = 0
        if progressBGView.superview == nil {
            return
        }
        
        progressBGView.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            progressBGView.alpha = 0.0
        }) { (finished) in
            loadingIndicator.stopAnimating()
            progressBGView.removeFromSuperview()
            progressBGView.alpha = 1.0
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

}
