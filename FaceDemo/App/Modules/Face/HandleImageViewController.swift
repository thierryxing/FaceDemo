//
//  ChooseImageViewController.swift
//  FaceDemo
//
// http://www.cnblogs.com/XYQ-208910/p/5859683.html
//
//  Created by Thierry on 2017/1/30.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import MBProgressHUD
import BTNavigationDropdownMenu
import Observable

class HandleImageViewController: UIViewController {
    
    let screenScale = UIScreen.main.scale
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let imageView = UIImageView()
    
    var toolsView: UICollectionView?
    
    var portraitImage: UIImage!
    let viewModel = HandleFaceViewModel()
    
    var toolsData: [String] = Face.eyelidList
    let menuItems = ["双眼皮", "缩鼻翼", "半永久眼线"]
    var currentToolsIndex = 0
    
    /// 鼻子的图片
    var leftImageView = UIImageView()
    var rightImageView = UIImageView()
    var noseImageView = UIImageView()
    var noseReductionWidth: CGFloat?
    var noseReductionHalfWidth: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        
        let menuView = BTNavigationDropdownMenu(title: menuItems[0], items: menuItems as [AnyObject])
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.switchTools(indexPath: indexPath)
        }
        
        portraitImage = portraitImage.resize(with: UIScreen.main.bounds.size.width, screenScale: screenScale)
        imageView.image = portraitImage
        imageView.backgroundColor = UIColor.red
        imageView.contentMode = .topLeft
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(portraitImage.size.height)
        }
        
        addKVO()
        addToolsBar()
        checkFaceByRemote()
    }
    
    func addKVO() {
        _ = self.viewModel.fetchDataResult.afterChange += { [weak self] in
            self?.observeHandler(newValue: $1)
        }
    }
    
    func addToolsBar() {
        toolsView?.removeFromSuperview()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 70)
        toolsView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        toolsView!.register(ToolsCell.self, forCellWithReuseIdentifier: "cell\(currentToolsIndex)")
        toolsView!.delegate = self;
        toolsView!.dataSource = self;
        toolsView!.backgroundColor = UIColor.white
        view.addSubview(toolsView!)
        toolsView!.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(75)
        }
    }
    
    func switchTools(indexPath: Int) {
        switch indexPath {
        case 0:
            toolsData = Face.eyelidList
        case 1:
            toolsData = Face.noseList
        case 2:
            toolsData = Face.eyelinerList
        default:
            debugPrint("")
        }
        currentToolsIndex = indexPath
        addToolsBar()
        toolsView?.reloadData()
    }
    
    func showLoading() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func toast() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func observeHandler(newValue: Int) {
//        drawMarks()
        hideLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private typealias HandleDoubleEyelids = HandleImageViewController
extension HandleDoubleEyelids {
    
    func addDoubleEyelid(by name: String) {
        
        viewModel.face!.changeEyeLidParam(name: name)
        
        let eyelidLeftImage = UIImage(named: "eyelid_\(name)_left.png")?.rotated(by: viewModel.face.leftEyelidAngleRad())
        let eyelidRightImage = UIImage(named: "eyelid_\(name)_right.png")?.rotated(by: viewModel.face.rightEyelidAngleRad())
        
        UIGraphicsBeginImageContextWithOptions(portraitImage.size, false, screenScale)
        
        portraitImage.draw(in: CGRect(x:0, y:0, width: portraitImage.size.width, height: portraitImage.size.height), blendMode: .normal, alpha: 1)
        eyelidLeftImage?.draw(in: viewModel.face!.leftEyelidRect(image: eyelidLeftImage!), blendMode: .difference, alpha: 0.5)
        eyelidRightImage?.draw(in: viewModel.face!.rightEyelidRect(image: eyelidRightImage!), blendMode: .difference, alpha: 0.5)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        imageView.image = newImage
        
        
//        var a = UIImage(named: "eyelid_\(name)left.png")
//        let eyelidLeftImage = a?.rotated(by: viewModel.face.leftEyelidAngleRad())
//        let eyelidRightImage = UIImage(named: "eyelid_\(name)right.png")?.rotated(by: viewModel.face.rightEyelidAngleRad())
//        let eyelidLeftRect = viewModel.face.leftEyelidRect(image: eyelidLeftImage!)
//        let eyelidRightRect = viewModel.face.rightEyelidRect(image: eyelidRightImage!)
//        
//        showLoading()
//        
//        let subtractor = BlendProcesser.asyncBlendWithSubtractMode(inputBackgroundImage: portraitImage) {[weak self] (image) in
//            self?.hideLoading()
//            UIView.animate(withDuration: 0.1, animations: { 
//                self?.imageView.image = image
//            })
//        }
//        
//        subtractor([(eyelidLeftImage!,eyelidLeftRect),(eyelidRightImage!,eyelidRightRect)])
    }
    
    func restoreEyelid() {
        imageView.image = portraitImage
    }
    
}

private typealias HandleEyeLiner = HandleImageViewController
extension HandleEyeLiner {
    
    func addEyeLiner(by name: String) {
        let eyelinerLeftImage = UIImage(named: "eyeliner_\(name)left.png")?.rotated(by: viewModel.face.leftEyelinerAngleRad())
        let eyelinerRightImage = UIImage(named: "eyeliner_\(name)right.png")?.rotated(by: viewModel.face.rightEyelinerAngleRad())
        let eyelinerLeftRect = viewModel.face.leftEyeLinerRect(image: eyelinerLeftImage!)
        let eyelinerRightRect = viewModel.face.rightEyeLinerRect(image: eyelinerRightImage!)
        
        showLoading()
        
        let subtractor = BlendProcesser.asyncBlendWithSubtractMode(inputBackgroundImage: portraitImage) {[weak self] (image) in
            self?.hideLoading()
            self?.imageView.image = image
        }
        
        subtractor([(eyelinerLeftImage!,eyelinerLeftRect),(eyelinerRightImage!,eyelinerRightRect)])
    }
    
    func restoreEyeliner() {
        imageView.image = portraitImage
    }
    
}

private typealias HandleNose = HandleImageViewController
extension HandleNose {
    
    func cropNoseImage() -> UIImage {
        let image = portraitImage.cgImage!.cropping(to: viewModel.face.originNoseRect())
        var nose = UIImage(cgImage: image!, scale: screenScale, orientation: .up)
        nose = nose.resizeWidth(with: nose.size.width - noseReductionWidth!, screenScale: screenScale)
        return nose
    }
    
    func cropLeftArea()-> UIImage {
        let image = portraitImage.cgImage!.cropping(to: viewModel.face.noseLeftAreaRect())
        var left = UIImage(cgImage: image!, scale: screenScale, orientation: .up)
        left = left.resizeWidth(with: left.size.width + noseReductionHalfWidth!, screenScale: screenScale)
        return left
    }
    
    func cropRightArea()-> UIImage {
        let image = portraitImage.cgImage!.cropping(to: viewModel.face.noseRightAreaRect())
        var right = UIImage(cgImage: image!, scale: screenScale, orientation: .up)
        right = right.resizeWidth(with: right.size.width + noseReductionHalfWidth!, screenScale: screenScale)
        return right
    }
    
    func addNoseImage(index: Int) {
        
        restoreNose()
        noseReductionWidth = CGFloat(Int(viewModel.face.noseWidth()*Face.noseListRatio[index]))
        noseReductionHalfWidth = noseReductionWidth!/CGFloat(2.0)
        
        let noseImage = cropNoseImage()
        let leftImage = cropLeftArea()
        let rightImage = cropRightArea()
        
        noseImageView = UIImageView(image: noseImage)
        view.addSubview(noseImageView)
        noseImageView.snp.makeConstraints { (make) in
            make.left.equalTo((viewModel.face.originNoseRect().origin.x)/screenScale + noseReductionHalfWidth!)
            make.top.equalTo((viewModel.face.originNoseRect().origin.y)/screenScale)
            make.width.equalTo(noseImage.size.width)
            make.height.equalTo(noseImage.size.height)
        }
        noseImageView.addGradientMask()
        
        leftImageView = UIImageView(image: leftImage)
        view.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.left.equalTo((viewModel.face.noseLeftAreaRect().origin.x)/screenScale)
            make.top.equalTo(viewModel.face.originNoseRect().origin.y/screenScale)
            make.width.equalTo(leftImage.size.width)
            make.height.equalTo(leftImage.size.height)
        }
        leftImageView.addGradientMask()
        
        rightImageView = UIImageView(image: rightImage)
        view.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { (make) in
            make.left.equalTo((viewModel.face.noseRightAreaRect().origin.x)/screenScale - noseReductionHalfWidth!)
            make.top.equalTo((viewModel.face.originNoseRect().origin.y)/screenScale)
            make.width.equalTo(rightImage.size.width)
            make.height.equalTo(rightImage.size.height)
        }
        rightImageView.addGradientMask()
    }
    
    func restoreNose() {
        leftImageView.removeFromSuperview()
        rightImageView.removeFromSuperview()
        noseImageView.removeFromSuperview()
    }
    
}

private typealias HandleFaceDetect = HandleImageViewController
extension HandleFaceDetect {
    
    /// 通过Face++远程识别人脸
    func checkFaceByRemote() {
        showLoading()
        viewModel.checkFaceByRemote(image: portraitImage)
    }
    
    /// 画关键点
    func drawMarks() {
        for mark in viewModel.keyMarks {
            let x = CGFloat(mark.x)/screenScale
            let y = CGFloat(mark.y)/screenScale
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: CGFloat(1.0), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.white.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            
            imageView.layer.addSublayer(shapeLayer)
        }
    }
    
    /// 抹除关键点
    func eraseMarks() {
        for layer in imageView.layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
    }
}

extension HandleImageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.blue.cgColor
        
        if indexPath.row == 0 {
            if currentToolsIndex == 0 {
                self.restoreEyelid()
            } else if currentToolsIndex == 1 {
                self.restoreNose()
            } else if currentToolsIndex == 2 {
                self.restoreEyeliner()
            }
        } else {
            let name = toolsData[indexPath.row]
            if currentToolsIndex == 0 {
                self.addDoubleEyelid(by: name)
            } else if currentToolsIndex == 1 {
                self.addNoseImage(index: indexPath.row)
            } else if currentToolsIndex == 2 {
                self.addEyeLiner(by: name)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.layer.borderWidth = 0
        cell.layer.borderColor = UIColor.clear.cgColor
    }
}

extension HandleImageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell\(currentToolsIndex)", for: indexPath) as! ToolsCell
        let name = toolsData[indexPath.row]
        cell.titleLabel.text = name
        cell.imageView.image = UIImage(named: name)
        return cell
    }
}
