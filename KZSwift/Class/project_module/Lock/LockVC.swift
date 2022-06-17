//
//  LockVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/15.
//

import UIKit

class LockVC: RootHomeVC {
    lazy var homeView: LockView = {
        let view = LockView(frame: CGRect(x: 0, y: 0, width: width_screen, height: height_screen))
        view.delegate = self
        return view
    }()
    //MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        doViewUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        nav_navigationBarHide()
    }

    //MARK: - Custom Method
    func doViewUI() {
        self.view.addSubview(homeView)
        homeView.echoTitle(text: "70")
    }
}
extension LockVC: LockViewDelegate {
    func dg_pressedMenuBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    func dg_pressedBeginBtn() {
        self.view.makeToast("点击了开始按钮")
    }
}
