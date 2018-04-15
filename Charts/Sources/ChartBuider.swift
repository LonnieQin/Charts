//
//  ChartBuider.swift
//  Charts
//
//  Created by gzuser on 12/4/18.
//  Copyright © 2018年 gzuser. All rights reserved.
//

import UIKit

class ChartBuider {
    weak var target:ChartView?
    
    /// 重置
    func reset() {
        target?.drawCommands.removeAll()
    }
    
    
    /// 完成
    func finish() {
        target?.setNeedsDisplay()
    }

    deinit {
        print("ChartBuiler is deallocated")
    }
}

extension ChartBuider {
    
    
    /// 设置背景颜色
    ///
    /// - Parameter color: 背景颜色
    /// - Returns: 自己
    func setBackgroundColor(_ color:UIColor)->Self {
        target?.drawCommands.append(ChangeBackgroundColorCommand(color: color))
        return self
    }
    
    /// 设置背景颜色
    ///
    /// - Parameter color: 背景颜色
    /// - Returns: 自己
    func setStrokeColor(_ color:UIColor) -> Self {
        target?.drawCommands.append(StrokeColorCommand(color: color))
        return self
    } 
    
    
    /// 设置线宽
    ///
    /// - Parameter width: 线宽
    func setLineWidth(_ width:CoordinateConvertable) -> Self {
        target?.drawCommands.append(LineWidthCommand(width:width))
        return self
    }
    
    func addLines(_ lines:[Point]) -> Self {
        target?.drawCommands.append(AddLineCommand(points:lines))
        return self
    }
    
    /// 设置背景颜色
    ///
    /// - Parameter color: 背景颜色
    /// - Returns: 自己
    func setFillColor(_ color:UIColor)->Self {
        target?.drawCommands.append(FillColorCommand(color: color))
        return self
    }
    
    
    func addPath(_ block:(CGMutablePath)->Void)->Self {
        let path = CGMutablePath()
        block(path)
        target?.drawCommands.append(AddPathCommand(path))
        return self
    }
    
    /// 填满路径
    ///
    /// - Returns: 自己
    func fill()->Self {
        target?.drawCommands.append(FillCommand())
        return self
    }

    /// 给路径画线
    ///
    /// - Returns: 自己
    func stroke()->Self {
        target?.drawCommands.append(StrokeCommand())
        return self
    }
    
    func draw(_ image:UIImage,at rect:Rect) -> Self {
        target?.drawCommands.append(DrawImageCommand(image:image,rect:rect))
        return self
    }
    
    func addXAxis(with y:CoordinateConvertable,color:CGColor = UIColor.gray.cgColor,paddingLeft:CoordinateConvertable = 0,paddingRight:CoordinateConvertable = 0) -> Self {
        target?.drawCommands.append(DrawXAxisCommand(y: y, color: color, paddingLeft:paddingLeft, paddingRight:paddingRight))
        return self
    }
    func addXAxises(with values:[CoordinateConvertable],color:CGColor = UIColor.gray.cgColor) -> Self {
        values.forEach { (y) in
            target?.drawCommands.append(DrawXAxisCommand(y: y, color: color))
        }
        return self
    }
    
    func addYAxis(with x:CoordinateConvertable,color:CGColor = UIColor.gray.cgColor) -> Self {
        target?.drawCommands.append(DrawYAxisCommand(x: x, color: color))
        return self
    }
    
    func addYAxises(with values:[CoordinateConvertable],color:CGColor = UIColor.gray.cgColor) -> Self {
        values.forEach { (x) in
            target?.drawCommands.append(DrawYAxisCommand(x: x, color: color))
        }
        return self
    }
    
    //func addXLabels(with labels:[String])
    
    func draw(_ text:NSAttributedString,at point:CGPointConvertable) -> Self {
        target?.drawCommands.append(DrawTextCommand(text:text,point:point))
        return self
    }
    
    func draw(_ texts:[NSAttributedString],at points:[CGPointConvertable]) -> Self {
        assert(texts.count == points.count)
        for item in texts.enumerated() {
            target?.drawCommands.append(DrawTextCommand(text:item.element,point:points[item.offset]))
        }
        return self
    }
    
    /// 绘制多边形
    ///
    /// - Parameters:
    ///   - points: 多边形的点
    ///   - color: 颜色
    ///   - isFilled: 是否填充
    /// - Returns: 自己
    func drawPolygons(with points:[CGPointConvertable],color:UIColor,isFilled:Bool = true) -> Self {
        target?.drawCommands.append(DrawPolyGonCommand(points:points,color:color,isFilled:isFilled))
        return self
    }
}


//通过设置最小最大值绘图
extension ChartBuider {
    
    /// 更新坐标对应的值
    ///
    /// - Parameters:
    ///   - minX: X的最小值
    ///   - maxX: X的最大值
    ///   - minY: Y的最小值
    ///   - maxY: Y的最大值
    /// - Returns: 自己
    func updateValue(minX : CGFloat? = nil,
                     maxX : CGFloat? = nil,
                     minY : CGFloat? = nil,
                     maxY : CGFloat? = nil) -> Self{
        target?.drawCommands.append(UpdateCoordinateValueCommand(minX: minX, maxX: maxX, minY: minY, maxY: maxY))
        return self
    }
    
    func drawValues(_ values:[(x:CGFloat,y:CGFloat)]) -> Self {
        target?.drawCommands.append(DrawValuesCommand(values: values))
        return self
    }
}
