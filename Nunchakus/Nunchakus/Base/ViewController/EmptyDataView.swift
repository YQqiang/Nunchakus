//
//  EmptyDataView.swift
//  operation4ios
//
//  Created by sungrow on 2017/2/28.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

import UIKit

class EmptyDataView: UIView {
    
    var titleText: String = NSLocalizedString("暂无数据", comment: "") {
        didSet {
            titleTextLabel.text = titleText
        }
    }
    
    var contentText: String = NSLocalizedString("请点击屏幕刷新", comment: "") {
        didSet {
            contentTextLabel.text = contentText
        }
    }
    var contentImage: UIImage = #imageLiteral(resourceName: "placeholder_bgimg") {
        didSet {
            contentImageView.image = contentImage.image(UIColor.globalColor())
        }
    }
    
    var clickAction: (() -> Void)?
    
    // MARK:- 控件
    fileprivate lazy var contentImageView: UIImageView = UIImageView()
    fileprivate lazy var titleTextLabel: UILabel = UILabel()
    fileprivate lazy var contentTextLabel: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let clickAction = clickAction {
            clickAction()
        }
    }

}

// MARK:-  private func
extension EmptyDataView {
    // MARK:- UI
    fileprivate func createUI() {
        isHidden = false
        addSubview(contentImageView)
        addSubview(titleTextLabel)
        addSubview(contentTextLabel)
        
        titleTextLabel.text = titleText
        titleTextLabel.textAlignment = .center
        titleTextLabel.textColor = UIColor.globalColor()
        
        contentTextLabel.text = contentText
        contentTextLabel.font = UIFont.systemFont(ofSize: 14)
        contentTextLabel.textAlignment = .center
        contentTextLabel.textColor = UIColor.globalColor()
        contentImageView.image = contentImage.image(UIColor.globalColor())
        
        contentImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-80)
        }
        titleTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentImageView.snp.bottom).offset(16)
            make.centerX.equalTo(contentImageView)
        }
        contentTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextLabel.snp.bottom).offset(16)
            make.centerX.equalTo(contentImageView)
        }
    }
}
