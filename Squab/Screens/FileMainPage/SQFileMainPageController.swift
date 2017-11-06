//
//  SQFileMainPageController.swift
//  Squab
//
//  Created by Chandrachudh on 30/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit
import MXSegmentedPager

class SQFileMainPageController: UIViewController {

    @IBOutlet weak var customNavigationbar: UIView!
    @IBOutlet weak var lblTitleLabel: UILabel!
    @IBOutlet weak var segmentedPager: MXSegmentedPager!
    
    
    
    var selectedSearchResult:SQSearchResults?
    var fileIndexMaps = [SQFileIndexIndexMap]()
    var selectedIndexmap:Int = 0
    var selectedLaguageKey = ""
    
    let menu:SQFileIndexMenu = Bundle.main.loadNibNamed("SQFileIndexMenu", owner: self, options: nil)![0] as! SQFileIndexMenu
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitleLabel.text = selectedSearchResult?.title ?? ""
        
        segmentedPager.delegate = self
        segmentedPager.dataSource = self
        segmentedPager.bounces = false
        segmentedPager.segmentedControlPosition = .top
        segmentedPager.pager.bounces = false
        segmentedPager.reloadData()
        segmentedPager.segmentedControl.selectionIndicatorColor = UIColor.rgb(fromHex: 0x1ABC9C)
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        
        menu.prepareView(title: selectedSearchResult?.title ?? "", allIndexPaths: fileIndexMaps)
        menu.delegate = self
        
        showFileIndexAt(index: selectedIndexmap)
        
        segmentedPager.segmentedControl.selectedSegmentIndex = selectedIndexmap
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:Target Methods
    
    @IBAction func showAllindexesMenu(_ sender: Any) {
        menu.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        UIApplication.shared.keyWindow?.addSubview(menu)
        menu.animateAndShow()
    }
    
    @IBAction func didtapClosebutton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SQFileMainPageController: MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, MXPageProtocol {
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return fileIndexMaps.count
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        let detailsView:SQFileMainPageDetailsView = Bundle.main.loadNibNamed("SQFileMainPageDetailsView", owner: self, options: nil)![0] as! SQFileMainPageDetailsView
        detailsView.selectedSearchResult = self.selectedSearchResult
        detailsView.fileIndexMaps = fileIndexMaps[index]
        detailsView.selectedLaguageKey = selectedLaguageKey
        detailsView.delegate = self
        detailsView.getDataFromServer()
        return detailsView
    }
    
    func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 50
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, attributedTitleForSectionAt index: Int) -> NSAttributedString {
        
        let title = fileIndexMaps[index].value?.title?.base64DecodedString() ?? ""
        
        let attrStr = NSMutableAttributedString.init(string: title)
        attrStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium), range: NSRange.init(location: 0, length: title.characters.count))
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.rgb(fromHex: 0x434343), range: NSRange.init(location: 0, length: title.characters.count))
        
        return attrStr
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, shouldScrollWith view: UIView) -> Bool {
        return true
    }
}

extension SQFileMainPageController:SQFileIndexMenuDelegate {
    func showFileIndexAt(index: Int) {
        selectedIndexmap = index
        segmentedPager.pager.showPage(at: index, animated: false)
        segmentedPager.segmentedControl.selectedSegmentIndex = index
    }
}

extension SQFileMainPageController:SQFileMainPageDetailsViewDelegate {
    func showItemWith(referenceItem: SQMainPageReferenceIconsList) {
        
        if referenceItem.format == nil || referenceItem.format?.characters.count == 0 {
            //It is an image
            
            let imageViewerController = SQImageViewerController()
            imageViewerController.referenceItem = referenceItem
            imageViewerController.selectedSearchResult = selectedSearchResult
            imageViewerController.selectedLaguageKey = selectedLaguageKey
            self.navigationController?.pushViewController(imageViewerController, animated: true)
        }
        else {
            guard let format = referenceItem.format else {
                return
            }
            
            print("format = ",format)
            
            switch format {
            case "mp4" :
                guard let selectedSearchResult = selectedSearchResult else {
                    showErrorHud(position: .top, message: "Unable to play the video.", bgColor: .red, isPermanent: false)
                    return
                }
                self.playVideo(referenceItem: referenceItem, selectedSearchResult: selectedSearchResult, selectedLaguageKey: selectedLaguageKey)
                break
            case "txt":
                self.openFileInWebView(referenceItem: referenceItem, selectedSearchResult: selectedSearchResult, selectedLaguageKey: selectedLaguageKey)
                break
            case "pdf":
                self.openFileInWebView(referenceItem: referenceItem, selectedSearchResult: selectedSearchResult, selectedLaguageKey: selectedLaguageKey)
                break
            default:
                break
            }
        }
    }
}
