//
//  BlendProcesser.swift
//  FaceDemo
//
//  Created by licong on 2017/3/11.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import UIKit

// 创建一个绘图并行队列
fileprivate let drawQueue = DispatchQueue(label: "BlendProcesserConcurrentQueue", attributes: .concurrent)
fileprivate let drawGroup = DispatchGroup()
typealias CompletionHandler = (UIImage) -> ()

class BlendProcesser: NSObject {
    
    /*   
        在主线程同步的合成两张图
     
        inputBackgroundImage:这是背景图(可以理解为需要合成的两张图中size比较大的那张图)。这图需要缩放和当前屏幕一样的尺寸，注意scale的问题，不同屏幕大小有差异
        completionHandler: 这是每次合成图片的时候调用，尾部闭包有一个参数，就是合成后的UIImage
     
        (_ inputImage: UIImage, _ inputRect: CGRect) -> UIImage:
        返回一个函数，这个函数有两个输入参数
        inputImage:需要被合成的图片(比如双眼皮素材、眼线素材等)
        inputRect:需要被合成的图片在画布中的位置(画布大小和inputBackgroundImage是一致的)
        reture value:该函数返回值为一个UIImage,即是合成的最终图片
     */
    static func syncBlendWithSubtractMode(inputBackgroundImage: UIImage, completionHandler: @escaping CompletionHandler) -> ([(UIImage, CGRect)]) -> Void {
        
        let contextRect = CGRect(x: 0, y: 0, width: inputBackgroundImage.size.width, height: inputBackgroundImage.size.height)
        //闭包可以捕获闭包外面的值
        var resultImage = inputBackgroundImage
        return { images in
            if let newInputImage = drawImages(images: images, contextRect: contextRect){
                resultImage = filerImage(inputImage: newInputImage, inputBackgroundImage: resultImage)
                completionHandler(resultImage)
            }
        }
    }
    
    
    /*
        异步的合成两张图,合成后异步提交到主线程
     */
    static func asyncBlendWithSubtractMode(inputBackgroundImage: UIImage, completionHandler: @escaping CompletionHandler) -> ([(UIImage, CGRect)]) -> Void {
        
        let contextRect = CGRect(x: 0, y: 0, width: inputBackgroundImage.size.width, height: inputBackgroundImage.size.height)
        //闭包可以捕获闭包外面的值
        var resultImage = inputBackgroundImage
        return { images in
            /*
             我们用barrier模式,在异步中模拟串行,保证图片的合成先后顺序
             barrier是在并发队列上工作时扮演一个串行式的瓶颈,使用GCD的障碍（barrier）确保提交的Block在那个特定时间上是指定队列上唯一被执行的条目,
             当这个Block的执行时机到达，调度障碍执行这个Block并确保在那个时间里队列不会执行任何其它Block
             */
            drawQueue.async(group: drawGroup,flags: .barrier){
                if let newInputImage = drawImages(images: images, contextRect: contextRect){
                    resultImage = filerImage(inputImage: newInputImage, inputBackgroundImage: resultImage)
                }
            }
            
            /* 这里是必须的,比如如果在外部调用的时候
             let subtractor = BlendProcesser.asyncBlendWithSubtractMode(inputBackgroundImage: portraitImage) { (image) in
             MBProgressHUD.hide(for: self.view, animated: true)
             self.imageView.image = image
             }
             subtractor([(eyelidLeftImage!,eyelidLeftRect),(eyelidRightImage!,eyelidRightRect)])
             subtractor([(eyelidLeftImage!,eyelidLeftRect),(eyelidRightImage!,eyelidRightRect)])
             调用了两次，这样就必须知道最后一次合成的时间，然后将最终的图显示在屏幕上
             */
            drawGroup.notify(queue: drawQueue){
                DispatchQueue.main.async {
                    completionHandler(resultImage)
                }
            }
        }
    }
    
    
    /*
        如果单张draw然后去filter，这样有多少inputImage就会滤镜多少次，消耗太长
        但将多张inputImage一次性画到画布上并返回得到的新UIImage，多张图inputImage图片一起draw到画布上,draw消耗时间相对少，可以减少Filter滤镜的次数，进一步缩短最终合成的消耗时长。
     */
    private static func drawImages(images: [(UIImage, CGRect)], contextRect: CGRect) -> UIImage? {
        //图片是按照像素点绘制的,这里的画布需要添加上scale来适配不同的屏幕分辨率
        let contextSize = CGSize(width: contextRect.size.width, height: contextRect.size.height)
        UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        //预先清除掉画布上的无用的信息
        context!.clear(contextRect)
        
        // 这里是为了显示画布
//        context?.addRect(contextRect)
//        context?.setFillColor(UIColor.green.cgColor)
//        context?.fillPath()
        
        
        /*
         let flip = CGAffineTransform(scaleX: 1.0, y: -1.0)
         let flipThenShift = flip.translatedBy(x: 0, y: -contextSize.height)
         context!.concatenate(flipThenShift)
         let transformedInputRect = inputRect.applying(flipThenShift)
         context?.draw(inputImage.cgImage!, in: transformedInputRect)
         let  newinputImage = UIGraphicsGetImageFromCurrentImageContext()
         
         上面代码是用Core Graphics对 UIKit 的draw(in:)的模拟实现，涉及到坐标的翻转问题
         可以用上面的代码代替inputImage.draw(in: inputRect),效果一样
         */
        for (inputImage, inputRect) in images {
            inputImage.draw(in: inputRect, blendMode: .normal, alpha: 0.8)
        }
        
        //获取到画布上的UIImge对象
        let newinputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newinputImage
    }
    
    
    /*
      将得到的新的inputImage和背景图inputBackgroundImage 以SubtractBlendMode方式合成为一张新图片
     */
    static func filerImage(inputImage: UIImage, inputBackgroundImage: UIImage) -> UIImage{
//        let grayFilyer = CIFilter(name: "CIExposureAdjust") //CIExposureAdjust,CIGammaAdjust
//        grayFilyer?.setValue(0.5, forKey: "inputEV") //inputEV,inputPower
//        grayFilyer?.setValue(CIImage(image: inputImage), forKey: kCIInputImageKey)
//        let newInput = grayFilyer?.outputImage
        
        
        
//        let gradientFilter   = CIFilter(name: "CILinearGradient")
////        startVector = CIVector(x: size.width, y: size.height/2)
////        endVector   = CIVector(x: 0, y: size.height/2)
////        gradientFilter?.setValue(startVector, forKey: "inputPoint0")
////        gradientFilter?.setValue(endVector, forKey: "inputPoint1")
//        gradientFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor0")
//        gradientFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor1")
//        let newInput = gradientFilter?.outputImage

        
        let filter = CIFilter(name: "CISubtractBlendMode") //CISourceAtopCompositing
        filter?.setValue(CIImage(image: inputImage), forKey: kCIInputImageKey)
        filter?.setValue(CIImage(image: inputBackgroundImage), forKey: kCIInputBackgroundImageKey)
        let outputCIImage = filter?.outputImage
        
        let context = CIContext(options: nil)
        let outputCGImage = context.createCGImage(outputCIImage!, from: (outputCIImage!.extent))
        let outputImage = UIImage(cgImage:  outputCGImage!, scale: inputBackgroundImage.scale, orientation: inputBackgroundImage.imageOrientation)
        return outputImage
    }
}
