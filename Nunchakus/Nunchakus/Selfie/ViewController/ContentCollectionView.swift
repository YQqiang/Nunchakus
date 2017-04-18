//
//  ContentCollectionView.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/6.
//  Copyright © 2017年 sungrow. All rights reserved.
//


import UIKit

protocol ContentCollectionViewDelegate: NSObjectProtocol {
    func contentCollectionView(_ contentView: ContentCollectionView, didScrollFrom fromIndex: Int, to toIndex: Int, scale: Float)
    
    func contentCollectionView(_ contentView: ContentCollectionView, didShowViewWith index: Int)
}

protocol ContentCollectionViewDataSource: NSObjectProtocol {
    
    func numberOfItems(in collectionView: UICollectionView) -> Int
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class ContentCollectionView: UIView {
    weak var delegate: ContentCollectionViewDelegate? {
        didSet {
            if let _ = delegate {
                collectionView.delegate = self
            } else {
                collectionView.delegate = nil
            }
        }
    }
    weak var dataSource: ContentCollectionViewDataSource? {
        didSet {
            if let _ = dataSource {
                collectionView.dataSource = self
            } else {
                collectionView.dataSource = nil
            }
        }
    }
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var currentOffsetX: Float = 0.0
    fileprivate var toIndex = 0
    fileprivate var oldIndex = 0
    fileprivate var isTapSelected = false
    
    fileprivate var contentCout: Int {
        get {
            guard let dataSource = dataSource else {
                fatalError("请继承dataSource并实现数据源方法")
            }
            return dataSource.numberOfItems(in: collectionView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 让这一次的滚动不起作用，配合HeaderView使用
    func scrollAffectToNoOnce() {
        isTapSelected = true
    }
    
    /// 使用类注册Cell
    ///
    /// - Parameters:
    ///   - cellClass: 类的名字
    ///   - forCellWithReuseIdentifier: 循环使用的标识
    func register(cellClass: AnyClass?, forCellWithReuseIdentifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    /// 使用nib注册cell
    ///
    /// - Parameters:
    ///   - nib: nib文件名字
    ///   - forCellWithReuseIdentifier: 循环使用标识
    func register(nib: UINib?, forCellWithReuseIdentifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionViewScrollPosition, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func setupViews() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
}

extension ContentCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            fatalError("请继承dataSource并实现数据源方法")
        }
        return dataSource.numberOfItems(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = dataSource else {
            fatalError("请继承dataSource并实现数据源方法")
        }
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

extension ContentCollectionView: UIScrollViewDelegate {
    /// 开始拖拽的时候
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentOffsetX = Float(scrollView.contentOffset.x)
        isTapSelected = false
        currentOffsetX = Float(scrollView.contentOffset.x)
    }
    
    /// 滑动过程中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isTapSelected {
            return
        }
        
        let scale = Float(scrollView.contentOffset.x).truncatingRemainder(dividingBy: Float(kScreenWidth)) / Float(kScreenWidth)
        if scale == 0.0 {
            return
        }
        
        let index = Int(scrollView.contentOffset.x / UIScreen.main.bounds.size.width)
        let diff = Float(scrollView.contentOffset.x) - currentOffsetX
        
        if diff > 0.0 { // 向右滑动
            toIndex = index + 1
            oldIndex = index
        } else { //向左滑动
            oldIndex = index + 1
            toIndex = index
        }
        
        if toIndex > contentCout - 1 || toIndex < 0 || oldIndex > contentCout - 1 {
            return
        }
        
        delegate?.contentCollectionView(self, didScrollFrom: oldIndex, to: toIndex, scale: scale)
    }
    
    /// 滑动停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isTapSelected {
            return
        }
        
        currentOffsetX = Float(scrollView.contentOffset.x)
        toIndex = Int(currentOffsetX / Float(kScreenWidth))
        if toIndex > contentCout - 1 || toIndex < 0 {
            return
        }

        if let _ = collectionView.dataSource, let _ = collectionView.delegate {
            delegate?.contentCollectionView(self, didShowViewWith: toIndex)
        }
    }

}

extension ContentCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension ContentCollectionView: UICollectionViewDelegate {
    
}
