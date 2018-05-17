//
//  ToolsCell.swift
//  FaceDemo
//
//  Created by Thierry on 2017/2/5.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ToolsCell: UICollectionViewCell {
    
    let width = UIScreen.main.bounds.size.width//获取屏幕宽
    var imageView = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(48)
        }
        self.addSubview(titleLabel)
        titleLabel.tintColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.height.equalTo(13)
        }
    }
    
}
