//
//  Eyes.swift
//  FaceDemo
//
//  Created by Thierry on 2017/2/17.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import Foundation
import UIKit

private var eyeLidTHRatioAssociationKey: UInt8 = 0
private var defaultEyelidRadAssociationKey: UInt8 = 1
private typealias Eyes = Face
extension Eyes {
    
    static var eyelidList: [String] { get { return ["cancel","kaishan","oushi","pingxing","xinyue"] } }
    
    /// 双眼皮内眼角宽度和眼宽度比
    var eyeLidInnerSpreadRatio: Float { get { return Float(1.0/11.0) } }
    
    /// 双眼皮外眼角宽度和眼宽度比
    var eyeLidOuterSpreadRatio: Float { get { return Float(11.0/54.0) } }
    
    mutating func changeEyeLidParam(name: String) {
        if (name == "kaishan") {
            defaultEyelidRad = Double(Double.pi*3.0/180.0)
            eyeLidTHRatio = Float(5.8/18.0)
        } else if (name == "pingxing") {
            defaultEyelidRad = Double(Double.pi*1.0/180.0)
            eyeLidTHRatio = Float(5.8/18.0)
        } else if (name == "xinyue") {
            defaultEyelidRad = -Double(Double.pi*3.0/180.0)
            eyeLidTHRatio = Float(5.8/18.0)
        } else if (name == "oushi") {
            defaultEyelidRad = Double(Double.pi*2.0/180.0)
            eyeLidTHRatio = Float(7.5/18.0)
        }
    }
    
    /// 计算左眼双眼皮的Rect
    func leftEyelidRect(image: UIImage) -> CGRect {
        return CGRect(
            x: (CGFloat(leftEyeRightCorner.x) - leftEyelidWidth() + leftInnerCornerWidth())/screenScale,
            y: (CGFloat(leftEyeTop.y) - CGFloat(leftEyelidYOffset()) - leftEyelidHeight())/screenScale,
            width: leftEyelidWidth()/screenScale,
            height: leftEyelidImageHeight(image: image)/screenScale
        )
    }
    
    /// 计算右眼双眼皮的Rect
    func rightEyelidRect(image: UIImage) -> CGRect {
        return CGRect(
            x: (CGFloat(rightEyeLeftCorner.x) - rightInnerCornerWidth())/screenScale,
            y: (CGFloat(rightEyeTop.y) - CGFloat(rightEyelidYOffset()) - rightEyelidHeight())/screenScale,
            width: rightEyelidWidth()/screenScale,
            height: rightEyelidImageHeight(image: image)/screenScale
        )
    }
    
    /// 计算左眼双眼皮的背景图高度
    func leftEyelidImageHeight(image: UIImage) -> CGFloat {
        return (image.size.height * CGFloat(leftEyelidWidth())/image.size.width)
    }
    
    /// 计算右眼双眼皮的背景图高度
    func rightEyelidImageHeight(image: UIImage) -> CGFloat {
        return (image.size.height * CGFloat(rightEyelidWidth())/image.size.width)
    }
    
    /// 计算左眼双眼皮的宽度
    func leftEyelidWidth() -> CGFloat {
        return CGFloat(leftEyeRightCorner.x - leftEyeLeftCorner.x) + leftInnerCornerWidth() + leftOuterCornerWidth()
    }
    
    /// 计算右眼双眼皮的宽度
    func rightEyelidWidth() -> CGFloat {
        return CGFloat(rightEyeRightCorner.x - rightEyeLeftCorner.x) + rightInnerCornerWidth() + rightOuterCornerWidth()
    }
    
    /// 计算左眼内眼角的宽度
    func leftInnerCornerWidth() -> CGFloat {
        return CGFloat(leftEyeRightCorner.x - leftEyeLeftCorner.x)*CGFloat(eyeLidInnerSpreadRatio)
    }
    
    /// 计算左眼外眼角的宽度
    func leftOuterCornerWidth() -> CGFloat {
        return CGFloat(leftEyeRightCorner.x - leftEyeLeftCorner.x)*CGFloat(eyeLidOuterSpreadRatio)
    }
    
    /// 计算右眼内眼角的宽度
    func rightInnerCornerWidth() -> CGFloat {
        return CGFloat(rightEyeRightCorner.x - rightEyeLeftCorner.x)*CGFloat(eyeLidInnerSpreadRatio)
    }
    
    /// 计算右眼外眼角的宽度
    func rightOuterCornerWidth() -> CGFloat {
        return CGFloat(rightEyeRightCorner.x - rightEyeLeftCorner.x)*CGFloat(eyeLidOuterSpreadRatio)
    }
    
    /// 计算左眼的双眼皮厚度
    func leftEyelidHeight() -> CGFloat {
        return CGFloat(Float(leftEyeBottom.y - leftEyeTop.y)*eyeLidTHRatio)
    }
    
    /// 计算右眼的双眼皮厚度
    func rightEyelidHeight() -> CGFloat {
        return CGFloat(Float(rightEyeBottom.y - rightEyeTop.y)*eyeLidTHRatio)
    }
    
    /// 计算左眼双眼皮的倾斜弧度，用于调整双眼皮的倾斜角度
    func leftEyelidAngleRad() -> Double {
        let dx = leftEyeRightCorner.x - leftEyeLeftCorner.x
        let dy = leftEyeRightCorner.y - leftEyeLeftCorner.y
        return atan2(Double(dy),Double(dx)) + defaultEyelidRad
    }
    
    /// 计算右眼双眼皮的倾斜弧度，用于调整双眼皮的倾斜角度
    func rightEyelidAngleRad() -> Double {
        let dx = rightEyeRightCorner.x - rightEyeLeftCorner.x
        let dy = rightEyeLeftCorner.y - rightEyeRightCorner.y
        let a = 2*Double.pi - atan2(Double(dy),Double(dx)) - defaultEyelidRad
        return a
    }
    
    /// 左眼双眼皮图片倾斜后，Y轴应该向上偏移N个单位，以保证图片顶部的中心和眼睛的顶部对齐
    ///
    /// - Returns: 偏移量N
    func leftEyelidYOffset() -> Double {
        return sin(leftEyelidAngleRad())*Double(leftEyelidWidth()/2)
    }
    
    /// 右眼双眼皮图片倾斜后，Y轴应该向上偏移N个单位，以保证图片顶部的中心和眼睛的顶部对齐
    ///
    /// - Returns: 偏移量N
    func rightEyelidYOffset() -> Double {
        return sin(abs(2*Double.pi - rightEyelidAngleRad()))*Double(rightEyelidWidth()/2)
    }
    
}


extension Eyes {
    
    static var eyelinerList: [String] { get { return ["EyeLiner0","EyeLiner1"] } }
    
    /// 眼线高度
    var eyelinerTH: Float { get { return Float(8.0) } }
    
    /// 眼线宽度左右延伸的宽度和眼宽度比
    var eyelinerSpreadRatio: Float { get { return Float(11.0/44.0) } }
    
    /// 计算左眼眼线的Rect
    func leftEyeLinerRect(image: UIImage) -> CGRect {
        return CGRect(
            x: (CGFloat(leftEyeUpperRightQuarter.x) - leftEyelinerWidth())/screenScale,
            y: (CGFloat(leftEyeTop.y) - CGFloat(leftEyelinerYOffset()) - CGFloat(eyelinerTH))/screenScale,
            width: leftEyelinerWidth()/screenScale,
            height: leftEyelidImageHeight(image: image)/screenScale
        )
    }
    
    /// 计算右眼眼线的Rect
    func rightEyeLinerRect(image: UIImage) -> CGRect {
        return CGRect(
            x: (CGFloat(rightEyeUpperLeftQuarter.x))/screenScale,
            y: (CGFloat(rightEyeTop.y) - CGFloat(rightEyelinerYOffset()) - CGFloat(eyelinerTH))/screenScale,
            width: rightEyelinerWidth()/screenScale,
            height: rightEyelidImageHeight(image: image)/screenScale
        )
    }
    
    /// 计算左眼眼线的宽度
    func leftEyelinerWidth() -> CGFloat {
        return CGFloat(leftEyeUpperRightQuarter.x - leftEyeLeftCorner.x) + leftEyelinerSpreadWidth()
    }
    
    /// 计算右眼眼线的宽度
    func rightEyelinerWidth() -> CGFloat {
        return CGFloat(rightEyeRightCorner.x - rightEyeUpperLeftQuarter.x) + rightEyelinerSpreadWidth()
    }
    
    /// 计算左眼眼线某一侧延伸出去的宽度
    func leftEyelinerSpreadWidth() -> CGFloat {
        return CGFloat(leftEyeUpperRightQuarter.x - leftEyeLeftCorner.x)*CGFloat(eyelinerSpreadRatio)
    }
    
    /// 计算右眼眼线某一侧延伸出去的宽度
    func rightEyelinerSpreadWidth() -> CGFloat {
        return CGFloat(rightEyeRightCorner.x - rightEyeUpperLeftQuarter.x)*CGFloat(eyelinerSpreadRatio)
    }
    
    /// 计算左眼眼线的倾斜弧度，用于调整眼线的倾斜角度
    func leftEyelinerAngleRad() -> Double {
        let dx = leftEyeRightCorner.x - leftEyeLeftCorner.x
        let dy = leftEyeRightCorner.y - leftEyeLeftCorner.y
        return atan2(Double(dy),Double(dx))
    }
    
    /// 计算右眼眼线的倾斜弧度，用于调整眼线的倾斜角度
    func rightEyelinerAngleRad() -> Double {
        let dx = rightEyeRightCorner.x - rightEyeLeftCorner.x
        let dy = rightEyeLeftCorner.y - rightEyeRightCorner.y
        return 2*Double.pi - atan2(Double(dy),Double(dx))
    }
    
    /// 左眼双眼皮图片倾斜后，Y轴应该向上偏移N个单位，以保证图片顶部的中心和眼睛的顶部对齐
    ///
    /// - Returns: 偏移量N
    func leftEyelinerYOffset() -> Double {
        return sin(leftEyelinerAngleRad())*Double(leftEyelinerWidth()/2)
    }
    
    /// 右眼双眼皮图片倾斜后，Y轴应该向上偏移N个单位，以保证图片顶部的中心和眼睛的顶部对齐
    ///
    /// - Returns: 偏移量N
    func rightEyelinerYOffset() -> Double {
        return sin(abs(2*Double.pi - rightEyelinerAngleRad()))*Double(rightEyelinerWidth()/2)
    }
    
}
