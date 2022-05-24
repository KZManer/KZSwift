//
//  WebViewVC.swift
//  KZSwift
//
//  Created by KZ on 2022/5/24.
//

import UIKit
import WebKit

class WebViewVC: RootHomeVC,ShimmerProtocol {
    
    public lazy var webView: WKWebView = {
        let webView = WKWebView.init(frame: self.view.bounds)
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
    //MARK: Override Method
    deinit {
        KLog(message: "deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        doNavUI()
        self.view.addSubview(self.webView)
        showShimmerLoading(view: self.view, frame: .zero)
        let url = URL(string: "https://cpu.baidu.com/1002/a67caf07")
        if let webUrl = url {
            let request = URLRequest(url: webUrl)
            self.webView.load(request)
        }
    }
    
    //MARK: Custom Method
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
extension WebViewVC: WKUIDelegate,WKNavigationDelegate {
    //页面开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        KLog(message: "web view start load")
    }
    //开始返回内容
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        KLog(message: "web view start return content")
    }
    //页面加载成功
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        KLog(message: "web view load success")
        hideShimmerLoading()
    }
    //页面加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        hideShimmer()
        KLog(message: "web view load failure")
        KLog(message: error)
        let code = error as NSError
        KLog(message: code.code)
    }
}
