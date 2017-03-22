//
//  PublicTool.swift
//  operation4ios
//
//  Created by sungrow on 2017/3/6.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

import Foundation

enum VideoType {
    case zipai      // 棍友自拍
    case biaoyan    // 舞台表演
    case jiaoxue    // 棍法教学
    case media      // 媒体关注
    case movie      // 影视动画
    case guowai     // 国外聚焦
    case paoku      // 极限跑酷
}

/*
 运算符重载: 中置      前置      后置
          infix    prefix   postfix
 组合赋值运算符: assignment
 自定义运算符:
 全局域使用 operator 关键字声明
 自定义中置运算符的优先级和结合性:
 结合性(associativity) 取值有: left right none
 优先级(precedence)  默认为100
 Operator should no longer be declared with body; use a precedence group instead
 */
infix operator ?* : FriendlyString
precedencegroup FriendlyString {
    associativity: left             // 左结合
    higherThan: AdditionPrecedence  // 优先级高于加法类型
    lowerThan: MultiplicationPrecedence // 优先级低于减法类型
}

/// ?* 代替系统的 ?? 使用, 可以过滤 "null" 字符串
/// 使用方法 例: str ?* "--"
/// 结果为: 如果`str` 为空 或 `null`, 则返回 "--"字符串
///
/// - Parameters:
///   - str: 原始字符串
///   - defaultStr: 代替的字符串
/// - Returns: 过滤后的字符串
func ?*(str: String?, defaultStr: String) -> String {
    let s = str ?? ""
    if s == "null" || s == "<null>" || s.isKind(of: NSNull.self) {
        return defaultStr
    }
    return s
}

/// 过滤字符串, 默认返回一个空字符 ""
///
/// - Parameter str: 原始字符串
/// - Returns: 过滤后的字符串
func defaultEmptyStr(_ str: String?) -> String {
    return str ?* ""
}

/// 过滤字符串, 默认返回一个 "--" 字符串
///
/// - Parameter str: 原始字符串
/// - Returns: 过滤后的字符串
func default__str(_ str: String?) -> String {
    return str ?* "--"
}
