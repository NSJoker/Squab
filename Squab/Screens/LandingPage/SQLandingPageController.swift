//
//  SQLandingPageController.swift
//  Squab
//
//  Created by Chandrachudh on 20/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit
import MXSegmentedPager

class SQLandingPageController: UIViewController {
    
    @IBOutlet weak var imgCountryFlag: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    let countryPickerController = Bundle.main.loadNibNamed("SQCountryPicker", owner: self, options: nil)![0] as! SQCountryPicker
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var selectedCountryCode = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        countryPickerController.delegate = self
        countryPickerController.prepareView()
        txtMobileNumber.delegate = self
        
        btnNext.addShadowWith(shadowPath: UIBezierPath.init(rect: btnNext.bounds).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5, shadowRadius: 2.0, shadowOffset: CGSize.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Target Methods
    @IBAction func didTapCountryCodeButton(_ sender: Any) {
        countryPickerController.frame = (UIApplication.shared.keyWindow?.bounds)!
        UIApplication.shared.keyWindow?.addSubview(countryPickerController)
        countryPickerController.animateAndShow()
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        view.endEditing(true)
        if txtMobileNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            showAlertWith(buttonTitle: "OK", message: "Phone number is required.", shouldPopCurrentVC: NO)
            return
        }
        
        SQLoginPhoneModel.loginWith(mobileNumber: txtMobileNumber.text!, countryCode: selectedCountryCode) { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                self.showErrorHud(position: .top, message: errorMessage, bgColor: .red, isPermanent: false)
            }
            else {
                
                let responseObj = (response as! SQLoginPhoneModel)
                if responseObj.status?.uppercased() == "ERROR" {
                    self.showErrorHud(position: .top, message: responseObj.details ?? "Something went wrong", bgColor: .red, isPermanent: false)
                }
                else {
                    DispatchQueue.main.async {
                        let otpPage = SQOTPEntryController()
                        otpPage.loginResponseModel = responseObj
                            self.navigationController?.pushViewController(otpPage, animated: true)
                    }
                }
            }
        }
    }
}

extension SQLandingPageController:SQCountryPickerDelegate {
    func didChangeSelectedCountry(countryCode: String, phoneCode: String, flagImage: UIImage) {
        selectedCountryCode = phoneCode
        imgCountryFlag.image = flagImage
        lblCountryCode.text = "(\(countryCode)) \(phoneCode)"
        imgCountryFlag.addShadowWith(shadowPath: UIBezierPath.init(rect: imgCountryFlag.bounds).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5, shadowRadius: 2.0, shadowOffset: CGSize.zero)
    }
}

extension SQLandingPageController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}

/*
 
 segmentedPagerView.delegate = self
 segmentedPagerView.dataSource = self
 segmentedPagerView.bounces = false
 segmentedPagerView.segmentedControlPosition = .top
 segmentedPagerView.pager.bounces = false
 segmentedPagerView.reloadData()
 segmentedPagerView.segmentedControl.selectionIndicatorColor = .red
 segmentedPagerView.segmentedControl.selectionIndicatorLocation = .down
 segmentedPagerView.segmentedControl.selectionStyle = .fullWidthStripe
 
 //, MXSegmentedPagerDelegate, MXSegmentedPagerDataSource
 func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
 return colors.count
 }
 
 func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
 let vw = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
 vw.backgroundColor = colors[index]
 return vw
 }
 
 func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
 return titles[index]
 }
 
 func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
 return 50
 }
 */
