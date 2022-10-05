//
//  JJPlayerVC.swift
//  KZSwift
//
//  Created by KZ on 2022/10/5.
//

import UIKit


class JJPlayerVC: UIViewController {
    
    lazy var playerView: JJPlayerView = {
        let playerView = JJPlayerView(frame: CGRect(x: 0, y: 0, width: width_screen, height: width_screen * 9.0/16.0))
        return playerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        doNavUI()
        self.view.addSubview(self.playerView)
        self.playerView.updatePlayerModifyConfigure { config in
            config.strokeColor = UIColor.white
            config.topToolBarHiddenType = .always
            config.isLandscape = false //是否允许全屏播放
        }
        //本地视频
//        if let videoPath = Bundle.main.path(forResource: "video", ofType: "mp4") {
//            self.playerView.url = URL.init(fileURLWithPath: videoPath)
//            self.playerView.play()
//        }
        //网络视频
        let videoPath = String.randomNetworkVideoPath()
        if let url = URL(string: videoPath) {
            self.playerView.url = url
            self.playerView.play()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.playerView.destoryPlayer()
        KLog(message: "view did disappear")
    }
    
    private func doNavUI() {
        let backItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"), style: .plain, target: self, action: #selector(backItemPressed))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc private func backItemPressed() {
        self.playerView.destoryPlayer()
        self.navigationController?.popViewController(animated: true)
    }
}
