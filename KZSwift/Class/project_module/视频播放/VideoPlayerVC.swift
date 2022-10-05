//
//  VideoPlayerVC.swift
//  KZSwift
//
//  Created by KZ on 2022/10/5.
//

import UIKit

class VideoPlayerVC: RootHomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        let mainView = MainView(frame: self.view.bounds, source: ["自己封装AVPlayer","3rd-BMPlayer","3rd-JJPlayer"])
        mainView.delegate = self
        self.view.addSubview(mainView)
    }
}
extension VideoPlayerVC: MainViewDelegate {
    func dg_didSelectRowAt(index: Int) {
        if index == 0 {
            self.navigationController?.pushViewController(OwnAVPlayer(), animated: true)
        } else if index == 1 {
            self.navigationController?.pushViewController(BMPlayerVC(), animated: true)
        } else if index == 2 {
            self.navigationController?.pushViewController(JJPlayerVC(), animated: true)
        }
    }
}
