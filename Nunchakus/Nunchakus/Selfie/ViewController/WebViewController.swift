//
//  WebViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/23.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController, UIWebViewDelegate {

    fileprivate lazy var webView: UIWebView = UIWebView()
    var html: String? {
        didSet {
            if let html = html {
                webView.loadHTMLString(html, baseURL: nil)   
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("视屏播放", comment: "")
        emptyDataView.isHidden = true
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.centerY)
        }
        self.webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.url)
        return true
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
