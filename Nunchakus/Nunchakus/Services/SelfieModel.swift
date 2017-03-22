//
//  SelfieModel.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/22.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import Kanna

class SelfieModel: NSObject {
    var title: String?
    var video: String?
    var img: String?
    var time: String?
    
    init(html: XMLElement) {
        self.time = html.at_xpath("span")?.content
        guard let a = html.at_xpath("a") else {
            return
        }
        self.title = a["title"]
        self.video = a["href"]
        if let imgNode = a.at_xpath("img") {
            img = imgNode["src"]
        }
    }
}
