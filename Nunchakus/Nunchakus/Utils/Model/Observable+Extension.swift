//
//  Observable+Extension.swift
//  operation4ios
//
//  Created by sungrow on 2017/2/18.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

import Foundation
import RxSwift
import Toaster

extension Observable {
    func showAPIErrorToast() -> Observable<Element> {
        return self.do(onNext: { (event) in
        }, onError: { (error) in
            Toast(text: "\(error.localizedDescription)").show()
        }, onCompleted: {
        }, onSubscribe: {
        }, onDispose: {
        })
    }
}
