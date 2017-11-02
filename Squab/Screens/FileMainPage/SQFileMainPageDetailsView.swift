//
//  SQFileMainPageDetailsView.swift
//  Squab
//
//  Created by Chandrachudh on 30/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit
import WebKit

class SQFileMainPageDetailsView: UIView {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var selectedSearchResult:SQSearchResults?
    var fileIndexMaps:SQFileIndexIndexMap?
    var selectedLaguageKey = ""
    
    func getDataFromServer() {
        guard let selectedSearchResult = selectedSearchResult else {
            return
        }
        
        guard let idStr = fileIndexMaps?.value?.internalIdentifier else {
            return
        }
        
        selectedSearchResult.getDetailsUsingID(idStr: idStr, language:selectedLaguageKey) { (response, errorMessage) in
            if let errorMessage = errorMessage {
                
            }
            else {
                
            }
        }
    }
    
    func loadWebViewWithHTMLString(htmlString:String) {
        
    }

    func setupCollectionViewWith() {
        
    }
}
