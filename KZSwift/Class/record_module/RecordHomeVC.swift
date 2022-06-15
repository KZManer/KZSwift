//
//  RecordHomeVC.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit

class RecordHomeVC: RootHomeVC {
    var infos: [KCellModel] {
        return KCellModel.testInfos()
    }
    var titles: [String] {
        return infos.map() { $0.kTitle ?? "" }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        let mainView = MainView(frame: minViewFrame, source: titles)
        mainView.delegate = self
        self.view.addSubview(mainView)
    }
    //MARK: Custom Method
    func doNavUI() {
        let titleIV = UIImageView(image: UIImage(named: "nav_logo3"))
        titleIV.layer.cornerRadius = 10
        titleIV.clipsToBounds = true
        self.navigationItem.titleView = titleIV
    }
}
extension RecordHomeVC: MainViewDelegate {
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
