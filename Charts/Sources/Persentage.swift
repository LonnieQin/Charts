//
//  Persentage.swift
//  Charts
//
//  Created by gzuser on 13/4/18.
//  Copyright © 2018年 gzuser. All rights reserved.
//
import UIKit
/// 0-100,代表0%到100%
struct Persentage:CoordinateConvertable {
    var rawValue:CGFloat
    var offset:CGFloat = 0
    init(_ value:CGFloat) {
        self.rawValue = value
    }
    init(_ value:Double) {
        self.rawValue = CGFloat(value)
    }
    init(_ value:Int) {
        self.rawValue = CGFloat(value)
    }
    func relativeTo(_ rect:CGFloat) -> CGFloat {
        return rawValue * 0.01 * rect + offset
    }
}

postfix operator %
postfix func % (_ value:CGFloat)->Persentage {
    return Persentage(value)
}
postfix func % (_ value:Double)->Persentage {
    return Persentage(value)
}
postfix func % (_ value:Int)->Persentage {
    return Persentage(value)
}

func + (value:Persentage,offset:CGFloat)->Persentage {
    var newValue = value
    newValue.offset = offset
    return newValue
}
func - (value:Persentage,offset:CGFloat)->Persentage {
    var newValue = value
    newValue.offset = -offset
    return newValue
}

func + (value:Persentage,offset:Double)->Persentage {
    var newValue = value
    newValue.offset = CGFloat(offset)
    return newValue
}
func - (value:Persentage,offset:Double)->Persentage {
    var newValue = value
    newValue.offset = -CGFloat(offset)
    return newValue
}

func + (value:Persentage,offset:Int)->Persentage {
    var newValue = value
    newValue.offset = CGFloat(offset)
    return newValue
}
func - (value:Persentage,offset:Int)->Persentage {
    var newValue = value
    newValue.offset = -CGFloat(offset)
    return newValue
}
