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

FOUNDATION_EXTERN NSString *POLocalizedPluralString(NSString *msgid, NSString *msgid_plural, NSInteger n);

FOUNDATION_EXTERN NSString *POLocalizedPluralStringFromContext(NSString *msgid, NSString *msgid_plural, NSInteger n, NSString * _Nullable context);

FOUNDATION_EXTERN NSString *POLocalizedStringInBundle(NSBundle *bundle, NSString *msgid);

FOUNDATION_EXTERN NSString *POLocalizedStringFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString * _Nullable context);

FOUNDATION_EXTERN NSString *POLocalizedPluralStringInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n);

FOUNDATION_EXTERN NSString *POLocalizedPluralStringFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n, NSString * _Nullable context);


@interface NSBundle (POLocalizedString)

- (NSString *)localizedStringForMsgid:(NSString *)msgid context:(nullable NSString *)context NS_FORMAT_ARGUMENT(1);

- (NSString *)localizedStringForMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context NS_FORMAT_ARGUMENT(1);

@end

#define _n_noop(singular, plural, domain)
#define _nx_noop(singular, plural, context, domain)

NS_ASSUME_NONNULL_END
