//
//  ScrollTitleViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/18.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

class ScrollTitleViewController: BaseViewController {

    fileprivate lazy var titleScrollView: UIScrollView = UIScrollView()
    fileprivate lazy var contentScrollView: UIScrollView = UIScrollView()
    fileprivate lazy var categories: [String] = {
        return ["棍友自拍", "舞台表演", "棍法教学", "媒体关注", "影视动画", "国外聚焦", "极限跑酷"]
    }()
    fileprivate lazy var videoTypes: [VideoType] = {
        return [VideoType.zipai, VideoType.biaoyan, VideoType.jiaoxue, VideoType.media, VideoType.movie, VideoType.guowai, VideoType.paoku]
    }()
    fileprivate var videoControllers: [SelfieViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataView.isHidden = true
        setupScroll()
        addChildController()
        setupTitleView()
//        scrollViewDidEndScrollingAnimation(contentScrollView)
    }
}

// MARK:- UI
extension ScrollTitleViewController {
    
    fileprivate func setupScroll() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(titleScrollView)
        view.addSubview(contentScrollView)
        contentScrollView.delegate = self
        contentScrollView.isPagingEnabled = true
        
        titleScrollView.backgroundColor = UIColor.blue
        contentScrollView.backgroundColor = UIColor.red
        
        titleScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(44)
        }
        
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleScrollView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    /// 添加自控制器
    fileprivate func addChildController() {
        videoControllers = []
        for index in 0..<videoTypes.count {
            let videoC = SelfieViewController()
            addChildViewController(videoC)
            videoC.videoType = videoTypes[index]
            videoControllers.append(videoC)
        }
    }
    
    
    /// 设置标题视图
    fileprivate func setupTitleView() {
        let labelW: CGFloat = 100.0
        var lastConstraintItem = titleScrollView.snp.left
        for index in 0..<videoControllers.count {
            let label = ScaleTitleLabel()
            label.text = categories[index]
            titleScrollView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(lastConstraintItem)
                make.top.bottom.equalTo(titleScrollView)
                make.width.equalTo(labelW)
                make.centerY.equalTo(titleScrollView)
            })
            lastConstraintItem = label.snp.right
            if index == videoControllers.count - 1 {
                label.snp.makeConstraints({ (make) in
                    make.right.equalToSuperview()
                })
            }
            label.tag = index
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelClick(tap:))))
            if index == 0 {
                label.scale = 1.0
            }
        }
        contentScrollView.contentSize = CGSize(width: CGFloat(videoControllers.count) * UIScreen.main.bounds.width, height: contentScrollView.bounds.height)
    }
    
    /// 标题的点击事件
    ///
    /// - Parameter tap: 点击手势
    @objc fileprivate func labelClick(tap: UITapGestureRecognizer) -> () {
        let index = tap.view?.tag ?? 0
        var offset = contentScrollView.contentOffset
        offset.x = CGFloat(index) * contentScrollView.bounds.width
        contentScrollView.setContentOffset(offset, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension ScrollTitleViewController: UIScrollViewDelegate {
    
    /// 手指离开scroll, scroll停止滚动时调用
    /// 必须是手动操作才会调用
    /// - Parameter scrollView:
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let height = scrollView.bounds.size.height
        let offsetX = scrollView.contentOffset.x
        
        // 停止动画时, 加载控制器的view
        let index = offsetX / width
        let i = Int(index)
        // 获取到对应的控制器
        let willShowVC = childViewControllers[i]
        // 让当前显示的View对应的标题居中
        let label = titleScrollView.subviews[i]
        var titleOffset = titleScrollView.contentOffset
        titleOffset.x = label.center.x - width * 0.5
        
        // 如果偏移量小于0 就不偏移
        if titleOffset.x < 0 {
            // 超出左边的处理
            titleOffset.x = 0
        }
        
        let maxTitleOffsetX = titleScrollView.contentSize.width - width
        if titleOffset.x > maxTitleOffsetX {
            // 超出右边的处理
            titleOffset.x = maxTitleOffsetX
        }
        
        titleScrollView.setContentOffset(titleOffset, animated: true)
        
        // 其他label回到最初状态
        for view in titleScrollView.subviews {
            if let otherLabel = view as? ScaleTitleLabel, otherLabel != label {
                otherLabel.scale = 0.0
            }
        }
        
        // 判断这个view是否加载过了
        if willShowVC.isViewLoaded {
            return
        }
        contentScrollView.addSubview(willShowVC.view)
        willShowVC.view.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(contentScrollView)
            make.left.equalTo(contentScrollView).offset(index * UIScreen.main.bounds.width)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    /// 只要scroll在滚动, 就会调用这个方法
    ///
    /// - Parameter scrollView:
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scale = scrollView.contentOffset.x / scrollView.bounds.width
        if scale < 0 || scale > CGFloat(videoControllers.count - 1) {
            return
        }
        let leftIndex: Int = Int(scale)
        let rightIndex: Int = Int(scale) + 1
        
        let rightScale = scale - CGFloat(leftIndex)
        let leftScale = 1.0 - rightScale
        
        let leftLabel: ScaleTitleLabel? = titleScrollView.subviews[leftIndex] as? ScaleTitleLabel
        let rightLabel: ScaleTitleLabel? = (rightIndex == titleScrollView.subviews.count) ? nil : (titleScrollView.subviews[rightIndex]  as? ScaleTitleLabel)
        if let leftLabel = leftLabel {
            leftLabel.scale = Double(leftScale)
        }
        if let rightLabel = rightLabel {
            rightLabel.scale = Double(rightScale)
        }
    }
}
