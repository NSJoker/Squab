//
//  SQFileMainPageDetailsView.swift
//  Squab
//
//  Created by Chandrachudh on 30/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit
import WebKit

protocol SQFileMainPageDetailsViewDelegate:class {
    func showItemWith(referenceItem:SQMainPageReferenceIconsList)
}

class SQFileMainPageDetailsView: UIView {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var lcMyCollectionViewHeight: NSLayoutConstraint!
    
    weak var delegate:SQFileMainPageDetailsViewDelegate?
    
    var selectedSearchResult:SQSearchResults?
    var fileIndexMaps:SQFileIndexIndexMap?
    var selectedLaguageKey = ""
    
    var mainDetailsResponse:SQMainPageModel?
    
    func getDataFromServer() {
        guard let selectedSearchResult = selectedSearchResult else {
            return
        }
        
        guard let idStr = fileIndexMaps?.value?.internalIdentifier else {
            return
        }
        
        setupUI()
        self.webView.scrollView.showsVerticalScrollIndicator = false
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        self.webView.scrollView.bounces = false
        
        selectedSearchResult.getDetailsUsingID(idStr: idStr, language:selectedLaguageKey) { (response, errorMessage) in
            if let errorMessage = errorMessage {
                self.webView.isHidden = true
                self.myCollectionView.isHidden = true
                self.lblErrorMessage.isHidden = false
                self.lblErrorMessage.text = "Unable to load details.\n" + errorMessage
            }
            else {
                self.webView.isHidden = false
                self.myCollectionView.isHidden = false
                self.lblErrorMessage.isHidden = true
                
                self.mainDetailsResponse = response as? SQMainPageModel
                self.loadWebViewWithHTMLString(htmlString: (self.mainDetailsResponse?.description) ?? "")
                
                if self.mainDetailsResponse?.referenceIconsList?.count == 0 {
                    self.lcMyCollectionViewHeight.constant = 0
                    self.layoutIfNeeded()
                }
                else {
                    self.myCollectionView.reloadData()
                }
            }
        }
    }
    
    func loadWebViewWithHTMLString(htmlString:String) {
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        
    }

    func setupUI() {
        mySwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        mySwitch.layer.cornerRadius = mySwitch.frame.height/2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        myCollectionView.setCollectionViewLayout(layout, animated: false)
        
        let nib = UINib.init(nibName: SQMainPageReferenceIconsCell.reuseIdentifier(), bundle: nil)
        myCollectionView.register(nib, forCellWithReuseIdentifier: SQMainPageReferenceIconsCell.reuseIdentifier())
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.reloadData()
    }
    
    @IBAction func didChangeSwitch(_ sender: Any) {
        print("Switch Changed = ",String(mySwitch.isOn))
    }
}

extension SQFileMainPageDetailsView:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainDetailsResponse?.referenceIconsList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SQMainPageReferenceIconsCell.reuseIdentifier(), for: indexPath) as! SQMainPageReferenceIconsCell
        cell.prepareView(byteData: (mainDetailsResponse?.referenceIconsList![indexPath.row])?.byteData ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedReferenceIcon = mainDetailsResponse?.referenceIconsList![indexPath.row]
        delegate?.showItemWith(referenceItem: selectedReferenceIcon!)
    }
}
