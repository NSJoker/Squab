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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func reuseIdentifier()->String {
        return "SQSearchResultCell"
    }
    
    func populateViewWith() {
        
        imgThumbnail.addShadowWith(shadowPath: UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: 80, height: 80)).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5, shadowRadius: 1.0, shadowOffset: CGSize.zero)
        
        baseView.layer.cornerRadius = 4.0
        
        baseView.addShadowWith(shadowPath: UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-30, height: 78), cornerRadius: 4.0).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5, shadowRadius: 1.0, shadowOffset: CGSize.zero)
    }

}
