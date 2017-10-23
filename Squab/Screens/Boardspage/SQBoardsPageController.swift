//
//  SQBoardsPageController.swift
//  Squab
//
//  Created by Chandrachudh on 22/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQBoardsPageController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNotifications: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    @IBOutlet weak var btnReminders: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblNoItemsToShow: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
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
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0)
        myCollectionView.setCollectionViewLayout(layout, animated: false)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let recentItemsNib = UINib.init(nibName: SQRecentItemsCell.reuseIdentifier(), bundle: nil)
        myCollectionView.register(recentItemsNib, forCellWithReuseIdentifier: SQRecentItemsCell.reuseIdentifier())
        
        myCollectionView.reloadData()
    }
    
    //MARK: Target Methods
    
    @IBAction func didTapNotificationsButton(_ sender: Any) {
    }
    
    @IBAction func didTapMessagesButton(_ sender: Any) {
    }
    
    @IBAction func didTapRemindersButton(_ sender: Any) {
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        self.navigationController?.pushViewController(SQSearchPageController(), animated: true)
    }
}

extension SQBoardsPageController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SQRecentItemsCell.reuseIdentifier(), for: indexPath) as! SQRecentItemsCell
        cell.populateViewWith()
        return cell
    }
}
