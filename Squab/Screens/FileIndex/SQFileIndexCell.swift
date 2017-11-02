//
//  SQFileIndexCell.swift
//  Squab
//
//  Created by Chandrachudh on 30/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQFileIndexCell: UITableViewCell {

    @IBOutlet weak var lblIndexNumber: UILabel!
    @IBOutlet weak var lblIndexTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func reuseidentifier()->String {
        return "SQFileIndexCell"
    }
    
    func prepareView(indexMap:SQFileIndexIndexMap) {
        lblIndexNumber.text = String(Int(indexMap.value?.uiid ?? 0))
        lblIndexTitle.text = indexMap.value?.title?.base64DecodedString()
    }
}
