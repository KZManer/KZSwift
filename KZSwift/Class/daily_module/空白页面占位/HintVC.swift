//
//  HintVC.swift
//  KZSwift
//
//  Created by KZ on 2022/5/25.
//

import UIKit
import EmptyStateKit

class HintVC: RootHomeVC {
    lazy var hintView: JJHintView = {
        let hintView = JJHintView(frame: hintViewFrame)
        hintView.delegate = self
        return hintView
    }()
    var hintViewFrame: CGRect {
        get {
            return CGRect(x: 0, y: 0, width: width_screen, height: KTools.height_active_max())
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
    }
    func doNavUI() {
        let unknownItem = UIBarButtonItem(title: "未知", style: .plain, target: self, action: #selector(unknownItemAction))
        let noDataItem = UIBarButtonItem(title: "无数据", style: .plain, target: self, action: #selector(noDataItemAction))
        let noNetworkItem = UIBarButtonItem(title: "无网络", style: .plain, target: self, action: #selector(noNetworkItemAction))
        let loadFilureItem = UIBarButtonItem(title: "加载失败", style: .plain, target: self, action: #selector(loadFailureItemAction))
        self.navigationItem.rightBarButtonItems = [unknownItem,noDataItem,noNetworkItem,loadFilureItem]
    }
    @objc func unknownItemAction() {
        self.hintView.show(in: self.view, scene: .unknown)
    }
    @objc func noDataItemAction() {
        self.hintView.show(in: self.view, scene: .noData)
    }
    @objc func noNetworkItemAction() {
        self.hintView.show(in: self.view, scene: .noNetwork)
    }
    @objc func loadFailureItemAction() {
        self.hintView.show(in: self.view, scene: .loadFailure)
    }
}
extension HintVC: JJHintViewDelegate {
    func dg_hintViewButtonPressed(hintView: JJHintView) {
        hintView.hide()
    }
}
