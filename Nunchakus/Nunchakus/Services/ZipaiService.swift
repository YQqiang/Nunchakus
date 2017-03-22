//
//  ZipaiService.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/22.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import Foundation
import Moya

enum ZipaiService: TargetType {
    case test
}

extension ZipaiService {
    var baseURL: URL {
        return URL(string: API_PRO)!
    }
    
    var path: String {
        return "/zipai/1/"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var parameters: [String: Any]? {
        return [:]
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .request
    }
}

private let endPointClosure = { (target: ZipaiService) -> Endpoint<ZipaiService> in
    let defaultEndpoint = MoyaProvider<ZipaiService>.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(parameters: publicParameters as [String : AnyObject]?, httpHeaderFields: headerFields, parameterEncoding: JSONEncoding.default)
}

let zipaiServiceProvider = RxMoyaProvider.init(endpointClosure: endPointClosure, plugins: [RequestCloudLoadingPlugin()])
