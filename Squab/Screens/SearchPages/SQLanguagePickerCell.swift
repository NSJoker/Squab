//
//  SQLanguagePickerCell.swift
//  Squab
//
//  Created by Chandrachudh on 26/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

protocol SQLanguagePickerCellDelegate:class {
    func didSelectLanguage(at index:Int)
}

class SQLanguagePickerCell: UITableViewCell {

    @IBOutlet weak var selectionBaseView: UIView!
    @IBOutlet weak var selectionBGView: UIView!
    @IBOutlet weak var selectionIndicatorView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var isCurrentlySelected = false
    var index:Int?
    
    weak var delegate:SQLanguagePickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func reuseIdentifer() -> String {
        return "SQLanguagePickerCell"
    }
    
    func populateView(isSelected:Bool, title:String) {
        
        isCurrentlySelected = isSelected
        
        selectionBGView.layer.cornerRadius = selectionBGView.frame.width/2
        selectionIndicatorView.layer.cornerRadius = selectionIndicatorView.frame.width/2
        
        if isSelected {
            selectionIndicatorView.backgroundColor = UIColor.rgb(fromHex: 0x1ABC9C)
        }
        else {
            selectionIndicatorView.backgroundColor = UIColor.white
        }
        self.lblTitle.text = title
    }
    
    //MARK: Target Methods
    @IBAction func didTapLanguageSelectbutton(_ sender: Any) {
        populateView(isSelected: !isCurrentlySelected, title: self.lblTitle.text ?? "")
        delegate?.didSelectLanguage(at: index ?? -1)
    }
}
