//
//  SQCountryPicker.swift
//  Squab
//
//  Created by Chandrachudh on 21/10/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit
import CountryPicker

protocol SQCountryPickerDelegate:class {
    func didChangeSelectedCountry(countryCode:String, phoneCode:String, flagImage:UIImage)
}

class SQCountryPicker: UIView {

    @IBOutlet weak var pickerBaseView: UIView!
    let dismissControl = UIControl.init()
    let countryPicker = CountryPicker()
    
    weak var delegate:SQCountryPickerDelegate?
    
    func prepareView() {
        pickerBaseView.backgroundColor = .white
        pickerBaseView.layer.cornerRadius = 4.0
        
        if dismissControl.superview == nil {
            dismissControl.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            dismissControl.addTarget(self, action: #selector(animateAndHide), for: .touchUpInside)
            addSubview(dismissControl)
            
            //get corrent country
            //let locale = Locale.current
            //let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
            countryPicker.countryPickerDelegate = self
            countryPicker.showPhoneNumbers = true
            countryPicker.setCountry("IN")
            countryPicker.frame = CGRect(x: 0, y: 40, width: SCREEN_WIDTH-20, height: 240)
            pickerBaseView.addSubview(countryPicker)
        }
        
        bringSubview(toFront: pickerBaseView)
    }
    
    func animateAndShow() {
        alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }) { (finished) in
        }
    }
    
    @objc private func animateAndHide() {
        alpha = 1.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    
    //MARK: Target Methods
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        animateAndHide()
    }
    
    @IBAction func didTapCancelBUtton(_ sender: Any) {
        animateAndHide()
    }
}

extension SQCountryPicker:CountryPickerDelegate {
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        delegate?.didChangeSelectedCountry(countryCode: countryCode, phoneCode: phoneCode, flagImage: flag)
    }
}
