//
//  ChartTypes.swift
//  Charts
//
//  Created by gzuser on 13/4/18.
//  Copyright © 2018年 gzuser. All rights reserved.
//

import UIKit

/// 可转化为实际位置值的协议
protocol CoordinateConvertable {
    
    /// 相对于
    ///
    /// - Parameter value: 长或宽的值，代表视图的宽和高
    /// - Returns: 实际长或宽
    func relativeTo(_ value:CGFloat) -> CGFloat
}

extension CGFloat:CoordinateConvertable {
    func relativeTo(_ rect:CGFloat) -> CGFloat {
        return self
    }
}
extension Double:CoordinateConvertable {
    func relativeTo(_ rect:CGFloat) -> CGFloat {
        return CGFloat(self)
    }
}


protocol CGPointConvertable {
    func relativeTo(_ value:CGSize) -> CGPoint
}

extension CGPoint:CGPointConvertable {
    func relativeTo(_ value:CGSize) -> CGPoint {
        return self
    }
}

struct Point:CGPointConvertable {
    var x:CoordinateConvertable
    var y:CoordinateConvertable
    func relativeTo(_ value: CGSize) -> CGPoint {
        return CGPoint(x: x.relativeTo(value.width), y: y.relativeTo(value.height))
    }
}

protocol CGSizeConvertagle {
    func relativeTo(_ value:CGSize) -> CGSize
}

extension CGSize:CGSizeConvertagle {
    func relativeTo(_ value:CGSize) -> CGSize {
        return self
    }
}

struct Size:CGSizeConvertagle {
    var width:CoordinateConvertable
    var height:CoordinateConvertable
    func relativeTo(_ value:CGSize) -> CGSize {
        return CGSize(width: width.relativeTo(value.width), height: height.relativeTo(value.height))
    }
}

protocol  CGRectConvertable {
    func relativeTo(_ value:CGRect) -> CGRect
}

extension CGRect {
    func relativeTo(_ value:CGRect) -> CGRect {
        return self
    }
}

struct Rect:CGRectConvertable {
    var origin:Point
    var size:Size
    init(x:CoordinateConvertable,y:CoordinateConvertable,width:CoordinateConvertable,height:CoordinateConvertable) {
        origin = Point(x: x, y: y)
        size = Size(width:width,height:height)
    }
    func relativeTo(_ value:CGRect) -> CGRect {
        var rect = CGRect.zero
        rect.origin = origin.relativeTo(value.size)
        rect.size = size.relativeTo(value.size)
        return rect
    }
}
