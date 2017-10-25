//
//  HomeHeaderView.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/6.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit

// 屏幕的宽高
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

protocol HeaderViewDelegate: NSObjectProtocol {
    func categoryHeaderView(headerView: HeaderView, selectedIndex: Int)
}

class HeaderView: UIView {
    fileprivate var categoryScrollView: CategoryScrollView!
    weak var delegate: HeaderViewDelegate?
    var categories: [String]? {
        didSet {
            categoryScrollView.categories = categories
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryScrollView = CategoryScrollView()
        self.addSubview(categoryScrollView)
        self.backgroundColor = UIColor.clear
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.globalColor()
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(3)
        }
        
        categoryScrollView.categoryDelegate = self
        categoryScrollView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustTitle(from fromIndex: Int, to toIndex: Int, scale: Float) {
        categoryScrollView.adjustTitle(from: fromIndex, to: toIndex, scale: scale)
    }
    
    func selectTitle(of index: Int) {
        categoryScrollView.selectButton(withFrom: categoryScrollView.currentIndex, to: index)
    }
}

extension HeaderView: CategoryScrollViewDelegate {
    fileprivate func categoryScrollView(scrollView: CategoryScrollView, selectedButtonIndex: Int) {
        delegate?.categoryHeaderView(headerView: self, selectedIndex: selectedButtonIndex)
    }
}

//MARK: - CategoryScrollView

private protocol CategoryScrollViewDelegate: NSObjectProtocol {
    func categoryScrollView(scrollView: CategoryScrollView, selectedButtonIndex: Int)
}

private class CategoryScrollView: UIScrollView {
    weak var categoryDelegate: CategoryScrollViewDelegate?
    var currentIndex: Int = 0
    
    var categories: [String]?  {
        didSet {
            if let categories = categories {
                if categories.count > 0 {
                    setupButtonView(with: categories)
                    selectButton(withFrom: currentIndex, to: 0)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtonView(with categories: [String]) {
        for (index, category) in categories.enumerated() {
            let button = UIButton()
            button.setTitle(category, for: .normal)
            button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(.black, for: .normal)
            button.tag = index
            self.addSubview(button)
            
            button.snp.makeConstraints({ [unowned self] (make) in
                make.centerY.equalTo(self)
                
                if self.subviews.count == 1 {
                    make.left.equalTo(self.snp.left).offset(15)
                } else if self.subviews.count == self.categories?.count {
                    make.left.equalTo((self.subviews[self.subviews.count - 2].snp.right)).offset(15)
                    make.right.equalTo(self).offset(-15)
                } else {
                    make.left.equalTo((self.subviews[self.subviews.count - 2].snp.right)).offset(15)
                }
            })
        }
    }
    
    @objc func buttonClicked(sender: UIButton) {
        selectButton(withFrom: currentIndex, to: sender.tag)
        categoryDelegate?.categoryScrollView(scrollView: self, selectedButtonIndex: sender.tag)
    }
    
    /// 选中某个标题
    func selectButton(withFrom currentIndex: Int, to toIndex: Int) {
        let redColor = UIColor(red: CGFloat(240 / 255.0), green: CGFloat(144 / 255.0), blue: 0.0, alpha: 1)
        
        if currentIndex == 0 && toIndex == 0 {
            let currentButton = subviews[currentIndex] as! UIButton
            currentButton.setTitleColor(redColor, for: .normal)
            currentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            return
        }
        
        if currentIndex == toIndex {
            return
        }
        
        let currentButton = subviews[currentIndex] as! UIButton
        let desButton = subviews[toIndex] as! UIButton
        
        currentButton.setTitleColor(.black, for: .normal)
        desButton.setTitleColor(redColor, for: .normal)
        currentButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        desButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        let screenMidX = kScreenWidth / 2
        let desButtonMidX = desButton.frame.minX + desButton.frame.width / 2
        let buttonScrollViewDiff = self.contentSize.width - desButtonMidX
        if buttonScrollViewDiff <= screenMidX { //如果最右边与midX的差值小于屏幕宽度的一半，滑动到最右边
            let scrollOffset = CGPoint(x: self.contentSize.width - kScreenWidth, y: 0)
            self.setContentOffset(scrollOffset, animated: true)
        } else if desButtonMidX > screenMidX {  //正常滑动
            let scrollOffset = CGPoint(x: desButtonMidX - screenMidX, y: 0)
            self.setContentOffset(scrollOffset, animated: true)
        } else if desButtonMidX <= screenMidX { //如果左边的button的midX小于屏幕宽度的一般，滑动到最左边
            let scrollOffset = CGPoint(x: 0, y: 0)
            self.setContentOffset(scrollOffset, animated: true)
        }
        
        self.currentIndex = toIndex
    }
    
    /// 调整标题的样式
    func adjustTitle(from fromIndex: Int, to toIndex: Int, scale: Float) {
        let currentButton = subviews[fromIndex] as! UIButton
        let desButton = subviews[toIndex] as! UIButton
        
        if toIndex > fromIndex {
            currentButton.setTitleColor(UIColor(red: CGFloat((1-scale) * 240 / 255.0), green: CGFloat((1-scale) * 144 / 255.0), blue: 0.0, alpha: 1), for: .normal)
            currentButton.transform = CGAffineTransform(scaleX: CGFloat(1.2 - 0.2 * scale), y: CGFloat(1.2 - 0.2 * scale))
            desButton.setTitleColor(UIColor(red: CGFloat(scale * 240 / 255.0), green: CGFloat(scale * 144 / 255.0), blue: 0.0, alpha: 1), for: .normal)
            desButton.transform = CGAffineTransform(scaleX: CGFloat(1.0 + 0.2 * scale), y: CGFloat(1.0 + 0.2 * scale))
        } else {
            desButton.setTitleColor(UIColor(red: CGFloat((1-scale) * 240 / 255.0), green: CGFloat((1-scale) * 144 / 255.0), blue: 0.0, alpha: 1), for: .normal)
            currentButton.setTitleColor(UIColor(red: CGFloat(scale * 240 / 255.0), green: CGFloat(scale * 144 / 255.0), blue: 0.0, alpha: 1), for: .normal)
            desButton.transform = CGAffineTransform(scaleX: CGFloat(1.2 - 0.2 * scale), y: CGFloat(1.2 - 0.2 * scale))
            currentButton.transform = CGAffineTransform(scaleX: CGFloat(1.0 + 0.2 * scale), y: CGFloat(1.0 + 0.2 * scale))
        }
    }
}
