//
//  WebViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/23.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    fileprivate lazy var webView: UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataView.isHidden = true
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(16)
            make.left.equalTo(view).offset(8)
            make.right.equalTo(view).offset(-8)
            make.height.equalTo(300)
        }
        let html = Bundle.main.url(forResource: "test", withExtension: "html")
        print("html = \(html?.absoluteString)")
        if let html = html {
            let urlRequest = URLRequest(url: html)
            webView.loadRequest(urlRequest)
        }
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
