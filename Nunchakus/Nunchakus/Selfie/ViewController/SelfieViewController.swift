//
//  SelfieViewController.swift
//  Nunchakus
//
//  Created by kjlink on 2017/3/21.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import RxSwift
import EVReflection
import Kanna

private let videoCellID = "videoCellID"

class SelfieViewController: BaseViewController {
    
    fileprivate lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate var curPage: Int = 1
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        
    }
}

// MARK:- private func 
extension SelfieViewController {
    fileprivate func createUI() {
        emptyDataView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 265
        tableView.register(VideoCell.self, forCellReuseIdentifier: videoCellID)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}

// MARK:- load data 
extension SelfieViewController {
    fileprivate func loadNewData() {
        videoService.request(.video(type: .media, page: 1)).mapString().showAPIErrorToast().subscribe(onNext: {[weak self] (html) in
            if let doc = HTML(html: html, encoding: .utf8) {
                let ul = doc.xpath("//div[@class='lbox']/ul/li")
                var items: [SelfieModel] = []
                for li in ul {
                    let model = SelfieModel(html: li)
                    items.append(model)
                }
                self?.curPage += 1
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: nil) {
            }.addDisposableTo(disposeBag)
    }
    
    fileprivate func loadMoreData() {
        videoService.request(.video(type: .media, page: curPage)).mapString().showAPIErrorToast().subscribe(onNext: { (html) in
            if let doc = HTML(html: html, encoding: .utf8) {
                let ul = doc.xpath("//div[@class='lbox']/ul/li")
                var items: [SelfieModel] = []
                for li in ul {
                    let model = SelfieModel(html: li)
                    items.append(model)
                }
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: nil) {
            }.addDisposableTo(disposeBag)
    }
}

// MARK:- UITableViewDelegate
extension SelfieViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension SelfieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: videoCellID) as! VideoCell
        return cell
    }
}
