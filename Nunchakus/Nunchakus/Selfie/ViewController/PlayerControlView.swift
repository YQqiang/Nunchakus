//
//  PlayerControlView.swift
//  Nunchakus
//
//  Created by sungrow on 2017/4/14.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import BMPlayer

class PlayerControlView: BMPlayerControlView {
    
    var playbackRateButton = UIButton(type: .custom)
    var playRate: Float = 1.0
    var fullScreenBlock: ((_ isFullScreen: Bool) -> (Void))?
    
    /**
     Override if need to customize UI components
     */
    override func customizeUIComponents() {
        mainMaskView.backgroundColor   = UIColor.clear
//        topMaskView.backgroundColor    = UIColor.black.withAlphaComponent(0.4)
//        bottomMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        topMaskView.addSubview(playbackRateButton)
        
        playbackRateButton.layer.cornerRadius = 2
        playbackRateButton.layer.borderWidth  = 1
        playbackRateButton.layer.borderColor  = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8 ).cgColor
        playbackRateButton.setTitleColor(UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9 ), for: .normal)
        playbackRateButton.setTitle("  rate \(playRate)  ", for: .normal)
        playbackRateButton.addTarget(self, action: #selector(onPlaybackRateButtonPressed), for: .touchUpInside)
        playbackRateButton.titleLabel?.font   = UIFont.systemFont(ofSize: 12)
        playbackRateButton.isHidden = true
        playbackRateButton.snp.makeConstraints {
            $0.right.equalTo(chooseDefitionView.snp.left).offset(-5)
            $0.centerY.equalTo(chooseDefitionView)
        }
    }
    
    override func updateUI(_ isForFullScreen: Bool) {
        super.updateUI(isForFullScreen)
        playbackRateButton.isHidden = !isForFullScreen
        guard let fullScreenBlock = fullScreenBlock else {
            return
        }
        fullScreenBlock(isFullscreen)
    }
    
    override func controlViewAnimation(isShow: Bool) {
        self.isMaskShowing = isShow
//        UIApplication.shared.setStatusBarHidden(!isShow, with: .fade)
        
        UIView.animate(withDuration: 0.24, animations: {
            self.topMaskView.snp.remakeConstraints {
                $0.top.equalTo(self.mainMaskView).offset(isShow ? 0 : -65)
                $0.left.right.equalTo(self.mainMaskView)
                $0.height.equalTo(65)
            }
            
            self.bottomMaskView.snp.remakeConstraints {
                $0.bottom.equalTo(self.mainMaskView).offset(isShow ? 0 : 50)
                $0.left.right.equalTo(self.mainMaskView)
                $0.height.equalTo(50)
            }
            self.layoutIfNeeded()
        }) { (_) in
            self.autoFadeOutControlViewWithAnimation()
        }
    }
    
    @objc func onPlaybackRateButtonPressed() {
        autoFadeOutControlViewWithAnimation()
        switch playRate {
        case 1.0:
            playRate = 1.5
        case 1.5:
            playRate = 0.5
        case 0.5:
            playRate = 1.0
        default:
            playRate = 1.0
        }
        playbackRateButton.setTitle("  rate \(playRate)  ", for: .normal)
        delegate?.controlView?(controlView: self, didChangeVideoPlaybackRate: playRate)
    }
}
