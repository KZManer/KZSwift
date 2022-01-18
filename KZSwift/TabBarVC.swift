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
            DailyHomeVC.init(),
            ProjectHomeVC.init(),
            TestHomeVC.init(),
        ]
        let titles = ["日常记录","项目预写","实验"]
        let picImageMiddleNames = ["home","project","test"]
        
        var controllers = [UIViewController]()
        
        var i = 0
        for title in titles {
            let vc = vcs[i]
            
            let nav = UINavigationController.init(rootViewController: vc)
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
        
    }
}
