//
//  HandleFaceViewModel.swift
//  FaceDemo
//
//  Created by Thierry on 2017/3/16.
//  Copyright © 2017年 Gengmei. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Observable


enum FetchDataResult: Int {
    case normal = -1
    case success = 0
    case failed = 1
}


class HandleFaceViewModel: NSObject {
    
    var face: Face!
    var keyMarks: [KeyMark] = [KeyMark]()
    
    let apiKey = "VFZ80NNdS-zIqnlFJClzlM8iq4ZVHqa3"
    let apiSecret = "BxIeNVw26xas1KbcWGzL8zlF1kMy0gdj"
    let apiURL = "https://api-cn.faceplusplus.com/facepp/v3/detect"
    
    public var fetchDataResult = Observable(FetchDataResult.normal.rawValue)
    
    /// 通过Face++远程识别人脸
    func checkFaceByRemote(image: UIImage) {
        
        // define parameters
        let parameters = [
            "api_key": apiKey,
            "api_secret": apiSecret,
            "return_landmark": "1"
            ] as [String : String]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 1) {
                    multipartFormData.append(imageData, withName: "image_file", fileName: "demo.png", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            },
            to: apiURL,
            encodingCompletion: {[weak self] encodingResult in
                if let strongSelf = self {
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            strongSelf.parseData(data: JSON(response.result.value!))
                            strongSelf.fetchDataResult.value = FetchDataResult.success.rawValue
                        }
                    case .failure(let encodingError):
                        debugPrint(encodingError)
                        strongSelf.fetchDataResult.value = FetchDataResult.failed.rawValue
                    }
                }
        })
    }
    
    /// 解析人脸数据
    ///
    /// - Parameter json: json数据
    func parseData(data: JSON) {
        if let landmarks = data["faces"][0]["landmark"].dictionaryObject {
            debugPrint(landmarks)
            self.buildFace(landmarks: landmarks)
        } else {
            debugPrint("No landmarks")
        }
    }
    
    /// 在脸部标记所有的关键点, 构造面部数据结构
    ///
    /// - Parameter landmarks: 所有的关键点
    func buildFace(landmarks: [String : Any]) {
        face = Face(JSON: landmarks)
        for (_, value) in landmarks {
            let mark = value as! Dictionary<String, Int>
            let x = mark["x"] ?? 0
            let y = mark["y"] ?? 0
            keyMarks.append(KeyMark(x: x, y: y))
        }
    }
}
