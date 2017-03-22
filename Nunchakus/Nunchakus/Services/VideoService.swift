//
//  VideoService.swift
//  Nunchakus
//
//  Created by sungrow on 2017/3/22.
//  Copyright © 2017年 sungrow. All rights reserved.
//

import Foundation
import Moya

enum VideoService: TargetType {
    case video(type: VideoType, page: Int)
}

extension VideoService {
    var baseURL: URL {
        return URL(string: API_PRO)!
    }
    
    var path: String {
        switch self {
        case .video(type: let type, page: let curPage):
            return "/\(type)/\(curPage)/"
        }
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

private let endPointClosure = { (target: VideoService) -> Endpoint<VideoService> in
    let defaultEndpoint = MoyaProvider<VideoService>.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(parameters: publicParameters as [String : AnyObject]?, httpHeaderFields: headerFields, parameterEncoding: JSONEncoding.default)
}

let videoService = RxMoyaProvider.init(endpointClosure: endPointClosure, plugins: [RequestCloudLoadingPlugin()])
