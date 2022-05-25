//
//  RootNavigationController.swift
//  KZSwift
//
//  Created by KZ on 2022/5/23.
//

import UIKit


class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }
}


extension RootNavigationController {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count < 2 {
            return false
        }
        return true
    }
}
