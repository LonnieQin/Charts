//
//  ChartItems.swift
//  Charts
//
//  Created by gzuser on 13/4/18.
//  Copyright © 2018年 gzuser. All rights reserved.
//

import Foundation
import UIKit
struct ChartItem {
    var title:String
    var buidlerBlock:(ChartBuider)->Void
}

struct Theme {
    static var labelAttributes:[NSAttributedStringKey:Any] = [
        .foregroundColor : UIColor(red: 98 / 255.0, green: 100 / 255.0, blue: 115 / 255.0, alpha: 1.0),
        .font:UIFont.systemFont(ofSize: 12)
    ]
}

extension NSAttributedString{
    func size(width:CGFloat = UIScreen.main.bounds.size.height) -> CGSize {
        return boundingRect(with: CGSize(width: width, height: 10e9), options: .usesLineFragmentOrigin, context: nil).size
    }
}



func Items()->[ChartItem] {
    var items = [ChartItem]()
    items.append(ChartItem(title: "绘制图片", buidlerBlock: {builder in
        //绘制x是10%宽度 y是10%高度,宽和高为50的图片
        _ = builder.draw(UIImage(named: "sign-check-icon")!, at: Rect(x: 10%, y: 10%, width: 50, height: 50))
    }))
    func DrawText(_ builder:ChartBuider) {
        _ = builder.setBackgroundColor(.green)
        let attributedString = NSAttributedString(string: "😄", attributes: [.foregroundColor:UIColor.red,.font:UIFont.systemFont(ofSize: 15)])
        let rect = attributedString.boundingRect(with: CGSize(width: .max, height: .max), options: .usesLineFragmentOrigin, context: nil)
        _ = builder.draw(attributedString, at: Point(x:0,y:0))
        _ = builder.draw(attributedString, at: Point(x:0,y:(100%) - rect.height))
        _ = builder.draw(attributedString, at: Point(x:(100%) - rect.width,y:0))
        _ = builder.draw(attributedString, at: Point(x:(100%) - rect.width,y:(100%) - rect.height))
        
    }
    items.append(ChartItem(title: "绘制文字", buidlerBlock: DrawText))
    
    items.append(ChartItem(title: "折线图1", buidlerBlock: {builder in
        let values:[CGFloat] = [0,25,50,75,100]
        
        _ = builder.setBackgroundColor(UIColor(red: 76 / 255.0, green: 113 / 255.0, blue: 236 / 255.0, alpha: 1.0)).fill()
        
        //画折线图
        _ = builder.drawPolygons(with: [
            Point(x: 0%, y: 100%),
            Point(x: 0, y: 75%),
            Point(x: 25%, y: 90%),
            Point(x: 50%, y: 80%),
            Point(x: 75%, y: 70%),
            Point(x: 100%, y: 70%),
            Point(x: 100%, y: 100%)
            ],
                                 color:
            UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        )
        
        _ = builder.addXAxises(with: values.map{Persentage($0)})
        _ = builder.addYAxises(with: values.map{Persentage($0)})
        //画X
        _ = builder.draw(values.map({NSAttributedString(string: String(describing: $0), attributes:[.font:UIFont.boldSystemFont(ofSize: 12),.foregroundColor:UIColor.white])}), at: values.map({Point(x: 100%, y: CGFloat(1-$0)%)}))
        //画Y
        _ = builder.draw(values.map({NSAttributedString(string: String(describing: $0), attributes: [.font:UIFont.boldSystemFont(ofSize: 12), .foregroundColor:UIColor.white])}), at: values.map({Point(x: CGFloat($0+1)%, y: 95%)}))
    }))
    
    items.append(ChartItem(title: "折线图2", buidlerBlock: {builder in
        //X的数值
        let xAxisValues:[CGFloat] = [0.5, 1.5, 2.5, 3.5, 4.5]
        //X的标签
        let xAxisLabels = ["IOS","Mac OS X","Window 7","Windows 8","Android"]
        //Y轴的值
        let yAxisValues:[CGFloat] = [0, 19000, 38000, 57000, 76000]
        //Y轴的标签
        let yAxisLabels = ["", "19K", "38K", "57K", "76K"]
        
        var maxY = yAxisValues.max() ?? 10000
        maxY  += 20000
        //Y的数值
        let yValues:[CGFloat] = [41962,9048,16285,16443,60201]
        //let yValues:[CGFloat] = [0,0,0,0,0]
        
        //Y轴属性文本
        let yAxisAttributedLabels = yAxisLabels.map({NSAttributedString(string: $0, attributes: Theme.labelAttributes)})
        
        //X轴属性文本
        let xAxisAttributedLabels = xAxisLabels.map({NSAttributedString(string: $0, attributes: Theme.labelAttributes)})
        
        let xAxisLabelPoints = xAxisValues.map({Point(x: (100*($0)/6)%, y: 100% - 15)})

        //设置背景
        _ = builder.setBackgroundColor(UIColor(red: 41 / 255.0, green: 43 / 255.0, blue: 63 / 255.0, alpha: 1.0))
        
        let yPadding = yAxisAttributedLabels.last!.size().height + 10
        
        let yAxisPoints = yAxisValues.map{Point(x: 10, y: (100 * (1 - $0 / maxY))% - yPadding)}
        let yAxisLablePositions = yAxisValues.map{((100 * (1 - $0 / maxY))%) - yPadding}
        //画Y轴标签
        _ = builder.draw(yAxisAttributedLabels, at: yAxisPoints)
        
        let maxXLabelTrailing = yAxisAttributedLabels.reduce(0, { (result, attr) -> CGFloat in
            let size = attr.size()
            if size.width > result {
                return attr.size().width
            }
            return result
        }) + 10 + 5
        //画Y轴线
        _ = builder.setLineWidth(1)
        yAxisLablePositions.forEach({ (position) in
            _ = builder.addXAxis(with: position,color:UIColor(red: 48 / 255.0, green: 50 / 255.0, blue: 70 / 255.0, alpha: 1.0).cgColor,paddingLeft:maxXLabelTrailing)
        })
        
        //画X轴标签
        _ = builder.draw(xAxisAttributedLabels, at: xAxisLabelPoints)
        
        
        var valuePoints = [Point]()
        var valueLabelPoints = [Point]()
        //Y Points
        for i in xAxisValues.enumerated() {
            valuePoints.append(Point(x: (100 * xAxisValues[i.offset] / 6)% + maxXLabelTrailing, y:Persentage(100 * (1 - yValues[i.offset] / maxY)) - yPadding))
            valueLabelPoints.append(Point(x: (100 * xAxisValues[i.offset] / 6)% + maxXLabelTrailing, y:Persentage(100 * (1 - yValues[i.offset] / maxY)) - (yPadding + 20)))
        }
        //画线
        _ = builder.setStrokeColor(UIColor(red: 124 / 255.0, green: 84 / 255.0, blue: 208 / 255.0, alpha: 1.0)).setLineWidth(2).addLines(valuePoints).stroke()
        
        let valueLabels = yValues.map({NSAttributedString(string: String(describing:$0), attributes: Theme.labelAttributes)})
        
        _ = builder.draw(valueLabels, at: valueLabelPoints)
        //画数值
        print(yValues)
    }))
    
    items.append(ChartItem(title: "柱状图 + 折线图", buidlerBlock: { (builder) in
        //原点
        let originPoint = CGPoint(x: 20, y: 20)
        
        let endPoint = CGPoint(x: 20, y: 20)
        //Y轴
        let yAxis = [Int](1...9).map{item in (CGFloat(item) * 10, "\(item * 10)")}
        //X轴
        let xAxis = [Int](1...8).map{item in (CGFloat(item) - 0.5, "项目\(item)")}
        //数据1
        let dataArray1 : [(CGFloat,CGFloat)] = [(0.5, 80), (1.5, 65), (2.5, 55), (3.5, 60), (4.5, 45), (5.5, 50), (6.5, 21), (7.5, 40)]
        
        
        let maxX : CGFloat = 9
        let maxY : CGFloat = 90
        
        //数据2
        let dataArray2 : [(CGFloat,CGFloat)] = [(0.5, 60), (1.5, 30), (2.5, 45), (3.5, 31), (4.5, 22), (5.5, 50), (6.5, 21), (7.5, 40)]
        
        //绘制Y标签
        let YAxisLabels = yAxis.map {NSAttributedString(string:$0.1, attributes: Theme.labelAttributes)}
        let YAxisPositions = yAxis.map{Point(x: 0, y: (100 - 100*$0.0/maxY)% - originPoint.y)}
        let labelHeight = YAxisLabels.last!.size().height
        let YLabelPositions = yAxis.map{Point(x: 0, y: Persentage(100 - (100 * $0.0 / maxY)) - originPoint.y - labelHeight / 2)}
        _ = builder.setBackgroundColor(.white).setLineWidth(1)
        _ = builder.draw(YAxisLabels, at: YAxisPositions)
        
        //绘制Y轴线
        YLabelPositions.forEach { point in
            print(point.y)
           _ = builder.addXAxis(with: point.y,paddingLeft:originPoint.x)
        }
        
        //绘制X标签
        let XAxisLabels = xAxis.map {NSAttributedString(string:$0.1, attributes: Theme.labelAttributes)}
        var XAxisPositions = [Point]()
        for item in zip(xAxis, XAxisLabels) {
            XAxisPositions.append(Point(x: Persentage(100 * item.0.0/maxX) , y: 100% - originPoint.y))
        }
        _ = builder.draw(XAxisLabels, at: XAxisPositions)
        
        //绘制X轴线
        _ = builder.setLineWidth(2).setStrokeColor(.black).addXAxis(with: 100% - originPoint.y,paddingLeft:originPoint.x)
        
        //绘制X刻度
        for item in 0..<9 {
            _ = builder.addLines([Point(x: Persentage(100 * CGFloat(item) / CGFloat(maxX)) + originPoint.x, y: 100% - (originPoint.y - 1)),
                                  Point(x: Persentage(100 * CGFloat(item) / CGFloat(maxX)) + originPoint.x, y: 100% - (originPoint.y + 5.0))])
        }
        _ = builder.setStrokeColor(UIColor(red: 156 / 255.0, green: 200 / 255.0, blue: 80 / 255.0, alpha: 1.0)).setLineWidth(15)
        //绘制柱状图
        for item in dataArray1 {
            builder.addLines([Point(x: Persentage(100 * CGFloat(item.0) / CGFloat(maxX)) + originPoint.x, y: (100 * (1 - item.1 / CGFloat(maxY)))% - originPoint.y),
                              Point(x: Persentage(100 * CGFloat(item.0) / CGFloat(maxX)) + originPoint.x, y: 100% - (originPoint.y))])
        }
        
        //绘制折线
        let points2 = dataArray2.map({Point(x: Persentage(100 * CGFloat($0.0) / CGFloat(maxX)) + originPoint.x, y: (100 * (1 - $0.1 / CGFloat(maxY)))% - originPoint.y)})
        _ = builder.setStrokeColor(.red).setLineWidth(1).addLines(points2)
        
        //绘制备注
    }))
    items.append(ChartItem(title: "sin(x)", buidlerBlock: { (builder) in
        //Sin(x)
        let values = [Int](0...628).map({CGFloat($0) * 0.01}).map({(x:$0,y:sin($0))})
        builder.setBackgroundColor(.white).setLineWidth(1).setStrokeColor(.red).updateValue(minX: 0, maxX: 6.28, minY: -1.1, maxY: 1.1).drawValues(values)
    }))
    items.append(ChartItem(title: "cos(x)", buidlerBlock: { (builder) in
        //Cos(x)
        let values = [Int](0...628).map({CGFloat($0) * 0.01}).map({(x:$0,y:cos($0))})
        builder.setBackgroundColor(.white).setLineWidth(1).setStrokeColor(.red).updateValue(minX: 0, maxX: 6.28, minY: -1.1, maxY: 1.1).drawValues(values)
    }))
    items.append(ChartItem(title: "tan(x)", buidlerBlock: { (builder) in
        //tan(x)
        let values = [Int](0...314).map({CGFloat($0) * 0.01}).map({(x:$0,y:tan($0))})
        builder.setBackgroundColor(.white).setLineWidth(1).setStrokeColor(.red).updateValue(minX: 0, maxX: 3.14, minY: -100, maxY: 100).drawValues(values)
    }))
    return items
}
