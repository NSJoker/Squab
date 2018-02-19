//
//  SQReminderCell.swift
//  Squab
//
//  Created by Chandrachudh on 19/02/18.
//  Copyright © 2018 NSJoker. All rights reserved.
//

import UIKit

class SQReminderCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imgRecentItem: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblReminderDate: UILabel!
    
    var myDataSourceObject:SQReminder?
    
    class func reuseIdentifier()->String {
        return "SQReminderCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func populateViewWith(reminder:SQReminder) {
        myDataSourceObject = reminder
        baseView.layer.cornerRadius = 4.0
//        baseView.addShadowWith(shadowPath: UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-30, height: 78), cornerRadius: 4.0).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5, shadowRadius: 3.0, shadowOffset: CGSize(width: 2, height: 2))

        let itemSize:CGFloat = 80
//        imgRecentItem.addShadowWith(shadowPath: UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: itemSize, height: itemSize)).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.2, shadowRadius: 5.0, shadowOffset: CGSize(width: 2, height: 0))

        imgRecentItem.image = nil
        if let iconString = myDataSourceObject?.reminderSearchResult?.icon {
            imgRecentItem.image = SquabBase64ConvertionHelper.sharedInstance.getImageFromBase64EncodedString(base64String:iconString)
        }
        lblFileName.text = myDataSourceObject?.reminderSearchResult?.title ?? ""
        
        let reminderDate = myDataSourceObject?.reminderDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        lblReminderDate.text = dateFormatter.string(from: reminderDate!)
    }
}
