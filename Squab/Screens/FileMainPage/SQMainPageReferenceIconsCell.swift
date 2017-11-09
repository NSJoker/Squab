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
    
    @IBOutlet weak var lblFormat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func reuseIdentifier()->String {
        return "SQMainPageReferenceIconsCell"
    }
    
    func prepareView(byteData:String, format:String?) {
        lblFormat.isHidden = true
        if let format = format {
            lblFormat.isHidden = false
            lblFormat.text = format
            imgReferenceIcon.image = #imageLiteral(resourceName: "ic_attachment")
        }
        else {
            imgReferenceIcon.image = SquabBase64ConvertionHelper.sharedInstance.getImageFromBase64EncodedString(base64String:byteData)
        }
    }
}
