//
//  CircleVC.swift
//  KZSwift
//
//  Created by J+ on 2022/7/4.
//

import UIKit

class CircleVC: RootHomeVC {

    @objc func injected() {
        KLog(message: "hello")
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = 250.0
        let x = (width_screen - width)/2.0
        let slider = JXCircleSlider(frame: CGRect(x: x, y: 0, width: width, height: width))
        slider.addTarget(self, action: #selector(newValue(slider:)), for: .valueChanged)
        slider.angle = 90
        self.view.addSubview(slider)
        
        let slider1 = CircleSlider1(frame: CGRect(x: x, y: width + 50, width: width, height: width))
        slider1.filledColor = .hex("#1296db")
        slider1.unfilledColor = .hex("#cbccd1")
        slider1.minimumValue = 0
        slider1.maximumValue = 360
        slider1.value = 90
        slider1.addTarget(self, action: #selector(sliderValueDidChange(slider:)), for: .valueChanged)
        self.view.addSubview(slider1)
        
    }
    @objc private func newValue(slider: JXCircleSlider) {
        KLog(message: slider.angle)
    }
    @objc func sliderValueDidChange(slider: CircularSlider) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
