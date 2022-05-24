//
//  DNavigationBarVC3.swift
//  KZSwift
//
//  Created by KZ on 2022/5/23.
//

import UIKit

class DNavigationBarVC3: RootHomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
