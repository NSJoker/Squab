//
//  UIImageViewExtension.swift
//  Squab
//
//  Created by Chandrachudh on 20/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

enum ImageStyle:Int {
    case squared
    case rounded
    case none
}

extension UIImageView {
    
    func SQ_SetImage(imageUrl:String, placeholder:UIImage, imageStyle:ImageStyle, shouldShowLoader:Bool, shouldAnimate:Bool) {
        image = placeholder
        
        if imageUrl.characters.count == 0 {
            return
        }
        
        switch imageStyle {
        case .rounded:
            layer.cornerRadius = bounds.height
            break
        case .squared:
            layer.cornerRadius = 0
            break
        default:
            break
        }
        
        clipsToBounds = true
        
        setShowActivityIndicator(shouldShowLoader)
        setIndicatorStyle(.gray)
        
        if SQ_isImageCached(urlString: imageUrl) {
            sd_setImage(with: NSURL.init(string: imageUrl) as URL!)
            if shouldAnimate {
                animateImageView()
            }
        }
        else {
            self.sd_setImage(with: NSURL.init(string: imageUrl) as URL!, placeholderImage:placeholder, options: [.avoidAutoSetImage,.highPriority,.retryFailed,.delayPlaceholder], completed: { (image, error, cacheType, url) in
                if error == nil {
                    DispatchQueue.main.async {
                        self.image = image
                        if shouldAnimate {
                            self.animateImageView()
                        }
                    }
                }
            })
        }
    }
    
    func SQ_isImageCached(urlString:String)->Bool {
        if SDWebImageManager.shared().cachedImageExists(for: NSURL.init(string: urlString) as URL!) {
            return true
        }
        return false
    }
    
    func animateImageView() {
        alpha = 0;
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1
        }, completion: { (finished) in
        })
    }
    
}
