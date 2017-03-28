//
//  SelfieViewController.swift
//  Nunchakus
//
//  Created by kjlink on 2017/3/21.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import RxSwift
import Kanna
import MJRefresh
import BMPlayer

private let videoCellID = "videoCellID"

class SelfieViewController: BaseViewController {
    
    var videoType: VideoType = .zipai
    
    fileprivate lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate var curPage: Int = 1
    fileprivate lazy var videos: [SelfieModel] = [SelfieModel]()
    
    let player: BMPlayer = BMPlayer()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        createMJRefresh()
        tableView.mj_header.beginRefreshing()
    }
    
    override func loadRequestData() {
        tableView.mj_header.beginRefreshing()
    }
}

// MARK:- private func 
extension SelfieViewController {
    fileprivate func createUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(videoHeight + 22.0)
        tableView.separatorStyle = .none
        tableView.register(VideoCell.self, forCellReuseIdentifier: videoCellID)
        view.addSubview(tableView)
        // 顶部预留间距
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        tableView.contentOffset = CGPoint(x: 0, y: -8)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    fileprivate func createMJRefresh() {
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self , refreshingAction: #selector(loadNewData))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
    }
}

// MARK:- load data 
extension SelfieViewController {
    @objc fileprivate func loadNewData() {
        videoService.request(.video(type: videoType, page: 1)).mapString().showAPIErrorToast().subscribe(onNext: {[weak self] (html) in
            if let doc = HTML(html: html, encoding: .utf8) {
                let ul = doc.xpath("//div[@class='lbox']/ul/li")
                self?.videos.removeAll()
                for li in ul {
                    let model = SelfieModel(html: li)
                    self?.videos.append(model)
                }
                self?.curPage += 1
                let page = doc.xpath("//div[@class='pagebar']/a")
                let isNext = SelfieModel.isHaveNextPage(html: page)
                if !isNext {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self?.tableView.mj_footer.endRefreshing()
                }
            }
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.reloadData()
        }, onError: {[weak self] (error) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }, onCompleted: nil) {
            }.addDisposableTo(disposeBag)
    }
    
    @objc fileprivate func loadMoreData() {
        videoService.request(.video(type: videoType, page: curPage)).mapString().showAPIErrorToast().subscribe(onNext: {[weak self] (html) in
            if let doc = HTML(html: html, encoding: .utf8) {
                let ul = doc.xpath("//div[@class='lbox']/ul/li")
                for li in ul {
                    let model = SelfieModel(html: li)
                    self?.videos.append(model)
                }
                self?.curPage += 1
                let page = doc.xpath("//div[@class='pagebar']/a")
                let isNext = SelfieModel.isHaveNextPage(html: page)
                if !isNext {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self?.tableView.mj_footer.endRefreshing()
                }
            }
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.reloadData()
        }, onError: {[weak self] (error) in
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.mj_footer.endRefreshing()
        }, onCompleted: nil) {
            }.addDisposableTo(disposeBag)
    }
}

// MARK:- UITableViewDelegate
extension SelfieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let videoModel = videos[indexPath.row]
        let videoNum = videoModel.video?.components(separatedBy: "/").last
        videoService.request(.video(type: .v, page: Int(videoNum ?? "0") ?? 0)).mapString().showAPIErrorToast().subscribe(onNext: {[weak self] (html) in
            if let doc = HTML(html: html, encoding: .utf8) {
                let iframe = doc.at_xpath("//div[@class='playbox']/div[@class='wrap']/div[@class='play']/div[@id='a3']/iframe")
                print("iframe = \(iframe?.toHTML)")
                if let src = iframe?["src"]?.components(separatedBy: "/").last {
                    print("src = \(src)")
                }
//                let webView = WebViewController()
//                webView.html = iframe?.toHTML
//                _ = self?.navigationController?.pushViewController(webView, animated: true)
            }
            }, onError: { (error) in
        }, onCompleted: nil) {
            }.addDisposableTo(disposeBag)
    }
}

// MARK: - UITableViewDataSource
extension SelfieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyDataView.isHidden = self.videos.count > 0
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: videoCellID) as! VideoCell
        cell.videoModel = videos[indexPath.row]
        return cell
    }
}
