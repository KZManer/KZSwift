//
//  ThirdLibVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/14.
//

import UIKit

class ThirdLibVC: RootHomeVC {
    var infos: [KCellModel] {
        return KCellModel.thirdLibInfos()
    }
    var titles: [String] {
        return infos.map() { $0.kTitle ?? "" }
    }
    //MARK: Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        let mainView = MainView(frame: minViewFrame, source: titles)
        mainView.delegate = self
        self.view.addSubview(mainView)
    }
    
    //MARK: Custom Method
    func doNavUI() {
        let titleIV = UIImageView(image: UIImage(named: "nav_logo2"))
        titleIV.layer.cornerRadius = 10
        titleIV.clipsToBounds = true
        self.navigationItem.titleView = titleIV
    }

}
extension ThirdLibVC: MainViewDelegate {
    func dg_didSelectRowAt(index: Int) {
        let cellInfo = self.infos[index]
        guard let toVC = cellInfo.kVC else {
            self.view.makeToast("未找到对应的ViewController")
            return
        }
        toVC.hidesBottomBarWhenPushed = true
        toVC.title = cellInfo.kTitle
        self.navigationController?.pushViewController(toVC, animated: true)
    }
}
