//
//  Hud.swift
//  iSolarCloudDBO
//
//  Created by kjlink on 2016/12/1.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SVProgressHUD

class Hud: UIView {
    
    class func showError(status: String) {
        SVProgressHUD.showError(withStatus: NSLocalizedString(status, comment: ""))
    }
    
    class func showSuccess(status: String) {
        SVProgressHUD.showSuccess(withStatus: NSLocalizedString(status, comment: ""))
    }
    
    class func showInfo(status: String) {
        SVProgressHUD.showInfo(withStatus: NSLocalizedString(status, comment: ""))
    }
    
    class func show(status: String) {
        SVProgressHUD.show(withStatus: NSLocalizedString(status, comment: ""))
    }
    
    class func dismissHUD() {
        SVProgressHUD.dismiss()
    }
}
