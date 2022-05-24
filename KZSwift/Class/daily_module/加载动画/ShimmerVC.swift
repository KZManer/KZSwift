//
//  ShimmerVC.swift
//  KZSwift
//
//  Created by KZ on 2022/5/24.
//

import UIKit
import WebKit

class ShimmerVC: RootHomeVC,ShimmerProtocol {
    var shimmerView: JJShimmerView?
    public lazy var webView: WKWebView = {
        let webView = WKWebView.init(frame: self.view.bounds)
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        self.view.addSubview(self.webView)
        showShimmerLoading(view: self.view, frame: nil)
        let url = URL(string: "https://www.jianshu.com/u/e3aa3c3b5994")
        if let webUrl = url {
            let request = URLRequest(url: webUrl)
            self.webView.load(request)
        }
    }
    func doNavUI() {
        let showShimmerItem = UIBarButtonItem(title: "show", style: .plain, target: self, action: #selector(showItemAction))
        let hideShimmerItem = UIBarButtonItem(title: "hide", style: .plain, target: self, action: #selector(hideItemAction))
        self.navigationItem.rightBarButtonItems = [hideShimmerItem,showShimmerItem]
    }
    @objc func showItemAction() {
        showShimmerLoading(view: self.view, frame: nil)
    }
    @objc func hideItemAction() {
        hideShimmerLoading()
    }
}
extension ShimmerVC: WKUIDelegate,WKNavigationDelegate {
    //页面开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        KLog(message: "页面开始加载")
    }
    //开始返回内容
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        KLog(message: "页面开始返回内容")
    }
    //页面加载成功
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        KLog(message: "页面加载成功")
        hideShimmerLoading()
    }
    //页面加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        KLog(message: "页面加载失败")
        hideShimmerLoading()
    }
}
