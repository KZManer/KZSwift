//
//  TimerVC.swift
//  KZSwift
//
//  Created by J+ on 2022/6/15.
//

import UIKit

class TimerVC: RootHomeVC {
    
    lazy var countdownLabel: UILabel = {
        let space = 200.0
        let x = (width_screen - space)/2
        let y = KTools.height_active_max() - space - 50.0
        let label = UILabel(frame: CGRect(x: x, y: y, width: space, height: space))
        label.font = .boldSystemFont(ofSize: 60)
        label.text = "Ready"
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let templateFrame = CGRect(x: 0, y: 0, width: width_screen, height: 300)
        let templateView = TemplateView(frame: templateFrame, titles: ["开启","停止"])
        templateView.layer.shadowColor = UIColor.red.cgColor
        templateView.delegate = self
        self.view.addSubview(templateView)
        
        let cdView = UIView(frame: countdownLabel.frame)
        self.view.addSubview(cdView)
        
        countdownLabel.frame = cdView.bounds
        cdView.addSubview(countdownLabel)
        
        countdownLabel.layer.cornerRadius = 10
        countdownLabel.layer.masksToBounds = true
        
        cdView.layer.shadowColor = UIColor.lightGray.cgColor
        cdView.layer.shadowRadius = 10
        cdView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cdView.layer.shadowOpacity = 1.0
    }
    override func viewDidDisappear(_ animated: Bool) {
        KTimer.shared.stopCountdown()
    }
    var thread: Thread?
    func button1Action() {
     
        KTimer.shared.startCountdown(duration: 5) { countdown, finish in
            self.countdownLabel.textColor = .randomColor()
            if finish {
                self.countdownLabel.text = "Over"
                self.view.makeToast("倒计时结束", position:.center)
            } else {
                self.countdownLabel.text = "\(countdown)"
            }
        }
    }
    func button2Action() {
        KTimer.shared.stopCountdown()
    }
}
extension TimerVC: TemplateViewDelegate {
    func dg_buttonPressed(index: Int, title: String) {
        switch index+1 {
        case 1: button1Action()
        case 2: button2Action()
        default: break
        }
    }
}
