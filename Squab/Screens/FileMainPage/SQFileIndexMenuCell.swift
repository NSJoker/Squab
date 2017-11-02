//
//  SQFileIndexMenuCell.swift
//  Squab
//
//  Created by Chandrachudh on 30/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQFileIndexMenuCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func reuseIdentifier()->String {
        return "SQFileIndexMenuCell"
    }
}
