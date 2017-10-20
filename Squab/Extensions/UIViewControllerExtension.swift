//
//  UIViewControllerExtension.swift
//  Squab
//
//  Created by Chandrachudh on 20/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

enum HudPosition {
    case top,bottom
}

enum HudBgColor {
    case red,blue
}

extension UIViewController {
    func showAlertWith(buttonTitle:String, message:String, shouldPopCurrentVC:Bool) {
        if message.characters.count == 0 {
            return
        }
        
        let alertController = UIAlertController.init(title: APP_NAME, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true) {
            if shouldPopCurrentVC {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
func showErrorHud(position: HudPosition, message:String, bgColor: HudBgColor, isPermanent:Bool) {
        
        DispatchQueue.main.async {
            let messageView:MessageView? = MessageView.viewFromNib(layout: .MessageView)
            messageView?.configureContent(title: message, body: "", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
            
            switch bgColor {
            case .red:
                messageView?.configureTheme(backgroundColor:UIAppThemeUIErrorRed, foregroundColor: UIColor.white, iconImage: nil, iconText: "")
                break
            default:
                messageView?.configureTheme(backgroundColor: UIAppThemeHudSuccessBlue, foregroundColor: UIColor.white, iconImage: nil, iconText: "")
                break
            }
            
            messageView?.bodyLabel?.isHidden = true
            messageView?.titleLabel?.textAlignment = .center
            messageView?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            messageView?.button?.isHidden = true
            messageView?.iconImageView?.isHidden = true
            messageView?.iconLabel?.isHidden = true
            
            var config = SwiftMessages.defaultConfig
            config.duration = .seconds(seconds: 2)
            if isPermanent == true {
                config.duration = .forever
            }
            config.dimMode = .none
            config.interactiveHide = true
            config.preferredStatusBarStyle = .lightContent
            
            if position == .bottom {
                config.presentationStyle = .bottom
            }
            else {
                config.presentationStyle = .top
            }
            
            SwiftMessages.show(config: config, view: (messageView)!)
        }
    }
}
