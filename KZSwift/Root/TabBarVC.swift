//
//  TabBarVC.swift
//  KZSwift
//
//  Created by Zzz... on 2022/1/18.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vcs = [
            DailyHomeVC(),
            ThirdLibVC(),
            ProjectHomeVC(),
            RecordHomeVC(),
        ]
        let titles = ["daily","3rd_lib","pre-writing","record"]
        let picImageMiddleNames = ["home","3rd","project","record"]
        
        var controllers = [UIViewController]()
        
        var i = 0
        for title in titles {
            let vc = vcs[i]
            
            let nav = RootNavController.init(rootViewController: vc)
            //默认展示图片
            nav.tabBarItem.image = UIImage.init(named: "tabbar_nor_" + picImageMiddleNames[i])?.withRenderingMode(.alwaysOriginal)
            //选中时的图片
            nav.tabBarItem.selectedImage = UIImage.init(named: "tabbar_sel_" + picImageMiddleNames[i])?.withRenderingMode(.alwaysOriginal)
            //导航栏标题
            vc.title = title
            
            controllers.append(nav)
            i+=1
        }
        self.viewControllers = controllers
        self.selectedIndex = 2
    }
}
