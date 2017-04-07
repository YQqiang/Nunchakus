//
//  VideoViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/6.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class VideoViewController: BaseViewController {

    fileprivate var headerView: HeaderView!
    fileprivate var contentCollectionView: ContentCollectionView!
    
    lazy var categories: [String] = {
        return ["棍友自拍", "舞台表演", "棍法教学", "媒体关注", "影视动画", "国外聚焦", "极限跑酷"]
    }()
    lazy var videoTypes: [VideoType] = {
        return [VideoType.zipai, VideoType.biaoyan, VideoType.jiaoxue, VideoType.media, VideoType.movie, VideoType.guowai, VideoType.paoku]
    }()
    var videoControllers: [SelfieViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataView.isHidden = true
        view.backgroundColor = UIColor.white
        setupView()
        videoControllers = []
        for index in 0..<videoTypes.count {
            let videoC = SelfieViewController()
            addChildViewController(videoC)
            videoC.videoType = videoTypes[index]
            videoControllers.append(videoC)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        do {
            headerView = HeaderView()
            headerView.delegate = self
            view.addSubview(headerView)
            headerView.categories = categories
            headerView.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(40)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            })
        }
        
        do {
            contentCollectionView = ContentCollectionView()
            contentCollectionView.dataSource = self
            contentCollectionView.delegate = self
            contentCollectionView.register(cellClass: NewsContentCell.self, forCellWithReuseIdentifier: "cell")
            view.addSubview(contentCollectionView)
            contentCollectionView.snp.makeConstraints({ (make) in
                make.top.equalTo(headerView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
        }
    }
}

extension VideoViewController: HeaderViewDelegate {
    func categoryHeaderView(headerView: HeaderView, selectedIndex: Int) {
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        contentCollectionView.scrollAffectToNoOnce()
        contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}

extension VideoViewController: ContentCollectionViewDelegate {
    func contentCollectionView(_ contentView: ContentCollectionView, didShowViewWith index: Int) {
        headerView.selectTitle(of: index)
        for (i, videoVC) in videoControllers.enumerated() {
            if i != index {
                if videoVC.isViewLoaded {
                    videoVC.player.pause()
                }
            }
        }
    }
    
    func contentCollectionView(_ contentView: ContentCollectionView, didScrollFrom fromIndex: Int, to toIndex: Int, scale: Float) {
        headerView.adjustTitle(from: fromIndex, to: toIndex, scale: scale)
    }
}

extension VideoViewController: ContentCollectionViewDataSource {
    func numberOfItems(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewsContentCell
        
        if let cell = cell {
            cell.videoVC = videoControllers[indexPath.item]
            return cell
        }
        
        cell = NewsContentCell()
        cell!.videoVC = videoControllers[indexPath.item]
        return cell!
    }
}

