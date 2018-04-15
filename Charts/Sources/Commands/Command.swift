//
//  Command.swift
//  Charts
//
//  Created by gzuser on 12/4/18.
//  Copyright © 2018年 gzuser. All rights reserved.
//

import UIKit

/// 绘图命令
protocol DrawCommand {
    
    /// 在上下文执行绘图命令
    ///
    /// - Parameters:
    ///   - context: 上下文
    ///   - rect: 矩形
    func draw(at view:Drawable,context:CGContext,rect:CGRect)
}


/// 修改背景颜色
struct ChangeBackgroundColorCommand: DrawCommand {
    var color:UIColor
    var rect:Rect?
    init(color:UIColor,rect:Rect? = nil) {
        self.color = color
        self.rect = rect
    }
    func draw(at view:Drawable,context: CGContext, rect: CGRect) {
        context.setFillColor(color.cgColor)
        let targetRect = self.rect?.relativeTo(rect) ?? rect
        context.fill(targetRect)
    }
}


/// 添加线
struct AddLineCommand: DrawCommand {
    var points:[Point]
    func draw(at view:Drawable,context: CGContext, rect: CGRect) {
        context.beginPath()
        context.addLines(between: points.map({$0.relativeTo(rect.size)}))
        context.strokePath()
    }
}


/// 填充颜色
struct FillColorCommand: DrawCommand {
    var color:UIColor
    func draw(at view:Drawable,context: CGContext, rect: CGRect) {
        color.setFill()
    }
}


/// 描绘颜色
struct StrokeColorCommand: DrawCommand {
    var color:UIColor
    func draw(at view:Drawable,context: CGContext, rect: CGRect) {
        color.setStroke()
    }
}


/// 设置线宽
struct LineWidthCommand: DrawCommand {
    var width:CoordinateConvertable
    func draw(at view:Drawable,context: CGContext, rect: CGRect) {
        context.setLineWidth(width.relativeTo(rect.size.width))
    }
}


/// 填充
struct FillCommand:DrawCommand {
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        context.fillPath()
    }
}


/// 描绘
struct StrokeCommand:DrawCommand {
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        context.strokePath()
    }
}


/// 添加路径
struct AddPathCommand: DrawCommand {
    var path :CGMutablePath
    init(_ path:CGMutablePath) {
        self.path = path
    }
    
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        context.addPath(path)
    }
}

struct DrawImageCommand:DrawCommand {
    var image:UIImage
    var rect:Rect
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        image.draw(in: self.rect.relativeTo(rect))
    }
}

struct DrawXAxisCommand:DrawCommand {
    var y:CoordinateConvertable
    var color:CGColor
    var paddingLeft:CoordinateConvertable
    var paddingRight:CoordinateConvertable
    
    init(y:CoordinateConvertable,color:CGColor,paddingLeft:CoordinateConvertable = 0,paddingRight:CoordinateConvertable = 0) {
        self.y = y
        self.color = color
        self.paddingLeft = paddingLeft
        self.paddingRight = paddingRight
    }
    
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        if rect.size.height == 0 {return}
        let realY = y.relativeTo(rect.size.height)
        context.setStrokeColor(color)
        context.beginPath()
        context.addLines(between: [CGPoint(x: paddingLeft.relativeTo(rect.size.width), y: realY),CGPoint(x: rect.size.width-paddingRight.relativeTo(rect.size.width), y: realY)])
        context.strokePath()
    }
}

struct DrawYAxisCommand:DrawCommand {
    var x:CoordinateConvertable
    var color:CGColor
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        if rect.size.width == 0 {return}
        let realX = x.relativeTo(rect.size.width)
        context.setStrokeColor(color)
        context.beginPath()
        context.addLines(between: [CGPoint(x: realX, y: 0),CGPoint(x: realX, y: rect.height)])
        context.strokePath()
    }
}

struct DrawTextCommand:DrawCommand {
    var text:NSAttributedString
    var point:CGPointConvertable
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        let result = point.relativeTo(rect.size)
        print(result)
        text.draw(at: result)
    }
}

struct DrawPolyGonCommand:DrawCommand {
    var color:UIColor
    var isFilled:Bool
    var points:[CGPointConvertable]
    init(points: [CGPointConvertable], color: UIColor, isFilled: Bool = true) {
        self.points = points
        self.color = color
        self.isFilled = isFilled
    }
    
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        color.set()
        for point in points.enumerated() {
            let  newPoint = point.element.relativeTo(rect.size)
            if point.offset == 0 {
                context.move(to: newPoint)
            } else {
                context.addLine(to: newPoint)
                if point.offset < points.count - 1 {
                    context.addLine(to: points[point.offset+1].relativeTo(rect.size))
                } else {
                    context.move(to: points[0].relativeTo(rect.size))
                }
            }
        }
        
        if isFilled {
            context.fillPath()
        } else {
            context.strokePath()
        }
    }
}

struct UpdateCoordinateValueCommand:DrawCommand {
    var minX : CGFloat?
    var maxX : CGFloat?
    var minY : CGFloat?
    var maxY : CGFloat?
    func draw(at view:Drawable, context: CGContext, rect: CGRect) {
        if let minX = minX {
            view.minXValue = minX
        }
        if let maxX = maxX {
            view.maxXValue = maxX
        }
        if let minY = minY {
            view.minYValue = minY
        }
        if let maxY = maxY {
            view.maxYValue = maxY
        }
    }
}

struct DrawValuesCommand : DrawCommand {
    
    func draw(at view: Drawable, context: CGContext, rect: CGRect) {
        let points = values.map({view.point(for: $0)})
        context.beginPath()
        context.addLines(between: points)
        context.strokePath()
    }
    
    var values:[(x:CGFloat,y:CGFloat)] = []
}
