//
//  MaskUIImageView.swift
//  FaceDemo
//
//  Created by Thierry on 2017/2/21.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func addGradientMask() {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 0.1, 0.5, 0.9, 1.0]
        self.layer.mask = gradient
    }
    
}
