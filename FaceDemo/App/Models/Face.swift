//
//  Eyes.swift
//  FaceDemo
//
// https://console.faceplusplus.com.cn/documents/5671270
//
//  Created by Thierry on 2017/2/1.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import Foundation
import ObjectMapper

/// 关键点
struct KeyMark: Mappable {
    
    var x: Int = 0
    var y: Int = 0
    
    init?(map: Map) {
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    mutating func mapping(map: Map) {
        x  <- map["x"]
        y  <- map["y"]
    }
}


/// 人面部模型
struct Face: Mappable {
    
    let screenScale = UIScreen.main.scale
    
    var leftEyeTop: KeyMark = KeyMark(x: 0, y: 0)
    var leftEyeRightCorner: KeyMark = KeyMark(x: 0, y: 0)
    var leftEyeUpperRightQuarter: KeyMark = KeyMark(x: 0, y: 0)
    var leftEyeLeftCorner: KeyMark = KeyMark(x: 0, y: 0)
    var leftEyeBottom: KeyMark = KeyMark(x: 0, y: 0)
    
    var rightEyeTop: KeyMark = KeyMark(x: 0, y: 0)
    var rightEyeRightCorner: KeyMark = KeyMark(x: 0, y: 0)
    var rightEyeUpperLeftQuarter: KeyMark = KeyMark(x: 0, y: 0)
    var rightEyeLeftCorner: KeyMark = KeyMark(x: 0, y: 0)
    var rightEyeBottom: KeyMark = KeyMark(x: 0, y: 0)
    
    var leftNoseTop: KeyMark = KeyMark(x: 0, y: 0)
    var leftNoseBottom: KeyMark = KeyMark(x: 0, y: 0)
    var middleNoseBottom: KeyMark = KeyMark(x: 0, y: 0)
    var rightNoseTop: KeyMark = KeyMark(x: 0, y: 0)
    var rightNoseBottom: KeyMark = KeyMark(x: 0, y: 0)
    
    /// 双眼皮默认的倾斜角度
    var defaultEyelidRad: Double = Double(Double.pi*1.0/180.0)
    
    /// 双眼皮高度和眼高度比
    var eyeLidTHRatio: Float = Float(6.0/18.0)
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        leftEyeTop                  <- map["left_eye_top"]
        leftEyeRightCorner          <- map["left_eye_right_corner"]
        leftEyeLeftCorner           <- map["left_eye_left_corner"]
        leftEyeBottom               <- map["left_eye_bottom"]
        leftEyeUpperRightQuarter    <- map["left_eye_upper_right_quarter"]
        
        rightEyeTop                 <- map["right_eye_top"]
        rightEyeRightCorner         <- map["right_eye_right_corner"]
        rightEyeLeftCorner          <- map["right_eye_left_corner"]
        rightEyeBottom              <- map["right_eye_bottom"]
        rightEyeUpperLeftQuarter    <- map["right_eye_upper_left_quarter"]
        
        leftNoseTop                 <- map["nose_contour_left1"]
        leftNoseBottom              <- map["nose_left"]
        middleNoseBottom            <- map["nose_contour_lower_middle"]
        rightNoseTop                <- map["nose_contour_right1"]
        rightNoseBottom             <- map["nose_right"]
    }
    
}
