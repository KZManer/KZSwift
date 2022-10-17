//
//  YilanVideoVC.swift
//  KZSwift
//
//  Created by J+ on 2022/10/10.
//

import UIKit

class YilanVideoVC: RootHomeVC {

    private lazy var tableView: UITableView = {
        //80为两个titleview的高
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width_screen, height: KTools.height_active_max()), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(JJEmptyCell.self, forCellReuseIdentifier: JJEmptyCell.CellId)
        tableView.register(JJYilanVideoCell.self, forCellReuseIdentifier: JJYilanVideoCell.CellId)
        tableView.register(JJYilanLVideoCell.self, forCellReuseIdentifier: JJYilanLVideoCell.CellId)
        tableView.register(JJYilanDetailVideoInfoCell.self, forCellReuseIdentifier: JJYilanDetailVideoInfoCell.CellId)
        tableView.register(JJAdTopTextThreeImageCell.self, forCellReuseIdentifier: JJAdTopTextThreeImageCell.CellId)
        tableView.register(JJAdLImageRTextCell.self, forCellReuseIdentifier: JJAdLImageRTextCell.CellId)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    
    lazy var bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    var unfoldCell = false
    private var isExcutingBannerAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.view.addSubview(self.tableView)
        KLog(message: "\(bannerView.frame.origin.y) - \(bannerView.frame.size.height)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bannerViewH = 160.0
        bannerView.frame = CGRect(x: 0, y: self.view.frame.size.height - bannerViewH, width: width_screen, height: bannerViewH)
        self.view.addSubview(bannerView)
        KLog(message: "\(bannerView.frame.origin.y) - \(bannerView.frame.size.height)")
    }
}
extension YilanVideoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = "乌军第N次赫尔松“大反攻”，俄军真的快扛不住了，但是还没输"
//        let title = "乌军"
        let imageLink = "https://img.yilanvaas.com/3a1b/20221009/d0fac0cac5c65389ad2953b614edde53!open_largepgc?a=ylczxbf3pwx5&d=91494BAC839BE5DAFB94E443A5F60DBB41463CE233D4CA1EC026A6DDC00A2D94&t=cover&v=m5Pm4nZx2Lyn"
        let source = "前沿国际观察"
        let headPortrait = "https://img.yilanvaas.com/00000001/user/feee6dc46939b8ec90dcdf75cc4e83da.png!open_middlecp"
//        let headPortrait = "https://img.yilanvaas.com/3a1b/20221009/d0fac0cac5c65389ad2953b614edde53!open_largepgc?a=ylczxbf3pwx5&d=91494BAC839BE5DAFB94E443A5F60DBB41463CE233D4CA1EC026A6DDC00A2D94&t=cover&v=m5Pm4nZx2Lyn"
        let playCount = 14323
        let videoTime = 187000
        if indexPath.row == 0 {
            let cell:JJYilanVideoCell = tableView.dequeueReusableCell(withIdentifier: JJYilanVideoCell.CellId, for: indexPath) as! JJYilanVideoCell
            cell.echoContent(title: title, imageLink: imageLink,videoTime: videoTime, source: source, headPortrait: headPortrait, playCount: playCount)
            return cell
        }
        if indexPath.row == 1 {
            let cell: JJYilanLVideoCell = tableView.dequeueReusableCell(withIdentifier: JJYilanLVideoCell.CellId, for: indexPath) as! JJYilanLVideoCell
            cell.echoContent(title: title, imageLink: imageLink, videoDuration: videoTime, author: source, headPortrait: headPortrait, playCount: playCount)
            return cell
        }
        if indexPath.row == 2 {
            let cell: JJYilanDetailVideoInfoCell = tableView.dequeueReusableCell(withIdentifier: JJYilanDetailVideoInfoCell.CellId, for: indexPath) as! JJYilanDetailVideoInfoCell
            cell.echoContent(title: "正在播放的视频的标题正在播放正在播放的视频的标题正在播放正在播放的视频的标题正在播放正在播放的视频的标题正在播放正在播放的视频的标题正在播放正在播放的视频的标题正在播放", playCount: 100234, unfold: unfoldCell)
            return cell
        }
        if indexPath.row == 3 {
            let cell: JJAdTopTextThreeImageCell = tableView.dequeueReusableCell(withIdentifier: JJAdTopTextThreeImageCell.CellId, for: indexPath) as! JJAdTopTextThreeImageCell
            let il = "https://lupic.cdn.bcebos.com/20191130/3000005115%2320.jpg"
            let imageLinks = [il,il,il]
            let logo1 = "https://cpro.baidustatic.com/cpro/logo/sdk/new-bg-logo.png"
            let logo2 = "https://cpro.baidustatic.com/cpro/logo/sdk/mob-adIcon_2x.png"
            cell.echoContent(title: "上眼凹陷填充", imageLinks: imageLinks, source: "精选推荐", logoLink1: logo1, logoLink2: logo2)
            return cell
        }
        if indexPath.row == 4 {
            let cell: JJAdLImageRTextCell = tableView.dequeueReusableCell(withIdentifier: JJAdLImageRTextCell.CellId, for: indexPath) as! JJAdLImageRTextCell
            let il = "https://lupic.cdn.bcebos.com/20191130/3000005115%2320.jpg"
            let logo1 = "https://cpro.baidustatic.com/cpro/logo/sdk/new-bg-logo.png"
            let logo2 = "https://cpro.baidustatic.com/cpro/logo/sdk/mob-adIcon_2x.png"
            cell.echoContent(title: "上眼凹陷填充", imageLink: il, author: "精选推荐", logoLink1: logo1, logoLink2: logo2)
            return cell
        }
        
        let cell: JJEmptyCell = tableView.dequeueReusableCell(withIdentifier: JJEmptyCell.CellId, for: indexPath) as! JJEmptyCell
        cell.contentView.backgroundColor = .randomColor()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        KLog(message: "click")
        if indexPath.row == 2 {
            unfoldCell = !unfoldCell
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        handleScrollStopImpression()
    }
    //滑动停止后，检查当前可见区域内的cell来发送展现
    private func handleScrollStopImpression() {
        /**
         NSArray *visiblePath = [self.tableView indexPathsForVisibleRows];
         for (NSIndexPath *visible in visiblePath) {
             if ([self.adViewArray count]> visible.row) {
                 BaiduMobAdNativeAdObject *object = [self.adsArray objectAtIndex:visible.row];
                 BaiduMobAdNativeAdView *view = [self.adViewArray objectAtIndex:visible.row];
                 // 确定视图显示在window上之后再调用trackImpression，不要太早调用
                 // 在tableview或scrollview中使用时尤其要注意
                 [object trackImpression:view];
             }
         }
         */
        if let visiblePath = self.tableView.indexPathsForVisibleRows {
            for visible in visiblePath {
//                KLog(message: visible.row)
            }
        }
//        for visible in visiblePath {
//
//        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //用于记录列表上滑还是下滑
        let point = scrollView.panGestureRecognizer.translation(in: self.view)
        let fingerUpward = point.y < 0
        if isExcutingBannerAnimation { return }
        var frame = self.bannerView.frame
        KLog(message: "\(frame.origin.y) - \(frame.size.height)")
        if fingerUpward {
            //上滑
            frame.origin.y = self.view.frame.size.height
        } else {
            //下滑
            frame.origin.y = self.view.frame.size.height - frame.size.height
        }
        KLog(message: "\(frame.origin.y) - \(frame.size.height)")
        UIView.animate(withDuration: 0.8) {
            self.bannerView.frame = frame
            self.isExcutingBannerAnimation = true
        } completion: { finish in
            self.isExcutingBannerAnimation = false
        }
    }
}
