//
//  LicenseViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/17.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class LicenseViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataView.isHidden = true
        navigationItem.title = NSLocalizedString("开源组件", comment: "")
        let webView = UIWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        webView.scrollView.bounces = false
        let urlRequest = URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "License", ofType: "html")!))
        webView.loadRequest(urlRequest)
        view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
