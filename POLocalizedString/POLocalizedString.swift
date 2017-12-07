//
//  POLocalizedString.swift
//  POLocalizedString
//
//  Created by Maxime Epain on 07/12/2017.
//  Copyright © 2017 Hulab. All rights reserved.
//

import Foundation

public extension String {
    
    public var c_format: UnsafePointer<Int8> {
        return (self as NSString).utf8String!
    }
    
    public func localized() -> String {
        return Bundle.main.localizedString(forMsgid: self, context: nil)
    }
    
    public func localized(from context: String) -> String {
        return Bundle.main.localizedString(forMsgid: self, context: context)
    }
    
    public func localized(in bundle: Bundle) -> String {
        return bundle.localizedString(forMsgid: self, context: nil)
    }
    
    public func localized(in bundle: Bundle, from context: String) -> String {
        return bundle.localizedString(forMsgid: self, context: context)
    }
    
    public func localized(with arguments: CVarArg...) -> String {
        let format = Bundle.main.localizedString(forMsgid: self, context: nil)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    public func localized(from context: String, with arguments: CVarArg...) -> String {
        let format = Bundle.main.localizedString(forMsgid: self, context: context)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    public func localized(in bundle: Bundle, with arguments: CVarArg...) -> String {
        let format = bundle.localizedString(forMsgid: self, context: nil)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    public func localized(in bundle: Bundle, form context: String?, with arguments: CVarArg...) -> String {
        let format = bundle.localizedString(forMsgid: self, context: context)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    public func localized(plural: String, n: Int, with arguments: CVarArg...) -> String {
        let format = Bundle.main.localizedFormat(forMsgid: self, plural: plural, count: n, context: nil)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    public func localized(plural: String, n: Int, from context: String, with arguments: CVarArg...) -> String {
        let format = Bundle.main.localizedFormat(forMsgid: self, plural: plural, count: n, context: context)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    public func localized(plural: String, n: Int, in bundle: Bundle, with arguments: CVarArg...) -> String {
        let format = bundle.localizedFormat(forMsgid: self, plural: plural, count: n, context: nil)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    public func localized(plural: String, n: Int, in bundle: Bundle, from context: String?, with arguments: CVarArg...) -> String {
        let format = bundle.localizedFormat(forMsgid: self, plural: plural, count: n, context: context)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
}
