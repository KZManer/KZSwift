//
//  SPPageMenuVC.swift
//  JJSwift
//
//  Created by J+ on 2022/4/22.
//

import UIKit
import SPPageMenu

class SPPageMenuVC: RootHomeVC {
    lazy var pageMenu: SPPageMenu = {
        let menu = SPPageMenu(frame: .zero, trackerStyle: .line)
        menu.delegate = self
        menu.selectedItemTitleFont = UIFont.systemFont(ofSize: 16)
        menu.unSelectedItemTitleFont = UIFont.systemFont(ofSize: 16)
        menu.selectedItemTitleColor = UIColor.red
        menu.unSelectedItemTitleColor = UIColor.black
        menu.trackerFollowingMode = SPPageMenuTrackerFollowingMode.always
        menu.permutationWay = SPPageMenuPermutationWay.scrollAdaptContent
        return menu
    }()
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.delegate = self
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let pageMenuHeight = 40.0
    
    deinit {
        KLog(message: #function)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .black
        
        /**pageMenu**/
        self.pageMenu.frame = CGRect(x: 0, y: 0, width: width_screen, height: pageMenuHeight)
        let items = ["推荐","娱乐","热点","科技","搞笑","体育","社会","推荐","娱乐","热点","科技","搞笑","体育","社会",]
        self.pageMenu.setItems(items, selectedItemIndex: 0)
        self.pageMenu.bridgeScrollView = self.scrollView
        self.view.addSubview(self.pageMenu)
        
        /**scrollView**/
        let scrollViewHeight = KTools.height_active_max() - pageMenuHeight
        self.scrollView.frame = CGRect(x: 0, y: pageMenuHeight, width: width_screen, height: KTools.height_active_max() - pageMenuHeight)
        self.view.addSubview(self.scrollView)
        for (index,_) in items.enumerated() {
            let vc = SPPageMenuChildVC()
            self.addChild(vc)
            self.scrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: width_screen * CGFloat(index), y: 0, width: width_screen, height: scrollViewHeight)
        }
        self.scrollView.contentSize = CGSize(width: Int(width_screen) * items.count, height: Int(scrollViewHeight))
        self.scrollView.contentOffset = CGPoint(x: Int(width_screen) * self.pageMenu.selectedItemIndex, y: 0)
    }
    
}

extension SPPageMenuVC: SPPageMenuDelegate {
    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedAt index: Int) {
        KLog(message: "item did select : \(index)")
    }
    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedFrom fromIndex: Int, to toIndex: Int) {
        KLog(message: "item from index:\(fromIndex) to index:\(toIndex)")
        if fromIndex == toIndex {return}
        self.scrollView.setContentOffset(CGPoint(x: Int(width_screen) * toIndex, y: 0), animated: abs(Int32(toIndex - fromIndex)) == 1)
    }
}
extension SPPageMenuVC: UIScrollViewDelegate {
    
}
