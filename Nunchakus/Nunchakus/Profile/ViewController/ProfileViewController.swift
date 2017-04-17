//
//  ProfileViewController.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/7.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import Kingfisher
import Toaster

let cellID = "cell"
let imageHeight: CGFloat = 240

class ProfileViewController: BaseViewController {

    fileprivate lazy var iconImageV: UIImageView = UIImageView()
    fileprivate lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    fileprivate var dataItems: [[String]] = {
       return [["清除缓存"], ["关于", "反馈", "联系作者"]]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataView.isHidden = true
        navigationItem.title = "我的"
        createUI()
    }

}

extension ProfileViewController {
    fileprivate func createUI() {
        tableView.addSubview(iconImageV)
        iconImageV.image = UIImage(named: "webwxgetmsgimg (12)")
        iconImageV.frame = CGRect(x: 0, y: -imageHeight, width: UIScreen.main.bounds.size.width, height: imageHeight)
        iconImageV.contentMode = .scaleAspectFill
        tableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK:- UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < -imageHeight {
            iconImageV.frame = CGRect(x: iconImageV.frame.origin.x, y: offsetY, width: iconImageV.frame.width, height: -offsetY)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let alertVC = UIAlertController(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("确定清除缓存?", comment: ""), preferredStyle: .alert)
            let cancel = UIAlertAction(title: NSLocalizedString("取消", comment: ""), style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .destructive, handler: { (action) in
                let cache = KingfisherManager.shared.cache
                cache.clearDiskCache()//清除硬盘缓存
                cache.clearMemoryCache()//清理网络缓存
                cache.cleanExpiredDiskCache()//清理过期的，或者超过硬盘限制大小的
                Toast(text: NSLocalizedString("清理成功", comment: "")).show()
            })
            alertVC.addAction(cancel)
            alertVC.addAction(confirm)
            present(alertVC, animated: true, completion: nil)
            
            break
            
        case (1, 0):
            navigationController?.pushViewController(LicenseViewController(), animated: true)
            break
            
        case (1, 1):
            let alertVC = UIAlertController(title: NSLocalizedString("感谢您的反馈", comment: ""), message: NSLocalizedString("请联系作者, 进行反馈", comment: ""), preferredStyle: .alert)
            let cancel = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .cancel, handler: nil)
            alertVC.addAction(cancel)
            present(alertVC, animated: true, completion: nil)
            break
            
        case (1, 2):
            let alertVC = UIAlertController(title: NSLocalizedString("QQ", comment: ""), message: NSLocalizedString("1054572107\n余强", comment: ""), preferredStyle: .alert)
            let cancel = UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .cancel, handler: nil)
            alertVC.addAction(cancel)
            present(alertVC, animated: true, completion: nil)
            break
            
        default:
            break
        }
    }
}

// MARK:- UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        cell?.textLabel?.text = dataItems[indexPath.section][indexPath.row]
        return cell!
    }
}

