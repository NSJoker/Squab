//
//  SQWebViewController.swift
//  Squab
//
//  Created by Chandrachudh on 06/11/17.
//  Copyright © 2017 NSJoker. All rights reserved.
//

import UIKit

class SQWebViewController: UIViewController {
    
    let lblTitle = UILabel.init(frame:CGRect(x:50, y:20, width:SCREEN_WIDTH - 60, height:50))
    let navigationBarView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 70))
    let btnBack = UIButton.init(frame: CGRect(x: 0, y: 20, width: 50, height: 50))
    
    let myWebView = UIWebView.init(frame: CGRect(x: 0, y: 70, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-70))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(navigationBarView)
        navigationBarView.backgroundColor = UIColor.rgb(fromHex: 0x186860)
        
        view.addSubview(btnBack)
        btnBack.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        btnBack.setTitle("", for: .normal)
        btnBack.setImage(#imageLiteral(resourceName: "ic_back_arrow"), for: .normal)
        
        view.addSubview(lblTitle)
        lblTitle.font = UIFont.systemFont(ofSize: 20)
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.textAlignment = .center
        lblTitle.minimumScaleFactor = 0.5
        lblTitle.textColor = UIColor.white
        
        view.addSubview(myWebView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadWebViewWith(url:URL) {
        let request = URLRequest.init(url: url)
        myWebView.loadRequest(request)
    }
}
