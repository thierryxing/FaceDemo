//
//  ViewController.swift
//  ImageDemo
//
//  Created by licong on 2017/3/12.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit


private var kRadio = CGFloat(1.0)

class BlendViewController: UIViewController {

    private var imageView: UIImageView!
    var inputLeftImage: UIImage!
    var inputLeftRect: CGRect!
    var inputRightImage: UIImage!
    var inputRightRect: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       navigationController?.navigationBar.isTranslucent = false
       setUpImages1()
        
    }

    
    func setUpImages1() {
        let screenWidth = UIScreen.main.bounds.width
        
        let inputImage = UIImage(named: "ghost.png")
        var inputBackgroundImage = UIImage(named: "demo1.jpg")
        
        inputBackgroundImage = BlendProcesser.filerImage(inputImage: inputImage!, inputBackgroundImage: inputBackgroundImage!)
        
        inputBackgroundImage = inputBackgroundImage?.resize(with: UIScreen.main.bounds.size.width, screenScale: UIScreen.main.scale)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: inputBackgroundImage!.size.height))
        view.addSubview(imageView)
        imageView.image = inputBackgroundImage
        
//        let subtractor = BlendProcesser.asyncBlendWithSubtractMode(inputBackgroundImage: inputBackgroundImage!) { (image) in
//            self.imageView.image = image
//        }
//        subtractor(inputLeftImage,inputLeftRect)
//        subtractor(inputRightImage,inputRightRect)
    }
}

