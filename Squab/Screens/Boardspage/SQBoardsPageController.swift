//
//  SQBoardsPageController.swift
//  Squab
//
//  Created by Chandrachudh on 22/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQBoardsPageController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNotifications: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    @IBOutlet weak var btnReminders: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblNoItemsToShow: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var btnCancelWiggle: UIButton!
    @IBOutlet weak var navBarButtonBaseView: UIView!
    
    var allRecentItems = [SQRecentFile]()
    
    var wiggle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        setupCollectionView()
    }
    
    func showreminder() {
        let datePicker:SQReminderDatePickerView = Bundle.main.loadNibNamed("SQReminderDatePickerView", owner: self, options: nil)![0] as! SQReminderDatePickerView
//        datePicker.delegate = self
        datePicker.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        UIApplication.shared.keyWindow?.addSubview(datePicker)
        datePicker.animateAndShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataAndReload()
    }
    
    func getDataAndReload() {
        allRecentItems = SquabRecentItemsManager.sharedInstance.getAllSavedItems()
        if allRecentItems.count == 0 {
            wiggle = false
            switchWiggleOff()
            lblNoItemsToShow.isHidden = false
            myCollectionView.isHidden = true
        }
        else {
            lblNoItemsToShow.isHidden = true
            myCollectionView.isHidden = false
        }
        myCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func getRecentItemSize()->(CGFloat, CGFloat) {
        var gap:CGFloat = 15.0
        let itemsInOneRow:CGFloat = 3
        var itemSize = ((SCREEN_WIDTH-20) - (CGFloat(itemsInOneRow-1)*gap))/itemsInOneRow
        if SCREEN_HEIGHT < 600 {
            gap = 10.0
            itemSize = ((SCREEN_WIDTH-20) - (CGFloat(itemsInOneRow-1)*gap))/itemsInOneRow
        }
        else if SCREEN_HEIGHT < 670 {
            gap = 10.0
            itemSize = ((SCREEN_WIDTH-20) - (CGFloat(itemsInOneRow-1)*gap))/itemsInOneRow
        }
        return (itemSize, gap)
    }
    
    func setupCollectionView() {
        
        let itemSize = SQBoardsPageController.getRecentItemSize().0
        let gap = SQBoardsPageController.getRecentItemSize().1
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize+50)
        layout.minimumLineSpacing = gap
        layout.minimumInteritemSpacing = gap
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10)
        myCollectionView.setCollectionViewLayout(layout, animated: false)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let recentItemsNib = UINib.init(nibName: SQRecentItemsCell.reuseIdentifier(), bundle: nil)
        myCollectionView.register(recentItemsNib, forCellWithReuseIdentifier: SQRecentItemsCell.reuseIdentifier())
        
        myCollectionView.animateAndReload()
    }
    
    func longpressed(gesture: UILongPressGestureRecognizer) {
        wiggle = true
        myCollectionView.reloadData()
        navBarButtonBaseView.isHidden = true
        btnCancelWiggle.isHidden = false
    }
    
    func switchWiggleOff() {
        navBarButtonBaseView.isHidden = false
        btnCancelWiggle.isHidden = true
    }
    
    //MARK: Target Methods
    
    @IBAction func didTapNotificationsButton(_ sender: Any) {
        showErrorHud(position: .top, message: "This feature is not implemented", bgColor: .red, isPermanent: false)
    }
    
    @IBAction func didTapMessagesButton(_ sender: Any) {
        showErrorHud(position: .top, message: "This feature is not implemented", bgColor: .red, isPermanent: false)
    }
    
    @IBAction func didTapRemindersButton(_ sender: Any) {
        navigationController?.pushViewController(SQRemindersController(), animated: true)
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        self.navigationController?.pushViewController(SQSearchPageController(), animated: true)
    }
    
    @IBAction func didTapCancelWiggleButton(_ sender: Any) {
        wiggle = false
        myCollectionView.reloadData()
        switchWiggleOff()
    }
}

extension SQBoardsPageController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allRecentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SQRecentItemsCell.reuseIdentifier(), for: indexPath) as! SQRecentItemsCell
        cell.populateViewWith(recentItem: allRecentItems[indexPath.row])
        
        if(cell.longPressGestureRecognizer == nil){
            cell.longPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(longpressed))
            cell.longPressGestureRecognizer?.delegate = self
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(cell.longPressGestureRecognizer!)
        }
        
        if wiggle {
            cell.wigglewiggle()
            cell.imgCross.isHidden = false
        }
        else {
            cell.imgCross.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentFile = allRecentItems[indexPath.row]
        if wiggle {
            SquabRecentItemsManager.sharedInstance.removeFile(fileToRemove: recentFile)
            getDataAndReload()
        }
        else {
            openFileWithLanguage(language: recentFile.language!, selectedSearchResult: recentFile.searchResult!)
        }
    }
}
