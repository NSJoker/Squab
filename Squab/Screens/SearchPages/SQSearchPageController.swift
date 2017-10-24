//
//  SQSearchPageController.swift
//  Squab
//
//  Created by Chandrachudh on 23/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQSearchPageController: UIViewController {

    @IBOutlet weak var lcCollectionViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    
    var searchResults = [SQSearchResults]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if IS_DEVELOPMENT_MODE {//Connect to production server
            SquabDataCenter.sharedInstance.domain = "http://squab.avartaka.com:9083/"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if IS_DEVELOPMENT_MODE {//Reconnect to development server
            SquabDataCenter.sharedInstance.domain = "http://squab.avartaka.com:8083/"
        }
        
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupCollectionView() {
        let gap:CGFloat = 10
        let itemSize:CGFloat = 80
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: itemSize)
        layout.minimumLineSpacing = gap
        layout.minimumInteritemSpacing = gap
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0)
        myCollectionView.setCollectionViewLayout(layout, animated: false)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let recentItemsNib = UINib.init(nibName: SQSearchResultCell.reuseIdentifier(), bundle: nil)
        myCollectionView.register(recentItemsNib, forCellWithReuseIdentifier: SQSearchResultCell.reuseIdentifier())
        
        myCollectionView.animateAndReload()
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        
        if SCREEN_HEIGHT < 600 {
            let endFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            if endFrame.origin.y == SCREEN_HEIGHT {//Keyboard dissed
                lcCollectionViewBottomSpace.constant = 0.0
            }
            else {
                lcCollectionViewBottomSpace.constant = endFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    func searchWith(searchText:String) {
        if searchText.characters.count == 0 {
            //remove all items in collectionview's datasource and reload collectionview
            searchResults.removeAll()
            myCollectionView.animateAndReload()
        }
        else {
            //hit the api with search request
            if SquabUserManager.sharedInstance.getSavedMobileNumber().characters.count == 0 {
                showAlertAndLogout(buttonTitle: "OK", message: "Unable find the logged in user details. Please login again")
            }
            else {
                SQSearchResults.searchFor(searchText: searchText, returnBlock: { (response, errorMessage) in
                    
                    if let errorMessage = errorMessage {
                        self.showErrorHud(position: .top, message: errorMessage, bgColor: .red, isPermanent: false)
                    }
                    else {
                        self.searchResults = response as! [SQSearchResults]
                        self.myCollectionView.animateAndReload()
                    }
                })
            }
        }
    }
}

extension SQSearchPageController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = textField.text
        let newString = (currentString! as NSString).replacingCharacters(in: range, with: string)
        
        searchWith(searchText: newString)
        return true
    }
}

extension SQSearchPageController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SQSearchResultCell.reuseIdentifier(), for: indexPath) as! SQSearchResultCell
        cell.populateViewWith(searchResult: searchResults[indexPath.row])
        return cell
    }
}
