// POLocalizedString.h
//
// Created by Maxime Epain on 04/12/2017.
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Returns a localized version of the string designated by the specified msgid.

 @param msgid The msgid for a string in the template file.
 @return The result of invoking localizedStringForMsgid:context: on the localized bundle passing nil as the context.
 */
FOUNDATION_EXTERN NSString *POLocalizedString(NSString *msgid);

/**
 Returns a localized version of the string designated by the specified msgid.

 @param msgid The msgid for a string in the template file.
 @param context The context of the msgid.
 @return The result of invoking localizedStringForMsgid:context: on the localized bundle with the given context.
 */
FOUNDATION_EXTERN NSString *POLocalizedStringFromContext(NSString *msgid, NSString  * _Nullable context);

/**
 Returns a localized version of the format designated by the specified msgid, msgid_plural and the count n.

 @param msgid The msgid for a format in the template file.
 @param msgid_plural The msgid_plural for a format in the template file.
 @param n The number (e.g. item count) to determine the translation for the respective grammatical number.
 @return The result of invoking localizedFormatForMsgid:plural:count:context: on the localized bundle with the given context.
 */
FOUNDATION_EXTERN NSString *POLocalizedPluralFormat(NSString *msgid, NSString *msgid_plural, NSInteger n);

/**
 Returns a localized version of the format designated by the specified msgid, msgid_plural and the count n.
 
 @param msgid The msgid for a format in the template file.
 @param msgid_plural The msgid_plural for a format in the template file.
 @param n The number (e.g. item count) to determine the translation for the respective grammatical number.
 @param context The context for a format in the template file.
 @return The result of invoking localizedFormatForMsgid:plural:count:context: on the localized bundle passing nil as the context.
 */
FOUNDATION_EXTERN NSString *POLocalizedPluralFormatFromContext(NSString *msgid, NSString *msgid_plural, NSInteger n, NSString * _Nullable context);

/**
 Returns a localized version of the string designated by the specified msgid.

 @param bundle The bundle of the localization files.
 @param msgid The msgid for a string in the template file.
 @return The result of invoking localizedStringForMsgid:context: on the given bundle passing nil as the context.
 */
FOUNDATION_EXTERN NSString *POLocalizedStringInBundle(NSBundle *bundle, NSString *msgid);

/**
 Returns a localized version of the string designated by the specified msgid.

 @param bundle The bundle of the localization files.
 @param msgid The msgid for a string in the template file.
 @param context The context for a string in the template file.
 @return The result of invoking localizedFormatForMsgid:context: on the given bundle and context.
 */
FOUNDATION_EXTERN NSString *POLocalizedStringFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString * _Nullable context);

/**
 Returns a localized version of the format designated by the specified msgid, msgid_plural and the count n.
 
 @param bundle The bundle of the localization files.
 @param msgid The msgid for a format in the template file.
 @param msgid_plural The msgid_plural for a format in the template file.
 @param n The number (e.g. item count) to determine the translation for the respective grammatical number.
 @return The result of invoking localizedFormatForMsgid:plural:count:context: on the given bundle and passing nil as the context.
 */
FOUNDATION_EXTERN NSString *POLocalizedPluralFormatInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n);

/**
 Returns a localized version of the format designated by the specified msgid, msgid_plural and the count n.
 
 @param bundle The bundle of the localization files.
 @param msgid The msgid for a format in the template file.
 @param msgid_plural The msgid_plural for a format in the template file.
 @param n The number (e.g. item count) to determine the translation for the respective grammatical number.
 @param context The context for a format in the template file.
 @return The result of invoking localizedFormatForMsgid:plural:count:context: on the given bundle and context.
 */
FOUNDATION_EXTERN NSString *POLocalizedPluralFormatFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n, NSString * _Nullable context);

/**
 NSBundle extension with additions supporting gettext localization.
 */
@interface NSBundle (POLocalizedString)

/**
 The bundle object that contains the localization files.
 Returns the main bundle by default.
 */
@property (class, strong, null_resettable) NSBundle *localizedBundle;

/**
 The language iso code information. Returns the device preferred language by default.
 */
@property (nonatomic, copy, null_resettable) NSString *language;

/**
 Returns a localized version of the string designated by the specified msgid with the given context.

 @param msgid The msgid for a string in the template file.
 @param context The context for a string in the template file.
 @return A localized version of the string designated by msgid and context.
 */
- (NSString *)localizedStringForMsgid:(NSString *)msgid context:(nullable NSString *)context NS_FORMAT_ARGUMENT(1);

/**
 Returns a localized version of the format designated by the specified msgid, msgid_plural and the count n.

 @param msgid The msgid for a format in the template file.
 @param msgid_plural The msgid_plural for a format in the template file.
 @param count The number (e.g. item count) to determine the translation for the respective grammatical number.
 @param context The context for a format in the template file.
 @return A localized version of the format.
 */
- (NSString *)localizedFormatForMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context NS_FORMAT_ARGUMENT(1);

@end

/**
 NSString extension with additions supporting gettext localization.
 */
@interface NSString (POLocalizedString)

/**
 Returns an ascii representation of the receiver.
 */
@property (nonatomic, readonly) const char *ascii;

/**
 Returns an unicode representation of the receiver.
 */
@property (nonatomic, readonly) const char *unicode;

/**
 Returns an NSString object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization. This method is meant to be called from within a variadic function, where the argument list will be available.

 @param msgid a localized version of the string designated by the specified msgid.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An NSString object initialized by using format as a template into which the values in argList are substituted according to the current locale. The returned object may be different from the original receiver.
 */
+ (instancetype)localizedStringWithMsgid:(NSString *)msgid, ... NS_FORMAT_FUNCTION(1,2);

/**
 Returns an NSString object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization. This method is meant to be called from within a variadic function, where the argument list will be available.
 
 @param context The context for a string in the template file.
 @param msgid a localized version of the string designated by the specified msgid.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An NSString object initialized by using format as a template into which the values in argList are substituted according to the current locale. The returned object may be different from the original receiver.
 */
+ (instancetype)localizedStringFromContext:(NSString *)context msgid:(NSString *)msgid, ... NS_FORMAT_FUNCTION(2,3);

/**
 Returns an NSString object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization. This method is meant to be called from within a variadic function, where the argument list will be available.
 
 @param bundle The bundle of the localization files.
 @param msgid a localized version of the string designated by the specified msgid.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An NSString object initialized by using format as a template into which the values in argList are substituted according to the current locale. The returned object may be different from the original receiver.
 */
+ (instancetype)localizedStringInBundle:(NSBundle *)bundle msgid:(NSString *)msgid, ... NS_FORMAT_FUNCTION(2,3);

/**
 Returns an NSString object initialized by using a given format string as a template into which the remaining argument values are substituted without any localization. This method is meant to be called from within a variadic function, where the argument list will be available.
 
 @param context The context for a string in the template file.
 @param bundle The bundle of the localization files.
 @param msgid a localized version of the string designated by the specified msgid.
 @param ... A comma-separated list of arguments to substitute into format.
 @return An NSString object initialized by using format as a template into which the values in argList are substituted according to the current locale. The returned object may be different from the original receiver.
 */
+ (instancetype)localizedStringFromContext:(NSString *)context bundle:(NSBundle *)bundle msgid:(NSString *)msgid, ... NS_FORMAT_FUNCTION(3,4);

@end

#define _(msgid) POLocalizedString(msgid)
#define _x(msgid,ctx) POLocalizedStringFromContext(msgid,ctx)
#define _n(msgid,msgid_plural,n) POLocalizedPluralFormat(msgid,msgid_plural,n)
#define _nx(msgid,msgid_plural,n,ctx) POLocalizedPluralFormatFromContext(msgid,msgid_plural,n,ctx)

NS_ASSUME_NONNULL_END
