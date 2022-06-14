//
//  DailyHomeVC.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit
import Alamofire
import WebKit

class DailyHomeVC: RootHomeVC {
    var infos: [KCellModel] {
        return KCellModel.dailyInfos()
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
        let titleIV = UIImageView(image: UIImage(named: "basketball"))
        titleIV.layer.cornerRadius = 10
        titleIV.clipsToBounds = true
        self.navigationItem.titleView = titleIV
        
        let deleteItem = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(pressedDeleteItem))
        self.navigationItem.leftBarButtonItem = deleteItem
        
        let toolsItem = UIBarButtonItem(title: "tools", style: .plain, target: self, action: #selector(pressedToolsItem))
        self.navigationItem.rightBarButtonItem = toolsItem
    }
    @objc func pressedDeleteItem() {
        let vc = DeleteVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func pressedToolsItem() {
        let vc = ToolsVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DailyHomeVC: MainViewDelegate {
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
