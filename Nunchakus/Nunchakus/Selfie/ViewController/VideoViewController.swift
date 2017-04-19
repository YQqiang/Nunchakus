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
    fileprivate var currentIndex = 0
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = contentCollectionView.dataSource {
        } else {
            contentCollectionView.dataSource = self
        }
        if let _ = contentCollectionView.delegate {
        } else {
            contentCollectionView.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentIndex == videoControllers.count - 1 {
            headerView.delegate?.categoryHeaderView(headerView: headerView, selectedIndex: currentIndex)
            headerView.selectTitle(of: currentIndex)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var willShowFull = false
        for (_, videoVC) in videoControllers.enumerated() {
            if videoVC.willShowFullScreen {
                willShowFull = true
                videoVC.willShowFullScreen = false
                break
            }
        }
        
        if willShowFull {
            contentCollectionView.dataSource = nil
            contentCollectionView.delegate = nil
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
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
        for (i, videoVC) in videoControllers.enumerated() {
            if i != selectedIndex {
                if videoVC.isViewLoaded {
                    videoVC.player.prepareToDealloc()
                    videoVC.player.removeFromSuperview()
                }
            }
        }
        currentIndex = selectedIndex
//        contentCollectionView.reloadData()
    }
}

extension VideoViewController: ContentCollectionViewDelegate {
    func contentCollectionView(_ contentView: ContentCollectionView, didShowViewWith index: Int) {
        headerView.selectTitle(of: index)
        for (i, videoVC) in videoControllers.enumerated() {
            if i != index {
                if videoVC.isViewLoaded {
                    videoVC.player.prepareToDealloc()
                    videoVC.player.removeFromSuperview()
                }
            }
        }
        currentIndex = index
//        contentCollectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewsContentCell
        
        cell!.videoVC = videoControllers[indexPath.item]
        return cell!
    }
}

