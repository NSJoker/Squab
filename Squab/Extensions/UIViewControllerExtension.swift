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
import AVFoundation
import AVKit

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
    
    func showAlertAndLogout(buttonTitle:String, message:String) {
        if message.characters.count == 0 {
            return
        }
        
        let alertController = UIAlertController.init(title: APP_NAME, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: buttonTitle, style: .destructive) { (action) in
            self.navigationController?.viewControllers = [SQLandingPageController()]
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
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
            if SCREEN_HEIGHT < 600 {
                messageView?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            }
            else if SCREEN_HEIGHT < 670 {
                messageView?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            }
            messageView?.titleLabel?.numberOfLines = 0
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
    
    func playVideo(referenceItem:SQMainPageReferenceIconsList, selectedSearchResult:SQSearchResults, selectedLaguageKey:String) {
        referenceItem.getFile(searchResult: selectedSearchResult, language:selectedLaguageKey, returnBlock: { (responseObj, errorMessage) in
            if let errorMessage = errorMessage {
                self.showErrorHud(position: .top, message: errorMessage, bgColor: .red, isPermanent: false)
            }
            else {
                let base64String = responseObj as! String
                
                let videoData = Data.init(base64Encoded: base64String, options: .ignoreUnknownCharacters)
                let videoURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(referenceItem.fileName ?? "mymoview.mp4")
                
                do {
                    try videoData?.write(to: videoURL, options: .atomic)
                    
                    let player = AVPlayer(url: videoURL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player?.play()
                    }
                } catch {
                    self.showErrorHud(position: .top, message: "Unable to play video: " + error.localizedDescription, bgColor: .red, isPermanent: false)
                    return
                }
            }
        })
    }
    
    func openFileInWebView(referenceItem:SQMainPageReferenceIconsList, selectedSearchResult:SQSearchResults?, selectedLaguageKey:String) {
        
        guard let selectedSearchResult = selectedSearchResult else {
            showErrorHud(position: .top, message: "Unable to open file.", bgColor: .red, isPermanent: false)
            return
        }
        
        
        
        referenceItem.getFile(searchResult: selectedSearchResult, language:selectedLaguageKey, returnBlock: { (responseObj, errorMessage) in
            
            if let errorMessage = errorMessage {
                self.showErrorHud(position: .top, message: errorMessage, bgColor: .red, isPermanent: false)
            }
            else {
                
                DispatchQueue.main.async {
                    let base64String = responseObj as! String
                    
                    let fileData = Data.init(base64Encoded: base64String, options: .ignoreUnknownCharacters)
                    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(referenceItem.fileName ?? ("myfile." + referenceItem.format!))
                    
                    do {
                        try fileData?.write(to: fileURL, options: .atomic)
                        
                        DispatchQueue.main.async {
                            let webViewController = SQWebViewController()
                            webViewController.lblTitle.text = referenceItem.fileName ?? ""
                            webViewController.loadWebViewWith(url: fileURL)
                            self.navigationController?.pushViewController(webViewController, animated: true)
                        }
                    } catch {
                        self.showErrorHud(position: .top, message: "Unable to play video: " + error.localizedDescription, bgColor: .red, isPermanent: false)
                        return
                    }
                }
            }
        })
        
    }
}
