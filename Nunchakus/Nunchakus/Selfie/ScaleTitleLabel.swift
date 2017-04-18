//
//  ScaleTitleLabel.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/18.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class ScaleTitleLabel: UILabel {

    var scale: Double? {
        didSet {
            guard let scale = scale else { return }
            let newRed = red + (1.0 - red) * scale
            let newGreen = green + (0.0 - green) * scale
            let newBlue = blue + (0.0 - blue) * scale
            textColor = UIColor(colorLiteralRed: Float(newRed), green: Float(newGreen), blue: Float(newBlue), alpha: 1.0)
            
            let fontSize = 1.0 + scale * 0.3
            transform = CGAffineTransform.init(scaleX: CGFloat(fontSize), y: CGFloat(fontSize))
        }
    }
    
    fileprivate let red = 0.4
    fileprivate let green = 0.5
    fileprivate let blue = 0.6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 15)
        textAlignment = .center
        backgroundColor = UIColor.clear
        textColor = UIColor(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: 1.0)
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
