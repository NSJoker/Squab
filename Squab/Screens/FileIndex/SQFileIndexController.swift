//
//  SQFileIndexController.swift
//  Squab
//
//  Created by Chandrachudh on 30/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQFileIndexController: UIViewController {
    
    var fileIndexes:SQFileIndexModel?
    var selectedSearchResult:SQSearchResults?
    var fileIndexMap = [SQFileIndexIndexMap]()
    var selectedLaguageKey = ""
    
    @IBOutlet weak var lblFileTitle: UILabel!
    @IBOutlet weak var customNavbar: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgThumbNail: UIImageView!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lbFileCategory: UILabel!
    @IBOutlet weak var indexTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortFileIndexesToDataSource()
        
        lblFileTitle.text = selectedSearchResult?.title ?? ""
        lbFileCategory.text = selectedSearchResult?.category ?? "-"
        lblCreatedBy.text = selectedSearchResult?.username ?? "-"
        
        let itemSize:CGFloat = 60
        imgThumbNail.addShadowWith(shadowPath: UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: itemSize, height: itemSize)).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.2, shadowRadius: 5.0, shadowOffset: CGSize(width: 2, height: 0))
        
        imgThumbNail.image = nil
        if let iconString = selectedSearchResult?.icon {
            imgThumbNail.image = SquabBase64ConvertionHelper.sharedInstance.getImageFromBase64EncodedString(base64String:iconString)
        }
        
        let nib = UINib.init(nibName: SQFileIndexCell.reuseidentifier(), bundle: nil)
        indexTableView.register(nib, forCellReuseIdentifier: SQFileIndexCell.reuseidentifier())
        
        indexTableView.delegate = self
        indexTableView.dataSource = self
        
        indexTableView.tableFooterView = UIView()
        
        indexTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sortFileIndexesToDataSource() {
        fileIndexMap.removeAll()
        
        fileIndexMap = fileIndexes?.indexMap?.sorted(by: sorterForFileIDASC) ?? []
        
        
        fileIndexMap.forEach { (indexMap) in
            print("Index uiid = ",indexMap.value?.uiid ?? 0)
        }
    }
    
    func sorterForFileIDASC(this:SQFileIndexIndexMap, that:SQFileIndexIndexMap) -> Bool {
        guard let thisValue = this.value?.uiid else {
            return false
        }
        
        guard let thatValue = that.value?.uiid else {
            return false
        }
        
        return thisValue > thatValue
    }
    
    func openFileMainPageControllerWith(page:Int) {
        let fileMainPageController = SQFileMainPageController()
        fileMainPageController.selectedSearchResult = selectedSearchResult
        fileMainPageController.fileIndexMaps = fileIndexMap
        fileMainPageController.selectedIndexmap = page
        fileMainPageController.selectedLaguageKey = selectedLaguageKey
        
        self.navigationController?.viewControllers = [fileMainPageController]
    }
    
    //MARK:Target Methods
    
    @IBAction func dismissPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapReadButton(_ sender: Any) {
        openFileMainPageControllerWith(page: 0)
    }
    
    
    
}

extension SQFileIndexController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileIndexMap.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SQFileIndexCell.reuseidentifier(), for: indexPath) as! SQFileIndexCell
        cell.prepareView(indexMap: fileIndexMap[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openFileMainPageControllerWith(page: indexPath.row)
    }
}
