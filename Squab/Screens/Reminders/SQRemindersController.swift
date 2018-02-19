//
//  SQRemindersController.swift
//  Squab
//
//  Created by Chandrachudh on 19/02/18.
//  Copyright © 2018 NSJoker. All rights reserved.
//

import UIKit

class SQRemindersController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var lblNoItemsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Target Methods
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func prepareView() {
        
        let nib = UINib.init(nibName: SQReminderCell.reuseIdentifier(), bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: SQReminderCell.reuseIdentifier())
        
        myTableView.tableFooterView = UIView()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.estimatedRowHeight = 70.0
        myTableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.reloadData()
        
        if SquabReminderManager.sharedInstance.allReminders.count == 0 {
            myTableView.isHidden = true
            lblNoItemsLabel.isHidden = false
        }
        else {
            myTableView.isHidden = false
            lblNoItemsLabel.isHidden = true
        }
    }
}


extension SQRemindersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SquabReminderManager.sharedInstance.allReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQReminderCell.reuseIdentifier(), for: indexPath) as! SQReminderCell
        cell.populateViewWith(reminder: SquabReminderManager.sharedInstance.allReminders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertController = UIAlertController.init(title: APP_NAME, message: "Would you like to delete the reminder?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction.init(title: "Delete", style: .destructive) { (action) in
            SquabReminderManager.sharedInstance.removeReminder(docID: (SquabReminderManager.sharedInstance.allReminders[indexPath.row].reminderSearchResult?.docid)!)
            self.myTableView.reloadData()
            
            if SquabReminderManager.sharedInstance.allReminders.count == 0 {
                self.myTableView.isHidden = true
                self.lblNoItemsLabel.isHidden = false
            }
            else {
                self.myTableView.isHidden = false
                self.lblNoItemsLabel.isHidden = true
            }
        }
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
