//
//  SQUserDetailsEntryController.swift
//  Squab
//
//  Created by Chandrachudh on 21/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQUserDetailsEntryController: UIViewController {

    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    var loginResponseModel:SQLoginPhoneModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableNextButton()
        txtFirstname.delegate = self
        txtLastname.delegate = self
        applyForPushNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func enableNextButton() {
        btnNext.isEnabled = true
        btnNext.alpha = 1.0
    }
    
    func disableNextButton() {
        btnNext.isEnabled = false
        btnNext.alpha = 0.3
    }
    
    //MARK: TARGET METHODS
    @IBAction func didTapNextButton(_ sender: Any) {
        view.endEditing(true)
        if txtFirstname.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            showAlertWith(buttonTitle: "OK", message: "Firstname cannot be empty", shouldPopCurrentVC: NO)
            return
        }
        
        if txtLastname.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            showAlertWith(buttonTitle: "OK", message: "Lastname cannot be empty", shouldPopCurrentVC: NO)
            return
        }
        
        loginResponseModel?.registerUser(firstName: txtFirstname.text!, lastName: txtLastname.text!, returnBlock: { (response, errorMessage) in
            
            if let errorMessage = errorMessage {
                self.showErrorHud(position: .top, message: errorMessage, bgColor: .red, isPermanent: false)
            }
            else {
                let registerResponse = response as! SQRequestSuccessStatusModel
                if registerResponse.success {
                    SquabUserManager.sharedInstance.markLoginCompleted()
                    let boardsPage = SQBoardsPageController()
                    self.navigationController?.viewControllers = [boardsPage]
                }
                else {
                    self.showErrorHud(position: .top, message: "Something went wrong", bgColor: .red, isPermanent: false)
                }
            }
        })
    }
}

extension SQUserDetailsEntryController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text!
        let updatedtext = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == txtFirstname {
            if updatedtext.trimmingCharacters(in: .whitespacesAndNewlines).characters.count != 0 && txtLastname.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count != 0 {
                enableNextButton()
            }
            else {
                disableNextButton()
            }
        }
        else {
            if updatedtext.trimmingCharacters(in: .whitespacesAndNewlines).characters.count != 0 && txtFirstname.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count != 0 {
                enableNextButton()
            }
            else {
                disableNextButton()
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstname {
            txtLastname.becomeFirstResponder()
        }
        else {
            view.endEditing(true)
            didTapNextButton(btnNext)
        }
        return true
    }
}
