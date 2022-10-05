//
//  BMPlayerVC.swift
//  KZSwift
//
//  Created by KZ on 2022/10/5.
//

import UIKit
import BMPlayer
import SnapKit

class BMPlayerVC: UIViewController {
    var player = BMPlayer()
    var adView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.player)
        self.player.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.right.equalTo(self.view)
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        player.backBlock = { [unowned self] (isFullScreen) in
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let asset = BMPlayerResource(url: URL(string: "https://vd3.bdstatic.com/mda-ng0ap8xdgeb6ktxq/cae_h264/1656661066719831242/mda-ng0ap8xdgeb6ktxq.mp4")!, name:"视频测试播放")
        
//        let path = Bundle.main.resourcePath?.appending("/Resource/Video/video.mp4")
//        let localVideoURL = URL(fileURLWithPath: path!)
//        let asset = BMPlayerResource(url: localVideoURL, name: "本地视频测试")
        player.setVideo(resource: asset)
        
//        self.adView = UIView()
//        self.adView?.backgroundColor = .orange
//        self.player.addSubview(self.adView!)
//        self.adView?.snp.makeConstraints { make in
//            make.center.equalTo(self.player)
//            make.height.equalTo(self.player).multipliedBy(0.5)
//            make.width.equalTo(self.player).multipliedBy(0.5)
//        }
//        self.adView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressedAdView(gesture:))))
    }
    @objc private func pressedAdView(gesture: UITapGestureRecognizer) {
//        self.adView?.removeFromSuperview()
//        self.adView = nil
        KLog(message: "pressed ad view")
        
    }
}
