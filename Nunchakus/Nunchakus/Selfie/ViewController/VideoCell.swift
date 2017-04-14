//
//  VideoCell.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/22.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCell: UITableViewCell {

    fileprivate lazy var timeLabel: UILabel = UILabel()
    fileprivate lazy var titleLabel: UILabel = UILabel()
    lazy var imgV: UIImageView = UIImageView()
    fileprivate lazy var videoPlayBtn: UIButton = UIButton()
    lazy var bgView: UIView = UIView()
    var videoFrame: CGRect {
        return imgV.bounds
    }
    
    var videoModel: SelfieModel? {
        didSet {
            let url = URL(string: videoModel?.img ?? "")
            imgV.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "bg_media_default"), options: nil, progressBlock: nil, completionHandler: nil)
            timeLabel.text = default__str(videoModel?.time)
            titleLabel.text = default__str(videoModel?.title)
        }
    }
    
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
        selectionStyle = .none
        bgView.layer.cornerRadius = 5
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(0)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-8)
        }
        
        let superView = bgView
        superView.addSubview(imgV)
        imgV.addSubview(timeLabel)
        superView.addSubview(titleLabel)
        superView.addSubview(videoPlayBtn)
        
        imgV.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(superView)
            make.height.equalTo(videoHeight)
        }
        
        timeLabel.numberOfLines = 1
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(imgV).offset(-8)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgV).offset(8)
            make.right.equalTo(imgV).offset(-8)
            make.top.equalTo(imgV.snp.bottom).offset(8)
            make.bottom.equalTo(superView).offset(-8)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.globalColor()
        superView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(lineView.superview!)
            make.height.equalTo(1)
        }
        
        videoPlayBtn.setImage(#imageLiteral(resourceName: "video-play"), for: .normal)
        videoPlayBtn.isUserInteractionEnabled = false
        videoPlayBtn.addTarget(self, action: #selector(videoPlayAction), for: .touchUpInside)
        videoPlayBtn.snp.makeConstraints { (make) in
            make.center.equalTo(imgV)
        }
        superView.backgroundColor = UIColor.bgColor()
    }
}

extension VideoCell {
    @objc fileprivate func videoPlayAction() {
        print(#function, #line)
    }
}
