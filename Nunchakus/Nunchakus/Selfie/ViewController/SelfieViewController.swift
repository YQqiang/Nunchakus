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
import Toaster

enum VideoType {
    case zipai      // 棍友自拍
    case biaoyan    // 舞台表演
    case jiaoxue    // 棍法教学
    case media      // 媒体关注
    case movie      // 影视动画
    case guowai     // 国外聚焦
    case paoku      // 极限跑酷
    case v          // 播放视屏
}

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
    fileprivate lazy var fullScreenVC: FullScreenPlayerController = FullScreenPlayerController()
    fileprivate lazy var isPlayForCellular: Bool = false
    var netStatus: NetStatus {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return .notNet
        }
        return appDelegate.netStatus
    }
    var willShowFullScreen: Bool = false
    var player: BMPlayer!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = .flexibleBottomMargin
        createUI()
        createMJRefresh()
        tableView.mj_header.beginRefreshing()
        setPlayerManager()
        preparePlayer()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func loadRequestData() {
        tableView.mj_header.beginRefreshing()
    }
    
    deinit {
        player.prepareToDealloc()
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
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        addChildViewController(webViewC)
        view.addSubview(webViewC.view)
        webViewC.view.frame = CGRect.zero
        webViewC.getRealUrl = { [weak self] (url) -> () in
            self?.realUrlStr = url
            self?.playerInfo.0 = url
            let asset = self?.preparePlayerItem(playerInfo: self?.playerInfo)
            if let asset = asset {
                self?.player.setVideo(resource: asset)
            }
        }
    }
    
    fileprivate func createMJRefresh() {
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self , refreshingAction: #selector(loadNewData))
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
    }
    
    fileprivate func reachabilityAction() {
        let alertVC = UIAlertController(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("您当前正在使用2G/3G/4G网络, 是否继续播放?", comment: ""), preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("取消播放", comment: ""), style: .cancel) { (action) in
            self.isPlayForCellular = false
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        let confirm = UIAlertAction(title: NSLocalizedString("继续播放", comment: ""), style: .default) { (action) in
            self.isPlayForCellular = true
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        alertVC.addAction(cancel)
        alertVC.addAction(confirm)
        present(alertVC, animated: true, completion: nil)
        CFRunLoopRun()
    }
}

// MARK:- player
extension SelfieViewController {
    fileprivate func preparePlayer() {
        let playerControlView = PlayerControlView()
        playerControlView.fullScreenBlock = {[weak self] (isFullScreen) in
            print("全屏或缩放----\(isFullScreen)")
            guard let player = self?.player else {
                return
            }
            guard let _ = player.superview else {
                return
            }
            guard let fullScreenVC = self?.fullScreenVC else {
                return
            }
            guard let currentIndexPath = self?.currentIndexPath else {
                return
            }
            if isFullScreen, self?.fullScreenVC.presentingViewController == nil {
                self?.fullScreenVC.view.addSubview(player)
                player.snp.remakeConstraints { (make) in
                    make.top.equalTo((self?.fullScreenVC.view.snp.top)!)
                    make.left.equalTo((self?.fullScreenVC.view.snp.left)!)
                    make.right.equalTo((self?.fullScreenVC.view.snp.right)!)
                    make.height.equalTo((self?.fullScreenVC.view.snp.width)!).multipliedBy(9.0/16.0)
                }
                self?.willShowFullScreen = true
                self?.present(fullScreenVC, animated: true, completion: nil)
            } else if !isFullScreen, let _ = self?.fullScreenVC.presentingViewController {
                self?.fullScreenVC.dismiss(animated: true, completion: nil)
                if let cell = self?.tableView.cellForRow(at: currentIndexPath) as? VideoCell {
                    cell.bgView.addSubview(player)
                    player.snp.remakeConstraints { (make) in
                        make.edges.equalTo(cell.imgV)
                    }
                }
            }
        }
        player = BMPlayer(customControllView: playerControlView)
        player.delegate = self
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        player.playStateDidChange = { (isPlaying: Bool) in
        }
        
        player.playTimeDidChange = { (currentTime: TimeInterval, totalTime: TimeInterval) in
        }
        
         player.panGesture.isEnabled = false
        self.view.layoutIfNeeded()
    }
    
    fileprivate func setPlayerManager() {
        BMPlayerConf.allowLog = false
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.topBarShowInCase = .horizantalOnly
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballRotateChase
        BMPlayerConf.tintColor = UIColor.globalColor()
    }
    
    fileprivate func preparePlayerItem(playerInfo: (urlStr: String?, title: String?, cover: String?)?) -> BMPlayerResource? {
        guard let urlStr = playerInfo?.urlStr else {
            return nil
        }
        let resource = BMPlayerResourceDefinition(url: URL(string: urlStr)!,
                                                   definition: "标清")
        let asset    = BMPlayerResource(name: playerInfo?.title ?? "",
                                   definitions: [resource],
                                   cover: URL(string: playerInfo?.cover ?? ""))
        return asset
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
                player.snp.remakeConstraints { (make) in
                    make.edges.equalTo(videoCell.imgV)
                }
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
        cell.playClosure = {[weak self] in
            if self?.currentIndexPath == indexPath, self?.player.superview != nil {
                return
            }
            if self?.netStatus == .notNet {
                Toast(text: NSLocalizedString("当前网络不可用", comment: "")).show()
                return
            }
            if self?.netStatus == .cellularNet{
                self?.reachabilityAction()
                if !(self?.isPlayForCellular)! {
                    return
                }
            }
            self?.currentIndexPath = indexPath
            tableView.deselectRow(at: indexPath, animated: false)
            let videoModel = self?.videos[indexPath.row]
            self?.playerInfo.title = videoModel?.title
            self?.playerInfo.cover = videoModel?.img
            if let cell = tableView.cellForRow(at: indexPath) as? VideoCell {
                self?.player.prepareToDealloc()
                self?.player.removeFromSuperview()
                cell.bgView.addSubview((self?.player)!)
                self?.player.snp.remakeConstraints { (make) in
                    make.edges.equalTo(cell.imgV)
                }
            }
            let videoNum = videoModel?.video?.components(separatedBy: "/").last
            videoService.request(.video(type: .v, page: Int(videoNum ?? "0") ?? 0)).mapString().showAPIErrorToast().subscribe(onNext: {[weak self] (html) in
                if let doc = HTML(html: html, encoding: .utf8) {
                    let iframe = doc.at_xpath("//div[@class='playbox']/div[@class='wrap']/div[@class='play']/div[@id='a3']/iframe")
                    print("iframe = \(iframe?.toHTML)")
                    if let src = iframe?["src"]?.components(separatedBy: "/").last {
                        print("src = \(src)")
                        self?.webViewC.v_id = src
                    }
                }
                }, onError: {[weak self] (error) in
                    self?.player.prepareToDealloc()
                    self?.player.removeFromSuperview()
                    Hud.showError(status: NSLocalizedString("视屏加载失败, 请检查网络是否可用", comment: ""))
            }, onCompleted: nil) {
                }.addDisposableTo((self?.disposeBag)!)
        }
        cell.videoModel = videos[indexPath.row]
        return cell
    }
}
