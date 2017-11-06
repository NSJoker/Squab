//
//  SQMainPageReferenceIconsCell.swift
//  Squab
//
//  Created by Chandrachudh on 06/11/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQMainPageReferenceIconsCell: UICollectionViewCell {

    @IBOutlet weak var imgReferenceIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func reuseIdentifier()->String {
        return "SQMainPageReferenceIconsCell"
    }
    
    func prepareView(byteData:String) {
        
        print("byteData = ",byteData)
        
        imgReferenceIcon.image = SquabBase64ConvertionHelper.sharedInstance.getImageFromBase64EncodedString(base64String:byteData)
    }

}
