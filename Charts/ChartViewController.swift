//
//  BasicViewController.swift
//  Charts
//
//  Created by gzuser on 12/4/18.
//  Copyright © 2018年 gzuser. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    var chartView = ChartView()
    var builder : (ChartBuider)->Void = {_ in }
    var note:Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        chartView.frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 200)
        view.addSubview(chartView)
        chartView.build(builder)
        note = NotificationCenter.default.addObserver(forName: .UIDeviceOrientationDidChange, object: nil, queue: nil) {[weak self] (note) in
            self?.chartView.frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 200)
            self?.chartView.setNeedsDisplay()
        }
    }
    deinit {
        if let note = note {
            NotificationCenter.default.removeObserver(note)
        }
    }
}
