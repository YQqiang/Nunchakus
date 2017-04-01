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
import NVActivityIndicatorView

private let videoCellID = "videoCellID"

class SelfieViewController: BaseViewController {
    
    var videoType: VideoType = .zipai
    var realUrlStr: String?
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: -1)
    fileprivate lazy var playerInfo: (String?, title: String?, cover: String?) = ("", "", "")
    
    fileprivate lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate var curPage: Int = 1
    fileprivate lazy var videos: [SelfieModel] = [SelfieModel]()
    fileprivate lazy var webViewC: WebViewController = WebViewController()
    
    let player: BMPlayer = BMPlayer()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        createMJRefresh()
        tableView.mj_header.beginRefreshing()
        preparePlayer()
        resetPlayerManager()
    }
    
    override func loadRequestData() {
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        // If use the slide to back, remember to call this method
        // 使用手势返回的时候，调用下面方法
        player.pause(allowAutoPlay: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        // If use the slide to back, remember to call this method
        // 使用手势返回的时候，调用下面方法
        player.autoPlay()
    }
    
    deinit {
        // If use the slide to back, remember to call this method
        // 使用手势返回的时候，调用下面方法手动销毁
        player.prepareToDealloc()
        print("VideoPlayViewController Deinit")
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
        
        addChildViewController(webViewC)
        view.addSubview(webViewC.view)
        webViewC.view.frame = CGRect.zero
        webViewC.getRealUrl = { [weak self] (url) -> () in
            self?.realUrlStr = url
            self?.playerInfo.0 = url
            let item = self?.preparePlayerItem(playerInfo: self?.playerInfo)
            if let item = item {
                self?.player.playWithPlayerItem(item)
            }
        }
    }
    
    fileprivate func createMJRefresh() {
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self , refreshingAction: #selector(loadNewData))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
    }
}

// MARK:- player
extension SelfieViewController {
    fileprivate func preparePlayer() {
        player.delegate = self
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        /// Listening to player state changes with Block
        //Listen to when the player is playing or stopped
        player.playStateDidChange = { (isPlaying: Bool) in
            print("| BMPlayer Block | playStateDidChange \(isPlaying)")
        }
        
        //Listen to when the play time changes
        player.playTimeDidChange = { (currentTime: TimeInterval, totalTime: TimeInterval) in
            print("| BMPlayer Block | playTimeDidChange currentTime: \(currentTime) totalTime: \(totalTime)")
        }
        
        // player.panGesture.isEnabled = false
        self.view.layoutIfNeeded()
    }
    
    fileprivate func resetPlayerManager() {
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.topBarShowInCase = .horizantalOnly
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
        BMPlayerConf.tintColor = UIColor.red
    }
    
    fileprivate func preparePlayerItem(playerInfo: (urlStr: String?, title: String?, cover: String?)?) -> BMPlayerItem? {
        guard let urlStr = playerInfo?.urlStr else {
            return nil
        }
        let resource = BMPlayerItemDefinitionItem(url: URL(string: urlStr)!,
                                                   definitionName: "标清")
        let item    = BMPlayerItem(title: playerInfo?.title ?? "",
                                   resource: [resource],
                                   cover: playerInfo?.cover ?? "")
        return item
    }
}

// MARK:- BMPlayerDelegate
extension SelfieViewController: BMPlayerDelegate {
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
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
        currentIndexPath = indexPath
        let videoModel = videos[indexPath.row]
        playerInfo.title = videoModel.title
        playerInfo.cover = videoModel.img
        if let cell = tableView.cellForRow(at: indexPath) as? VideoCell {
            player.prepareToDealloc()
            player.removeFromSuperview()
            cell.bgView.addSubview(player)
            player.frame = cell.videoFrame
        }
        let videoNum = videoModel.video?.components(separatedBy: "/").last
        videoService.request(.video(type: .v, page: Int(videoNum ?? "0") ?? 0)).mapString().showAPIErrorToast().subscribe(onNext: {[weak self] (html) in
            if let doc = HTML(html: html, encoding: .utf8) {
                let iframe = doc.at_xpath("//div[@class='playbox']/div[@class='wrap']/div[@class='play']/div[@id='a3']/iframe")
                print("iframe = \(iframe?.toHTML)")
                if let src = iframe?["src"]?.components(separatedBy: "/").last {
                    print("src = \(src)")
                    self?.webViewC.v_id = src
                }
            }
            }, onError: { (error) in
                Hud.showError(status: NSLocalizedString("视屏地址解析出错", comment: ""))
        }, onCompleted: nil) {
            }.addDisposableTo(disposeBag)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoCell else {
            return
        }
        let view = videoCell.bgView.subviews.last
        
        if currentIndexPath == indexPath {
            // 当前cell需要播放视屏
            if (view as? BMPlayer) == nil {
                videoCell.bgView.addSubview(player)
                player.frame = videoCell.videoFrame
            }
        } else {
            // 该cell为复用的cell, 需要移除播放器
            if let playerV = view as? BMPlayer {
                playerV.removeFromSuperview()
            }
        }
        
        if let visibleIndexPath = tableView.indexPathsForVisibleRows, visibleIndexPath.contains(currentIndexPath) {
            if !player.isPlaying {
                player.play()
            }
        } else {
            player.pause()
        }
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
