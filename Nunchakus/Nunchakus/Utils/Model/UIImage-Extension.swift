//
//  UIImage-Extension.swift
//  iSolarCloudDBO
//
//  Created by kjlink on 2016/12/10.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

extension UIImage {
    class func image(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
