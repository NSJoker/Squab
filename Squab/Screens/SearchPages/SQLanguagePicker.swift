//
//  SQLanguagePicker.swift
//  Squab
//
//  Created by Chandrachudh on 25/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

protocol SQLanguagePickerDelegate:class {
    func openFileWithLanguage(languageMap:SQLangListMap)
}

class SQLanguagePicker: UIView {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var myyTableView: UITableView!
    
    @IBOutlet weak var lcBaseViewHeight: NSLayoutConstraint!
    
    weak var delegate:SQLanguagePickerDelegate?
    
    
    var dataSource:SQLanguages?
    let dismissControl = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    
    var currentlySelectedIndex:Int = 0
    
    func prepareView(languages:SQLanguages) {
        dataSource = languages
        baseView.layer.cornerRadius = 4.0
        
        let height = min(CGFloat(300), (CGFloat(languages.langListMap?.count ?? 0) * 50) + 90)
        lcBaseViewHeight.constant = height
        layoutIfNeeded()
        
        if dismissControl.superview == nil {
            addSubview(dismissControl)
            dismissControl.addTarget(self, action: #selector(didTapDismissControl), for: .touchUpInside)
            dismissControl.backgroundColor = UIColor.rgba(fromHex: 0x000000, alpha: 0.4)
            bringSubview(toFront: baseView)
            
            let nib = UINib.init(nibName: SQLanguagePickerCell.reuseIdentifer(), bundle: nil)
            myyTableView.register(nib, forCellReuseIdentifier: SQLanguagePickerCell.reuseIdentifer())
            
            myyTableView.tableFooterView = UIView()
            
            myyTableView.delegate = self
            myyTableView.dataSource = self
            
            myyTableView.reloadData()
        }
        
    }
    
    //MARK:Target Methods
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        delegate?.openFileWithLanguage(languageMap: (dataSource?.langListMap![currentlySelectedIndex])!)
        animateAndHide()
    }
    
    @IBAction func didtapCancelButton(_ sender: Any) {
        animateAndHide()
    }
    
    func didTapDismissControl() {
        animateAndHide()
    }
}

extension SQLanguagePicker {
    func animateAndShow() {
        alpha = 0.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }) { (finished) in
        }
    }
    
    func animateAndHide() {
        alpha = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}

extension SQLanguagePicker :UITableViewDelegate, UITableViewDataSource, SQLanguagePickerCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.langListMap?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQLanguagePickerCell.reuseIdentifer(), for: indexPath) as! SQLanguagePickerCell
        cell.delegate = self
        cell.index = indexPath.row
        
        let title = dataSource?.langListMap?[indexPath.row].value
        
        
        if currentlySelectedIndex == indexPath.row {
            cell.populateView(isSelected: true, title: title ?? "")
        }
        else {
            cell.populateView(isSelected: false, title: title ?? "")
        }
        return cell
    }
    
    func didSelectLanguage(at index: Int) {
        currentlySelectedIndex = index
        myyTableView.reloadData()
    }
}
