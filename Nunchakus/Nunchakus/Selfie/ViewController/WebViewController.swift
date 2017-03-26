//
//  WebViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/23.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import JavaScriptCore

class WebViewController: BaseViewController, UIWebViewDelegate {

    fileprivate lazy var webView: UIWebView = UIWebView()
    var context:JSContext?
    var html: String? {
        didSet {
            if let html = html {
//                webView.loadHTMLString(html, baseURL: nil)   
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("视屏播放", comment: "")
        emptyDataView.isHidden = true
        let baseURL = Bundle.main.bundlePath
        let requestJSPath = Bundle.main.path(forResource: "test", ofType: "html")!
        
        guard let requestJS = try? String.init(contentsOfFile: requestJSPath) else {
            print("failure!")
            return
        }
        
        webView = UIWebView.init()
        webView.backgroundColor = UIColor.gray
        webView.loadHTMLString(requestJS, baseURL: URL(fileURLWithPath: baseURL))
        webView.delegate = self
        webView.frame = self.view.bounds
        view.addSubview(webView)
    }
    
    deinit {
        print("\(#function)----deinit")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("url = \(request.url?.absoluteString)")
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            context.evaluateScript("requestURL(window)")
        } else {
            print("视频解析错误")
        }
    }
}
