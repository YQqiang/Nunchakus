//
//  ProfileViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/7.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    fileprivate lazy var iconImageV: UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataView.isHidden = true
        navigationItem.title = "我的"
        view.addSubview(iconImageV)
        iconImageV.image = UIImage(named: "webwxgetmsgimg (1)")
        iconImageV.snp.makeConstraints { (make) in
           make.edges.equalTo(view)
        }
    }

}
