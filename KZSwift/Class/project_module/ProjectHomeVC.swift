//
//  ProjectHomeVC.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit

class ProjectHomeVC: RootHomeVC {
    var infos: [KCellModel] {
        return KCellModel.projectInfos()
    }
    var titles: [String] {
        return infos.map(){ $0.kTitle ?? "" }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        let mainView = MainView(frame: minViewFrame, source: titles)
        mainView.delegate = self
        mainView.backgroundColor = .lightGray
        self.view.addSubview(mainView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nav_navigationBarShow()
    }
    //MARK: Custom Method
    func doNavUI() {
        
        let titleIV = UIImageView(image: UIImage(named: "nav_logo1"))
        titleIV.layer.cornerRadius = 10
        titleIV.clipsToBounds = true
        self.navigationItem.titleView = titleIV
    }
}

extension ProjectHomeVC: MainViewDelegate {
    func dg_didSelectRowAt(index: Int) {
        let cellInfo = self.infos[index]
        
        guard let cls = cellInfo.kCls else {
            self.view.makeToast("未找到对应的ViewController")
            return
        }
        let toVC = cls.init()
        toVC.hidesBottomBarWhenPushed = true
        toVC.title = cellInfo.kTitle
        self.navigationController?.pushViewController(toVC, animated: true)
    }
}
