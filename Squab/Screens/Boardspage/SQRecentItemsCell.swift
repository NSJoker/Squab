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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func reuseIdentifier()->String {
        return "SQRecentItemsCell"
    }
    
    func populateViewWith(recentItem:SQRecentFile) {
        let itemSize = SQBoardsPageController.getRecentItemSize().0
        imgRecentItem.addShadowWith(shadowPath: UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: itemSize-2, height: itemSize-2)).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5, shadowRadius: 1.0, shadowOffset: CGSize.zero)
        
        imgRecentItem.image = nil
        if let iconString = recentItem.searchResult?.icon {
            imgRecentItem.image = SquabBase64ConvertionHelper.sharedInstance.getImageFromBase64EncodedString(base64String:iconString)
        }
        lblTitle.text = recentItem.searchResult?.title ?? ""
        lblUploadedBy.text = recentItem.searchResult?.username ?? "-"
    }
}
