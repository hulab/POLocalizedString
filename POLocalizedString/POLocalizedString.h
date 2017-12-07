//
//  POLocalizedString.h
//  pomo
//
//  Created by Andrej Mihajlov on 4/7/12.
//  Copyright (c) 2012 Andrej Mihajlov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *POLocalizedString(NSString *msgid);

FOUNDATION_EXTERN NSString *POLocalizedStringFromContext(NSString *msgid, NSString  * _Nullable context);

FOUNDATION_EXTERN NSString *POLocalizedPluralFormat(NSString *msgid, NSString *msgid_plural, NSInteger n);

FOUNDATION_EXTERN NSString *POLocalizedPluralFormatFromContext(NSString *msgid, NSString *msgid_plural, NSInteger n, NSString * _Nullable context);

FOUNDATION_EXTERN NSString *POLocalizedStringInBundle(NSBundle *bundle, NSString *msgid);

FOUNDATION_EXTERN NSString *POLocalizedStringFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString * _Nullable context);

FOUNDATION_EXTERN NSString *POLocalizedPluralFormatInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n);

FOUNDATION_EXTERN NSString *POLocalizedPluralFormatFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n, NSString * _Nullable context);


@interface NSBundle (POLocalizedString)

- (NSString *)localizedStringForMsgid:(NSString *)msgid context:(nullable NSString *)context NS_FORMAT_ARGUMENT(1);

- (NSString *)localizedFormatForMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context NS_FORMAT_ARGUMENT(1);

@end

@interface NSString (POLocalizedString)

+ (instancetype)localizedStringWithMsgid:(NSString *)msgid, ... NS_FORMAT_FUNCTION(1,2);

+ (instancetype)localizedStringFromContext:(NSString *)context msgid:(NSString *)msgid, ... NS_FORMAT_FUNCTION(2,3);

+ (instancetype)localizedStringInBundle:(NSBundle *)bundle msgid:(NSString *)msgid, ... NS_FORMAT_FUNCTION(2,3);

+ (instancetype)localizedStringFromContext:(NSString *)context bundle:(NSBundle *)bundle msgid:(NSString *)msgid, ... NS_FORMAT_FUNCTION(3,4);

- (instancetype)initWithMsgid:(NSString *)msgid arguments:(va_list)argList bundle:(NSBundle *)bundle context:(nullable NSString *)context;

@end

#define _n_noop(singular, plural, domain)
#define _nx_noop(singular, plural, context, domain)

NS_ASSUME_NONNULL_END
