//
//  SQRecentItemsCell.swift
//  Squab
//
//  Created by Chandrachudh on 23/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQRecentItemsCell: UICollectionViewCell {

    @IBOutlet weak var imgRecentItem: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUploadedBy: UILabel!
    @IBOutlet weak var imgCross: UIImageView!
    @IBOutlet weak var imgUpdate: UIImageView!
    
    var longPressGestureRecognizer:UILongPressGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func reuseIdentifier()->String {
        return "SQRecentItemsCell"
    }
    
    func populateViewWith(recentItem:SQRecentFile) {
        let itemSize = SQBoardsPageController.getRecentItemSize().0
        imgRecentItem.addShadowWith(shadowPath: UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: itemSize-22, height: itemSize-22)).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.2, shadowRadius: 10.0, shadowOffset: CGSize.zero)
        
        imgRecentItem.image = nil
        if let iconString = recentItem.searchResult?.icon {
            imgRecentItem.image = SquabBase64ConvertionHelper.sharedInstance.getImageFromBase64EncodedString(base64String:iconString)
        }
        lblTitle.text = recentItem.searchResult?.title ?? ""
        lblUploadedBy.text = recentItem.searchResult?.username ?? "-"
        imgCross.layer.cornerRadius = 10.0
        imgCross.clipsToBounds = true
        imgUpdate.layer.cornerRadius = 10.0
        imgUpdate.clipsToBounds = true
        
        imgUpdate.isHidden = true
        if recentItem.hasUnSeenUpdate {
            imgUpdate.isHidden = false
        }
    }
    
    func wigglewiggle(){
        let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.05, 0.0, 0.0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(-0.05 , 0, 0, 1))]
        transformAnim.autoreverses = true
        transformAnim.duration  = 0.15//0.115
        transformAnim.repeatCount = Float.infinity
        self.layer.add(transformAnim, forKey: "transform")
    }
}
