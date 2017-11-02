//
//  SQFileIndexMenu.swift
//  Squab
//
//  Created by Chandrachudh on 30/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

protocol SQFileIndexMenuDelegate:class {
    func showFileIndexAt(index:Int)
}

class SQFileIndexMenu: UIView {
    
    let dismissControl = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lcBaseViewWidth: NSLayoutConstraint!
    @IBOutlet weak var lcbaseViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    var dataSource = [SQFileIndexIndexMap]()
    
    weak var delegate:SQFileIndexMenuDelegate?
    
    func prepareView(title:String, allIndexPaths:[SQFileIndexIndexMap]) {
        
        dataSource = allIndexPaths
        
        lblTitle.text = title
        
        if dismissControl.superview == nil {
            dismissControl.addTarget(self, action: #selector(dismissmenu), for: .touchUpInside)
            dismissControl.backgroundColor = UIColor.rgba(fromHex: 0x000000, alpha: 0.4)
            addSubview(dismissControl)
            bringSubview(toFront: baseView)
        }
        
        lcBaseViewWidth.constant = SCREEN_WIDTH*2/3
        layoutIfNeeded()
        
        let nib = UINib.init(nibName: SQFileIndexMenuCell.reuseIdentifier(), bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: SQFileIndexMenuCell.reuseIdentifier())
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.tableFooterView = UIView()
        myTableView.reloadData()
    }

    func animateAndShow() {
        
        lcbaseViewLeadingSpace.constant = -1 * (SCREEN_WIDTH*2/3)
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.lcbaseViewLeadingSpace.constant = 0
            self.layoutIfNeeded()
        }) { (finished) in
        }
    }
    
    func animateAndHide() {
        lcbaseViewLeadingSpace.constant = 0
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.lcbaseViewLeadingSpace.constant = -1 * (SCREEN_WIDTH*2/3)
            self.layoutIfNeeded()
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    //MARK:Target Methods
    func dismissmenu() {
        animateAndHide()
    }
}

extension SQFileIndexMenu:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQFileIndexMenuCell.reuseIdentifier(), for: indexPath) as! SQFileIndexMenuCell
        cell.lblTitle.text = String(dataSource[indexPath.row].value?.uiid ?? 0) + ".  " + (dataSource[indexPath.row].value?.title?.base64DecodedString() ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.showFileIndexAt(index: indexPath.row)
        animateAndHide()
    }
}
