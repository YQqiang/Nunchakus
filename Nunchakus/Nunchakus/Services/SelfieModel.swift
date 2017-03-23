//
//  SelfieModel.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/22.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import UIKit
import Kanna

class SelfieModel: BaseModel {
    var title: String?
    var video: String?
    var img: String?
    var time: String?
    
    override init(html: XMLElement) {
        super.init(html: html)
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

extension SelfieModel {
    class func isHaveNextPage(html: XPathObject) -> Bool {
        let maxCount = html[html.count - 1]["href"]?.components(separatedBy: "/")
        guard let maxC = maxCount, maxC.count >= 2 else {
            return false
        }
        let max = maxC[maxC.count - 2]
        for a in html {
            if (a.className == "now") {
                return max != (a.content ?? "1")
            }
        }
        return false
    }
}
