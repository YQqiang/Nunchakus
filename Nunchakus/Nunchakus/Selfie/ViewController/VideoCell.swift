//
//  VideoCell.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/22.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    fileprivate lazy var timeLabel: UILabel = UILabel()
    fileprivate lazy var titleLabel: UILabel = UILabel()
    fileprivate lazy var imgV: UIImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension VideoCell {
    fileprivate func createUI() {
        let bgView = UIView()
        bgView.layer.cornerRadius = 5
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(8)
            make.bottom.right.equalTo(contentView).offset(-8)
        }
        
        let superView = bgView
        superView.addSubview(imgV)
        imgV.addSubview(timeLabel)
        superView.addSubview(titleLabel)
        
        imgV.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(superView)
            make.height.equalTo(videoHeight)
        }
        
        timeLabel.numberOfLines = 1
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(imgV)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(imgV)
            make.top.equalTo(imgV.snp.bottom)
            make.bottom.equalTo(superView).offset(-8)
        }
        
        superView.backgroundColor = UIColor.orange
        titleLabel.text = "fjsajfsfja"
        timeLabel.text = "yuqiang"
    }
}
