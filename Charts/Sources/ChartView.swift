//
//  ChartView.swift
//  Charts
//
//  Created by gzuser on 12/4/18.
//  Copyright © 2018年 gzuser. All rights reserved.
//

import UIKit
protocol Drawable : NSObjectProtocol {
    var drawCommands:[DrawCommand] {get set}
    var frame : CGRect { get set}
    var minXValue : CGFloat {get set}
    var maxXValue : CGFloat {get set}
    var minYValue : CGFloat {get set}
    var maxYValue : CGFloat {get set}
}

extension Drawable {
    func point(for value:(x:CGFloat,y:CGFloat)) -> CGPoint {
        let xPosition = (minXValue - value.x) / (minXValue - maxXValue) *  frame.size.width
        let yPosition = frame.size.height - (minYValue - value.y) / (minYValue - maxYValue) *  frame.size.height
        return CGPoint(x: xPosition, y: yPosition)
    }
}

class ChartView: UIView,Drawable {
    
    /// 绘图命令数组
    var drawCommands = [DrawCommand]()

    
    
    /// 建造者
    lazy var builder:ChartBuider = {
        let builder = ChartBuider()
        builder.target = self
        return builder
    }()
    
    func build(_ block:(ChartBuider)->Void) {
        block(builder)
        builder.finish()
    }
    
    /// 绘图
    ///
    /// - Parameter rect: 矩形
    override func draw(_ rect: CGRect) {
        let date = Date()
        if let ctx = UIGraphicsGetCurrentContext() {
            drawCommands.forEach({ (cmd) in
                cmd.draw(at: self, context: ctx, rect: rect)
            })
        }
        let drawTime = Date().timeIntervalSince(date)
        print("绘制时间:\(drawTime)s")
    }
    
    var minXValue : CGFloat = 0
    var maxXValue : CGFloat = 1
    var minYValue : CGFloat = 0
    var maxYValue : CGFloat = 1
    
    deinit {
        print("ChartView is deallocated")
    }
}
