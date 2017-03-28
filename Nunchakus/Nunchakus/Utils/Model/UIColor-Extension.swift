//
//  UIColor-Extension.swift
//  iSolarCloudDBO
//
//  Created by kjlink on 2016/12/7.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 便利构造函数构建 十六进制颜色
    convenience init(colorHex: Int, alpha: Float = 1.0) {
       self.init(colorLiteralRed: Float(Double((colorHex & 0xFF0000) >> 16))/255.0, green: Float(Double((colorHex & 0xFF00) >> 8))/255.0, blue: Float(Double(colorHex & 0xFF))/255.0, alpha: alpha)
    }
    
    /// 类方法构建 十六进制颜色
    class func color(_ hex: Int, alpha: Float = 1.0) -> UIColor {
        return UIColor(colorLiteralRed: Float(Double((hex & 0xFF0000) >> 16))/255.0, green: Float(Double((hex & 0xFF00) >> 8))/255.0, blue: Float(Double(hex & 0xFF))/255.0, alpha: alpha)
    }
    
    class func color(R: Float, G: Float, B: Float, A: Float = 1.0) -> UIColor {
        return UIColor(colorLiteralRed: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
    }
    
    /// 图标配色
    class func barPriorityAColor() -> UIColor {
        return UIColor(colorHex: 0x3399fe)
    }
    
    class func barPriorityBColor() -> UIColor {
        return UIColor.color(0xb2d9ff)
    }
    
    class func linePriorityAColor() -> UIColor {
        return UIColor.color(0x55b327)
    }
    
    class func linePriorityBColor() -> UIColor {
        return UIColor.color(0x09f2f8)
    }
    
    class func linePriorityCColor() -> UIColor {
        return UIColor.color(0x3399fe)
    }
    
    /// 背景颜色
    class func bgColor() -> UIColor {
        return .color(R: 242, G: 242, B: 242)
    }
    /// 线条颜色
    class func lineColor() -> UIColor {
        return .color(R: 222, G: 222, B: 222)
    }
    /// 全局配色
    class func globalColor() -> UIColor {
        return UIColor(colorHex: 0xea9518)
//        return UIColor.red
    }
    /// 图片非选中颜色
    class func deselectColor() -> UIColor {
        return UIColor(colorHex: 0x707070)
    }
}
