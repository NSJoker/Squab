//
//  SQReminderDatePickerView.swift
//  Squab
//
//  Created by Chandrachudh on 26/11/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

enum ReminderSetterMode {
    case date
    case time
}

protocol SQReminderDatePickerViewDelegate:class {
    func showCustomeAlert(message:String)
    func setReminderForCurrentDocAt(date:Date)
}

class SQReminderDatePickerView: UIView {
    
    weak var delegate:SQReminderDatePickerViewDelegate?

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lbDateNTime: UILabel!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var btnDone: UIButton!
    
    var currentMode = ReminderSetterMode.date
    let currentTime = Date().timeIntervalSince1970
    
    let dismissControl = UIControl.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    
    
    func prepareView() {
        if dismissControl.superview == nil {
            dismissControl.addTarget(self, action: #selector(animateAndHide), for: .touchUpInside)
            dismissControl.backgroundColor = .clear
            addSubview(dismissControl)
            bringSubview(toFront: contentView)
        }
        
        lbDateNTime.text = "Select Date"
        btnDone.setTitle("Set Time", for: .normal)
        dateTimePicker.datePickerMode = .date
        dateTimePicker.date = Date.init(timeIntervalSince1970: currentTime)
    }
    
    func animateAndShow() {
        prepareView()
        alpha = 0.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }) { (finished) in
        }
    }
    
    func animateAndHide() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        switch currentMode {
        case .date:
            lbDateNTime.text = "Select Time"
            btnDone.setTitle("Done", for: .normal)
            dateTimePicker.datePickerMode = .time
            currentMode = .time
            break
        default:
            if dateTimePicker.date.timeIntervalSince1970 < Date().timeIntervalSince1970 {
                delegate?.showCustomeAlert(message: "Selected time must be greater than current time")
                return
            }
            delegate?.setReminderForCurrentDocAt(date: dateTimePicker.date)
            break
        }
    }
}
