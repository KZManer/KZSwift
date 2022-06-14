//
//  JXSegmentedVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/14.
//

import UIKit
import JXSegmentedView

class JXSegmentedVC: RootHomeVC {

//    var segmentedDataSource : JXSegmentedTitleDataSource!
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let datasource = JXSegmentedTitleDataSource()
        datasource.isTitleColorGradientEnabled = true
        datasource.titleSelectedColor = .red
        datasource.titleNormalFont = .systemFont(ofSize: 15)
        return datasource
    }()
    let segmentView = JXSegmentedView()
    var titles = ["推荐","生活","热点"]
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
//        self.segmentedDataSource = JXSegmentedTitleDataSource()
//        segmentedDataSource.isTitleColorGradientEnabled = true
//        segmentedDataSource.titleSelectedColor = .orange
//        segmentedDataSource.isTitleZoomEnabled = true
//        segmentedDataSource.titleSelectedZoomScale = 1.2
//        segmentedDataSource.isTitleMaskEnabled = true
//        segmentedDataSource.titleNormalFont = .systemFont(ofSize: titleFont)
        
        segmentView.dataSource = self.segmentedDataSource
        segmentView.delegate = self
//        segmentView.isContentScrollViewClickTransitionAnimationEnabled = false
        self.view.addSubview(segmentView)

        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        segmentView.indicators = [indicator]
        
        segmentView.listContainer = self.listContainerView
        self.view.addSubview(self.listContainerView)
        
        let rightItem1 = UIBarButtonItem(title: "数量", style: .plain, target: self, action: #selector(pressedRightItem1))
        self.navigationItem.rightBarButtonItem = rightItem1
        segmentView.defaultSelectedIndex = 0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        KLog(message: "come in")
        segmentView.frame = CGRect(x: 0, y: 0, width: width_screen, height: segmentViewHeight)
        self.listContainerView.frame = CGRect(x: 0, y: segmentViewHeight, width: width_screen, height: height_screen - segmentViewHeight)
    }
    var titleFont = 20.0
    var segmentViewHeight = 50.0
    @objc func pressedRightItem1() {
        
        segmentedDataSource.titles = self.titles
        self.segmentView.reloadData()
        return
        
        self.titles.append("社会")
        titleFont += 5
        self.segmentedDataSource.titles = self.titles
        self.segmentedDataSource.titleNormalFont = .systemFont(ofSize: titleFont)
        segmentView.defaultSelectedIndex = 0
        segmentViewHeight += 5
//        var segmentViewFrame = segmentView.frame
//        segmentViewFrame.size.height += 5
//        var listContainerViewFrame = listContainerView.frame
//        listContainerViewFrame.origin.y += 5
//        listContainerViewFrame.size.height -= 5
//        JJLog(message: segmentView.frame.size.height)
//        UIView.animate(withDuration: 0.3) {
//            self.segmentView.frame = segmentViewFrame
//            self.listContainerView.frame = listContainerViewFrame
//            self.segmentView.superview?.setNeedsLayout()
//            self.listContainerView.superview?.setNeedsLayout()
//        }
        
        segmentView.reloadData()
        view.setNeedsLayout()
    }
    
}
extension JXSegmentedVC: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
//        JJLog(message: #function)
    }
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
//        JJLog(message: #function)
    }
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
//        JJLog(message: #function)
    }
}
extension JXSegmentedVC: JXSegmentedListContainerViewDataSource {
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        KLog(message: #function)
        return ListBaseViewController()
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
}

