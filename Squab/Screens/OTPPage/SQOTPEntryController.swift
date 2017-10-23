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
    @IBOutlet weak var lcImageviewTopSpace: NSLayoutConstraint!
    
    
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
        
        txtOtp.delegate = self
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
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        
        if SCREEN_HEIGHT < 600 {
            let endFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            if endFrame.origin.y == SCREEN_HEIGHT {//Keyboard dissed
                lcImageviewTopSpace.constant = 30.0
            }
            else {
                lcImageviewTopSpace.constant = -70.0
            }
            
            view.layoutIfNeeded()
        }
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
                if responseObj.Status?.uppercased() == "ERROR" {
                    self.showErrorHud(position: .top, message: responseObj.Details ?? "Something went wrong", bgColor: .red, isPermanent: false)
                }
                else {
                    DispatchQueue.main.async {
                        SquabUserManager.sharedInstance.saveLoginModel(loginModel: self.loginResponseModel!)
                        let userDetailsEntryPage = SQUserDetailsEntryController()
                        userDetailsEntryPage.loginResponseModel = self.loginResponseModel
                        self.navigationController?.pushViewController(userDetailsEntryPage, animated: true)
                    }
                }
            }
        })
    }
}

extension SQOTPEntryController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        didTapNextbutton(btnNext)
        return true
    }
}
