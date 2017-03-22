//
//  SelfieViewController.swift
//  Nunchakus
//
//  Created by kjlink on 2017/3/21.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import RxSwift
import EVReflection
import Kanna

class SelfieViewController: BaseViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        zipaiServiceProvider.request(.test).mapString().showAPIErrorToast().subscribe(onNext: { (html) in
            if let doc = HTML(html: html, encoding: .utf8) {
                let ul = doc.xpath("//div[@class='lbox']/ul/li")
                var items: [SelfieModel] = []
                for li in ul {
                    let model = SelfieModel(html: li)
                    items.append(model)
                }
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: nil) {
        }.addDisposableTo(disposeBag)
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
