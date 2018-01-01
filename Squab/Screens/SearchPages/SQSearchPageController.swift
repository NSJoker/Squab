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
    @IBOutlet weak var lblNoITems: UILabel!
    @IBOutlet weak var ImgSearch: UIImageView!
    
    var selectedSearchResult:SQSearchResults?
    
    
    var searchResults = [SQSearchResults]()
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        
        setupCollectionView()
        
        txtSearch.becomeFirstResponder()
        
        ImgSearch.image = #imageLiteral(resourceName: "ic_search").withRenderingMode(.alwaysTemplate)
        ImgSearch.tintColor = UIColor.rgb(fromHex: 0x434343)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    func searchWith() {
        let searchText = txtSearch.text!
        
        if searchText.characters.count == 0 {
            //remove all items in collectionview's datasource and reload collectionview
            searchResults.removeAll()
            myCollectionView.animateAndReload()
            lblNoITems.isHidden = true
            myCollectionView.isHidden = false
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
                        self.lblNoITems.isHidden = false
                        self.myCollectionView.isHidden = true
                    }
                    else {
                        self.searchResults = response as! [SQSearchResults]
                        self.myCollectionView.animateAndReload()
                        self.lblNoITems.isHidden = true
                        self.myCollectionView.isHidden = false
                    }
                })
            }
        }
    }
    
    //MARK:Target Methods
    @IBAction func didTapBackButton(_ sender: Any) {
        view.endEditing(true)
        timer?.invalidate()
        _ = navigationController?.popViewController(animated: true)
    }
}

extension SQSearchPageController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0 , target: self, selector: #selector(self.searchWith), userInfo: nil, repeats: false)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        view.endEditing(true)
        selectedSearchResult = searchResults[indexPath.row]
        self.selectedSearchResult?.getDetailsOfFile { (response, errorMessage) in
            if let errorMessage = errorMessage {
                self.showErrorHud(position: .top, message: errorMessage, bgColor: .red, isPermanent: false)
            }
            else {
                
                let languages = response as! SQLanguages
                
                if let count = languages.langListMap?.count {
                    if count > 1 {
                        let languagePicker:SQLanguagePicker = Bundle.main.loadNibNamed("SQLanguagePicker", owner: self, options: nil)![0] as! SQLanguagePicker
                        languagePicker.delegate = self
                        languagePicker.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                        UIApplication.shared.keyWindow?.addSubview(languagePicker)
                        languagePicker.prepareView(languages: languages)
                        languagePicker.animateAndShow()
                    }
                    else if count == 1 {
                        self.openFileWithLanguage(languageMap: languages.langListMap![0])
                    }
                    else {
                        self.openFileWithLanguage(language: "En", selectedSearchResult: self.selectedSearchResult!)
//                        self.showAlertWith(buttonTitle: "OK", message: "Unable to open file, because no language was found!", shouldPopCurrentVC: NO)
                    }
                }
                else {
                    self.showAlertWith(buttonTitle: "OK", message: "Unable to open file, because no language was found!", shouldPopCurrentVC: NO)
                }
            }
        }
    }
}

extension SQSearchPageController:SQLanguagePickerDelegate {
    func openFileWithLanguage(languageMap: SQLangListMap) {
        self.openFileWithLanguage(language: languageMap.key ?? "En", selectedSearchResult: self.selectedSearchResult!)
    }
}
