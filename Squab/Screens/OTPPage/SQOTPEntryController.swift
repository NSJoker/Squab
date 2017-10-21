//
//  SQOTPEntryController.swift
//  Squab
//
//  Created by Chandrachudh on 21/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQOTPEntryController: UIViewController {
    
    var loginResponseModel:SQLoginPhoneModel?
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var lblTermsAndCOnditions: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        
        let mainString = "OTP has been sent to " + (loginResponseModel?.selectedMobileNumber)!
        let numberRange = (mainString as NSString).range(of: (loginResponseModel?.selectedMobileNumber)!)
        let attrStr = NSMutableAttributedString.init(string: mainString)
        attrStr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 20), range: numberRange)
        lblDescription.attributedText = attrStr
        
        let higlightedString = "Privacy Statement and Squab Service Agreement."
        let tremsAndConditions = "Choosing next means that you agree  to the\n" + higlightedString
        let higlightedStringRange = (tremsAndConditions as NSString).range(of: higlightedString)
        let termsAttrStr = NSMutableAttributedString.init(string: tremsAndConditions)
        termsAttrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.rgb(fromHex: 0x2EA2CD), range: higlightedStringRange)
        lblTermsAndCOnditions.attributedText = termsAttrStr
        
        btnNext.addShadowWith(shadowPath: UIBezierPath.init(rect: btnNext.bounds).cgPath, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5, shadowRadius: 2.0, shadowOffset: CGSize.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Target Methods
    @IBAction func didTapTermsAndConditionsView(_ sender: Any) {
        view.endEditing(true)
        let urlForTermsAndConditions = "https://sites.google.com/view/avartakaprivacypolicy/privacy-policy"
        if let url = URL.init(string: urlForTermsAndConditions) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            showErrorHud(position: .top, message: "Unable to open browser", bgColor: .red, isPermanent: false)
        }
    }
    
    @IBAction func didTapNextbutton(_ sender: Any) {
        view.endEditing(true)
        if txtOtp.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            showAlertWith(buttonTitle: "OK", message: "OTP is required", shouldPopCurrentVC: NO)
            return
        }
        
        loginResponseModel?.verifyMobile(otp: txtOtp.text!, returnBlock: { (response, errorMessage) in
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
                        SquabUserManager.sharedInstance.saveNewRegisteredPhone(phone: (self.loginResponseModel?.selectedMobileNumber)!)
                        self.navigationController?.pushViewController(SQUserDetailsEntryController(), animated: true)
                    }
                }
            }
        })
    }
}
