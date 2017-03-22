//
//  API.swift
//  operation4ios
//
//  Created by sungrow on 2017/2/17.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

import Foundation
import Moya
import Result

let API_PRO = "http://www.sjg8.com"

/// 请求头--日志信息
private let deviceName = UIDevice.current.name  //获取设备名称 例如：某某的手机
private let sysName = UIDevice.current.systemName //获取系统名称 例如：iPhone OS
private let sysVersion = UIDevice.current.systemVersion //获取系统版本 例如：9.2
private let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""  //获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
private let infoDic = Bundle.main.infoDictionary
private let identifier = (infoDic?["CFBundleIdentifier"] as? String) ?? ""
private let appVersion = (infoDic?["CFBundleShortVersionString"] as? String) ?? "" // 获取App的版本
private let appBuildVersion = (infoDic?["CFBundleVersion"] as? String) ?? "" // 获取App的build版本
private let appName = (infoDic?["CFBundleDisplayName"] as? String) ?? "" // 获取App的名称
private let system_info = "\(appName)/\(identifier)/\(appVersion)_\(appBuildVersion)/iOS(\(deviceName)|\(sysName)|\(sysVersion)|\(deviceUUID))"
var headerFields: [String: String] = ["User-Agent": "sungrow-agent", "system": "iOS","sys_ver": String(UIDevice.version()), "system_info": system_info]
/// 公共参数--(token 需要在每个接口中获取)
var publicParameters: [String: String] = ["language": NSLocalizedString("Language", comment: "")]

final class RequestCloudLoadingPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        Hud.show(status: NSLocalizedString("正在加载", comment: ""))
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        Hud.dismissHUD()
    }
}
