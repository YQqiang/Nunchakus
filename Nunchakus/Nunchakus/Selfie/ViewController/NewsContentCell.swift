//
//  TFNewsContentView.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/6.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class NewsContentCell: UICollectionViewCell {
    var videoVC: SelfieViewController? {
        didSet {
            guard let videoVC = videoVC else {
                return
            }
            contentView.subviews.forEach { (subView) in
                subView.removeFromSuperview()
            }
            contentView.addSubview(videoVC.view)
            videoVC.view.frame = contentView.bounds
        }
    }
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
