//
//  SQSearchResultCell.swift
//  Squab
//
//  Created by Chandrachudh on 23/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQSearchResultCell: UICollectionViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPublishedBy: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    var myDataSourceObject:SQSearchResults?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func reuseIdentifier()->String {
        return "SQSearchResultCell"
    }
    
    func populateViewWith(searchResult:SQSearchResults) {
        myDataSourceObject = searchResult
        baseView.layer.cornerRadius = 4.0
        baseView.addShadowWith(shadowPath: UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-30, height: 78), cornerRadius: 4.0).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5, shadowRadius: 3.0, shadowOffset: CGSize(width: 2, height: 2))
        
        let itemSize:CGFloat = 80
        imgThumbnail.addShadowWith(shadowPath: UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: itemSize, height: itemSize)).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.2, shadowRadius: 5.0, shadowOffset: CGSize(width: 2, height: 0))
        
        imgThumbnail.image = nil
        if let iconString = myDataSourceObject?.icon {
            imgThumbnail.image = SquabBase64ConvertionHelper.sharedInstance.getImageFromBase64EncodedString(base64String:iconString)
        }
        lblTitle.text = myDataSourceObject?.title ?? ""
        lblPublishedBy.text = myDataSourceObject?.username ?? "-"
    }
}
