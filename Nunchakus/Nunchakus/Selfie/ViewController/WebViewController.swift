//
//  WebViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/23.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import Toaster

class WebViewController: BaseViewController, UIWebViewDelegate {

    var getRealUrl: ((_ url: String) -> ())?
    fileprivate lazy var webView: UIWebView = UIWebView()
    var v_id: String? {
        didSet {
            print("v_id = \(v_id)")
            if let v_id = v_id {
                webView.stringByEvaluatingJavaScript(from: "requestURL(window, '\(v_id)')")
            } else {
                Hud.showError(status: NSLocalizedString("视屏id错误", comment: ""))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("视屏播放", comment: "")
        emptyDataView.isHidden = true
        webView.delegate = self
        webView.frame = CGRect.zero
        view.addSubview(webView)
        let baseURL = Bundle.main.bundlePath
        let requestJSPath = Bundle.main.path(forResource: "test", ofType: "html")!
        
        guard let requestJS = try? String.init(contentsOfFile: requestJSPath) else {
            print("failure!")
            return
        }
        webView.loadHTMLString(requestJS, baseURL: URL(fileURLWithPath: baseURL))
    }
    
    deinit {
        print("\(#function)----deinit")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("url = \(request.url?.absoluteString)")
        let urlStr = request.url?.absoluteString
        if let urlStr = urlStr, urlStr.hasPrefix("yuqiang://encodeidfailed") {
            Hud.showError(status: NSLocalizedString("播放出错", comment: ""))
            return false
        }
        if let urlStr = urlStr, urlStr.hasPrefix("http://pl.youku.com") {
            if let getRealUrl = getRealUrl {
                getRealUrl(urlStr)
            }
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
    }
}
