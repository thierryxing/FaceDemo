//
//  Nose.swift
//  FaceDemo
//
//  Created by Thierry on 2017/2/17.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import Foundation
import UIKit

private typealias Nose = Face
extension Nose {
    
    static var noseList: [String] { get { return ["Nose0", "Nose1", "Nose2", "Nose3"] } }
    
    static var noseListRatio: [CGFloat] { get { return [CGFloat(0.0), CGFloat(0.05), CGFloat(0.07), CGFloat(0.09)] } }
    
    /// 鼻子两侧皮肤的宽度
    var noseSideWidth: CGFloat { get { return CGFloat(10.0) } }
    
    /// 鼻子上部偏移
    var noseTopOffset: CGFloat { get { return CGFloat(10.0) } }
    
    /// 计算鼻子的Rect
    func originNoseRect() -> CGRect {
        return CGRect(
            x: CGFloat(leftNoseBottom.x),
            y: noseTop(),
            width: noseWidth(),
            height: noseHeight()
        )
    }
    
    func noseLeftAreaRect() -> CGRect {
        return CGRect(
            x: CGFloat(leftNoseBottom.x) - noseSideWidth,
            y: noseTop(),
            width: noseSideWidth,
            height: noseHeight()
        )
    }
    
    func noseRightAreaRect() -> CGRect {
        return CGRect(
            x: CGFloat(rightNoseBottom.x),
            y: noseTop(),
            width: noseSideWidth,
            height: noseHeight()
        )
    }
    
    func noseWidth() -> CGFloat {
        return CGFloat(rightNoseBottom.x - leftNoseBottom.x)
    }
    
    func noseHeight() -> CGFloat {
        return CGFloat(middleNoseBottom.y - leftEyeBottom.y) - noseTopOffset
    }
    
    func noseTop() -> CGFloat {
        if leftEyeBottom.y >= leftNoseTop.y {
            return CGFloat(leftEyeBottom.y) + noseTopOffset
        } else {
            return CGFloat(leftNoseTop.y) + noseTopOffset
        }
    }
    
}
