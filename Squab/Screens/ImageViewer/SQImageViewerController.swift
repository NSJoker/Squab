//
//  SQImageViewerController.swift
//  Squab
//
//  Created by Chandrachudh on 06/11/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQImageViewerController: UIViewController {
    
    var referenceItem:SQMainPageReferenceIconsList?
    var selectedSearchResult:SQSearchResults?
    var selectedLaguageKey = ""

    @IBOutlet weak var lcImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lcImageViewHeight.constant = SCREEN_WIDTH
        view.layoutIfNeeded()
        
        myImageView.image = nil
                
        guard let selectedSearchResult = selectedSearchResult else {
            showErrorHud(position: .top, message: "Unable to show the image.", bgColor: .red, isPermanent: false)
            return
        }
        
        referenceItem?.getFile(searchResult: selectedSearchResult, language:selectedLaguageKey, returnBlock: { (responseObj, errorMessage) in
            if let errorMessage = errorMessage {
                self.showErrorHud(position: .top, message: errorMessage, bgColor: .red, isPermanent: false)
            }
            else {
                let base64String = responseObj as! String
                self.myImageView.image = SquabBase64ConvertionHelper.sharedInstance.getImageFromBase64EncodedString(base64String: base64String)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Target Methods
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
