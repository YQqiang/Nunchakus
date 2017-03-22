//
//  BaseViewController.swift
//  Nunchakus
//
//  Created by kjlink on 2017/3/21.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    lazy var emptyDataView: EmptyDataView = {
        let emptyDataV = EmptyDataView(frame: CGRect.zero)
        emptyDataV.clickAction = { [weak self] () -> () in
            self?.loadRequestData()
        }
        self.view.addSubview(emptyDataV)
        emptyDataV.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        return emptyDataV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bgColor()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !emptyDataView.isHidden {
            view.bringSubview(toFront: emptyDataView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if view.window == nil {
            view = nil
        }
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

extension BaseViewController {
    func loadRequestData() {
    }
}
