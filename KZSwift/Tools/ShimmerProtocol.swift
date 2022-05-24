//
//  ShimmerProtocol.swift
//  KZSwift
//
//  Created by KZ on 2022/5/24.
//

import Foundation
import UIKit

var shimmerView: JJShimmerView?

protocol ShimmerProtocol {
    func showShimmerLoading(view: UIView,frame: CGRect?)
    func hideShimmerLoading(delay: TimeInterval)
}

extension ShimmerProtocol {
    func showShimmerLoading(view: UIView, frame: CGRect?) {
//        hideShimmerLoading()
        shimmerView?.hide()
        shimmerView = nil
        shimmerView = JJShimmerView(frame: .zero)
        shimmerView?.showInView(of: view, frame: frame)
    }

    func hideShimmerLoading(delay: TimeInterval = 0) {
        KLog(message: "进来了")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            KLog(message: "将要关闭")
            shimmerView?.hide()
            shimmerView = nil
        }
    }
}
