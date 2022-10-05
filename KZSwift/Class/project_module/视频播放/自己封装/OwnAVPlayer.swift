//
//  OwnAVPlayer.swift
//  KZSwift
//
//  Created by KZ on 2022/10/5.
//

import UIKit
import AVFoundation
import SnapKit

class OwnAVPlayer: UIViewController {

    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    deinit {
        self.playerItem?.removeObserver(self, forKeyPath: "status")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        doViewUI()
        
        //        let path = Bundle.main.resourcePath?.appending("/video.mp4")
        //        let url = URL(fileURLWithPath: path!)
        let url = URL(string: "https://vd3.bdstatic.com/mda-ng0ap8xdgeb6ktxq/cae_h264/1656661066719831242/mda-ng0ap8xdgeb6ktxq.mp4")
        guard let videoURL = url else { return }
        
        print("come in")
        let videoView = UIView(frame: CGRect(x: 0, y: 0, width: width_screen, height: width_screen * 9.0 / 16.0))
        self.view.addSubview(videoView)
        
        self.playerItem = AVPlayerItem(url: videoURL)
        self.player = AVPlayer(playerItem: self.playerItem)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        
        self.playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: nil, using: { time in
            KLog(message: time.value/Int64(time.timescale))
            KLog(message: self.playerItem!.duration.value / Int64(self.playerItem!.duration.timescale))
        })
        KLog(message: self.playerItem!.duration)
        
    }
    private func doViewUI() {
        let printBtn = UIButton(type: .custom)
        printBtn.setTitle("打印", for: .normal)
        printBtn.backgroundColor = .lightGray
        printBtn.addTarget(self, action: #selector(printSomething), for: .touchUpInside)
        self.view.addSubview(printBtn)
        
        let playBtn = UIButton(type: .custom)
        playBtn.setTitle("播放", for: .normal)
        playBtn.backgroundColor = .lightGray
        playBtn.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        self.view.addSubview(playBtn)
        
        let pauseBtn = UIButton(type: .custom)
        pauseBtn.setTitle("暂停", for: .normal)
        pauseBtn.backgroundColor = .lightGray
        pauseBtn.addTarget(self, action: #selector(pauseBtnPressed), for: .touchUpInside)
        self.view.addSubview(pauseBtn)
        
        let oneSpeedBtn = UIButton(type: .custom)
        oneSpeedBtn.setTitle("1x倍速", for: .normal)
        oneSpeedBtn.backgroundColor = .lightGray
        oneSpeedBtn.addTarget(self, action: #selector(oneSpeedBtnPressed), for: .touchUpInside)
        self.view.addSubview(oneSpeedBtn)
        
        let twoSpeedBtn = UIButton(type: .custom)
        twoSpeedBtn.setTitle("2x倍速", for: .normal)
        twoSpeedBtn.backgroundColor = .lightGray
        twoSpeedBtn.addTarget(self, action: #selector(twoSpeedBtnPressed), for: .touchUpInside)
        self.view.addSubview(twoSpeedBtn)
        
        playBtn.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.view)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        printBtn.snp.makeConstraints { make in
            make.bottom.equalTo(playBtn.snp.top).offset(-20)
            make.centerX.width.height.equalTo(playBtn)
        }
        
        pauseBtn.snp.makeConstraints { make in
            make.top.equalTo(playBtn.snp.bottom).offset(20)
            make.centerX.width.height.equalTo(playBtn)
        }
        
        oneSpeedBtn.snp.makeConstraints { make in
            make.top.equalTo(pauseBtn.snp.bottom).offset(20)
            make.centerX.width.height.equalTo(pauseBtn)
        }
        
        twoSpeedBtn.snp.makeConstraints { make in
            make.top.equalTo(oneSpeedBtn.snp.bottom).offset(20)
            make.centerX.width.height.equalTo(oneSpeedBtn)
        }
    }
    
    @objc private func printSomething() {
        KLog(message: self.playerItem?.status.rawValue)
        KLog(message: self.player?.status.rawValue)
    }
    @objc private func playBtnPressed() {
        self.player?.play()
    }
    @objc private func pauseBtnPressed() {
        self.player?.pause()
    }
    @objc private func oneSpeedBtnPressed() {
        self.player?.rate = 1.0
    }
    @objc private func twoSpeedBtnPressed() {
        self.player?.rate = 2.0
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if let keyValue = keyPath, keyValue == "status" {
//            KLog(message: change)
//        }
        if let obj = object as? AVPlayerItem,keyPath == "status" {
            KLog(message: change)
            switch obj.status {
            case .unknown:
                break
            case .readyToPlay:
                self.player?.play()
            case .failed:
                break
            default:
                break
            }
        }
    }
}

