// POLocalizedString.swift
//
// Created by Maxime Epain on 07/12/2017.
// Copyright © 2017 Hulab. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public extension String {
    
    /// Returns an ascii representation of the receiver.
    public var ascii: UnsafePointer<Int8> {
        return (self as NSString).ascii
    }
    
    /// Returns an unicode representation of the receiver.
    public var unicode: UnsafePointer<Int8> {
        return (self as NSString).unicode
    }
    
    /// Returns a localized version of the string.
    public var localized: String {
        return Bundle.localized.localizedString(forMsgid: self, context: nil)
    }
    
    /// Returns a localized version of the string.
    ///
    /// - Parameter context: The context of the msgid.
    /// - Returns: The localized version of the string.
    public func localized(from context: String) -> String {
        return Bundle.localized.localizedString(forMsgid: self, context: context)
    }
    
    /// Returns a localized version of the string in the given bundle.
    ///
    /// - Parameter bundle: The bundle of the localization files.
    /// - Returns: The localized version of the string.
    public func localized(in bundle: Bundle) -> String {
        return bundle.localizedString(forMsgid: self, context: nil)
    }
    
    /// Returns a localized version of the string.
    ///
    /// - Parameters:
    ///   - bundle: The bundle of the localization files.
    ///   - context: The context of the msgid.
    /// - Returns: The localized version of the string.
    public func localized(in bundle: Bundle, from context: String) -> String {
        return bundle.localizedString(forMsgid: self, context: context)
    }
    
    /// Returns an String object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization.
    /// This method is meant to be called from within a variadic function, where the argument list will be available.
    ///
    /// - Parameter arguments: A comma-separated list of arguments to substitute into format.
    /// - Returns: A String object initialized by using format as a template into which the values in arguments are substituted according to the current locale. The returned object may be different from the original receiver.
    public func localized(with arguments: CVarArg...) -> String {
        let format = Bundle.localized.localizedString(forMsgid: self, context: nil)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    /// Returns an String object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization.
    /// This method is meant to be called from within a variadic function, where the argument list will be available.
    ///
    /// - Parameters:
    ///   - context: The context of the msgid.
    ///   - arguments: A comma-separated list of arguments to substitute into format.
    /// - Returns: A String object initialized by using format as a template into which the values in arguments are substituted according to the current locale. The returned object may be different from the original receiver.
    public func localized(from context: String, with arguments: CVarArg...) -> String {
        let format = Bundle.localized.localizedString(forMsgid: self, context: context)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    /// Returns an String object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization.
    /// This method is meant to be called from within a variadic function, where the argument list will be available.
    ///
    /// - Parameters:
    ///   - bundle: The bundle of the localization files.
    ///   - arguments: A comma-separated list of arguments to substitute into format.
    /// - Returns: A String object initialized by using format as a template into which the values in arguments are substituted according to the current locale. The returned object may be different from the original receiver.
    public func localized(in bundle: Bundle, with arguments: CVarArg...) -> String {
        let format = bundle.localizedString(forMsgid: self, context: nil)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    /// Returns an String object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization.
    /// This method is meant to be called from within a variadic function, where the argument list will be available.
    ///
    /// - Parameters:
    ///   - bundle: The bundle of the localization files.
    ///   - context: The context of the msgid.
    ///   - arguments: A comma-separated list of arguments to substitute into format.
    /// - Returns: A String object initialized by using format as a template into which the values in arguments are substituted according to the current locale. The returned object may be different from the original receiver.
    public func localized(in bundle: Bundle, form context: String?, with arguments: CVarArg...) -> String {
        let format = bundle.localizedString(forMsgid: self, context: context)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    /// Returns an String object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization.
    /// This method is meant to be called from within a variadic function, where the argument list will be available.
    ///
    /// - Parameters:
    ///   - plural: The msgid_plural for a format in the template file.
    ///   - n: The number (e.g. item count) to determine the translation for the respective grammatical number.
    ///   - arguments: A comma-separated list of arguments to substitute into format.
    /// - Returns: A String object initialized by using format as a template into which the values in arguments are substituted according to the current locale. The returned object may be different from the original receiver.
    public func localized(plural: String, n: Int, with arguments: CVarArg...) -> String {
        let format = Bundle.localized.localizedFormat(forMsgid: self, plural: plural, count: n, context: nil)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    /// Returns an String object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization.
    /// This method is meant to be called from within a variadic function, where the argument list will be available.
    ///
    /// - Parameters:
    ///   - plural: The msgid_plural for a format in the template file.
    ///   - n: The number (e.g. item count) to determine the translation for the respective grammatical number.
    ///   - context: The context of the msgid.
    ///   - arguments: A comma-separated list of arguments to substitute into format.
    /// - Returns: A String object initialized by using format as a template into which the values in arguments are substituted according to the current locale. The returned object may be different from the original receiver.
    public func localized(plural: String, n: Int, from context: String, with arguments: CVarArg...) -> String {
        let format = Bundle.localized.localizedFormat(forMsgid: self, plural: plural, count: n, context: context)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    /// Returns an String object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization.
    /// This method is meant to be called from within a variadic function, where the argument list will be available.
    ///
    /// - Parameters:
    ///   - plural: The msgid_plural for a format in the template file.
    ///   - n: The number (e.g. item count) to determine the translation for the respective grammatical number.
    ///   - bundle: The bundle of the localization files.
    ///   - arguments: A comma-separated list of arguments to substitute into format.
    /// - Returns: A String object initialized by using format as a template into which the values in arguments are substituted according to the current locale. The returned object may be different from the original receiver.
    public func localized(plural: String, n: Int, in bundle: Bundle, with arguments: CVarArg...) -> String {
        let format = bundle.localizedFormat(forMsgid: self, plural: plural, count: n, context: nil)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
    
    /// Returns an String object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization.
    /// This method is meant to be called from within a variadic function, where the argument list will be available.
    ///
    /// - Parameters:
    ///   - plural: The msgid_plural for a format in the template file.
    ///   - n: The number (e.g. item count) to determine the translation for the respective grammatical number.
    ///   - bundle: The bundle of the localization files.
    ///   - context: The context of the msgid.
    ///   - arguments: A comma-separated list of arguments to substitute into format.
    /// - Returns: A String object initialized by using format as a template into which the values in arguments are substituted according to the current locale. The returned object may be different from the original receiver.
    public func localized(plural: String, n: Int, in bundle: Bundle, from context: String?, with arguments: CVarArg...) -> String {
        let format = bundle.localizedFormat(forMsgid: self, plural: plural, count: n, context: context)
        return withVaList(arguments) {
            NSString(format: format, arguments: $0)
        } as String
    }
}
