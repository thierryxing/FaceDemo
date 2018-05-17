//
//  UIImage+FD.swift
//  FaceDemo
//
//  Created by Thierry on 2017/2/4.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import Foundation
import UIKit

private var contextKey: UInt8 = 0

extension UIImage {
    
    struct RotationOptions: OptionSet {
        let rawValue: Int
        
        static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
        static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
    }
    
    public func rotated(by rotationInRadians: Double) -> UIImage {
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: CGFloat(rotationInRadians));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        // Rotate the image context
        bitmap!.rotate(by: CGFloat(rotationInRadians));
        
        // Now, draw the rotated/scaled image into the context
        bitmap!.scaleBy(x: 1.0, y: -1.0)
        
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    /// 重新设置Image的宽和等比的高
    ///
    /// - Parameters:
    ///   - newWidth:
    ///   - screenScale:
    /// - Returns: 新图片
    func resize(with newWidth: CGFloat, screenScale: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, screenScale)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeWidth(with newWidth: CGFloat, screenScale: CGFloat) -> UIImage {
        let newHeight = self.size.height
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, screenScale)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    /// InputBackgroundImage:背景图，即使用户的人脸原图,要求我们初始化的context和InputBackgroundImage的size一样
    /// inputRect:即将贴到人脸上的标签，比如眉毛，眼线等元素的位置
    ///
    /// - Parameters:
    ///   - rect:
    ///   - inputRect:
    ///   - alpha:
    /// - Returns:
    func blend(rect: CGRect, inputRect: CGRect, alpha: CGFloat = 1.0) -> UIImage? {
        //调用该方法必须在外面声明一个已经初始化好了的上下文，因为这里get了
        let graphicsContext = UIGraphicsGetCurrentContext()
        guard graphicsContext != nil else { return nil }
    
        //取到了当前画布上已经画好了图片，就是已经画好了的原始图片
        let  inputBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        //清除画布
        //graphicsContext!.clear(rect)
        
        let flip = CGAffineTransform(scaleX: 1.0, y: -1.0)
        let flipThenShift = flip.translatedBy(x: 0, y: -CGFloat(rect.height))
        graphicsContext!.concatenate(flipThenShift)
        let transformedInputRect = inputRect.applying(flipThenShift)
        graphicsContext?.draw(self.cgImage!, in: transformedInputRect)
        
        //看看画布在哪里？
        graphicsContext?.addRect(rect)
        graphicsContext?.setFillColor(UIColor.green.cgColor)
        graphicsContext?.fillPath()
        
        //接下来就是滤镜了
        //        let filter = CIFilter(name: "CISubtractBlendMode")
        //        filter?.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        //        filter?.setValue(CIImage(image: inputBackgroundImage!), forKey: kCIInputBackgroundImageKey)
        //        let outputCIImage = filter?.outputImage
        //        let context = CIContext(options: nil)
        //        let  outputCGImage = context.createCGImage(outputCIImage!, from: (outputCIImage!.extent))
        //
        //
        //        let outputImage = UIImage(cgImage: outputCGImage!)
        let  outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return outputImage
    }
    
}
