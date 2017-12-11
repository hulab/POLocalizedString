//
//  POLocalizedString.m
//  POLocalizedString
//
//  Created by Maxime Epain on 04/12/2017.
//  Copyright © 2017 Hulab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "POLocalizedString.h"

#import "Translations.h"
#import "GettextTranslations.h"
#import "NOTranslations.h"
#import "POParser.h"
#import "MOParser.h"

NSString *POLocalizedString(NSString *msgid) {
    return POLocalizedStringFromContextInBundle(NSBundle.mainBundle, msgid, nil);
}

NSString *POLocalizedStringFromContext(NSString *msgid, NSString *context) {
    return POLocalizedStringFromContextInBundle(NSBundle.mainBundle, msgid, context);
}

NSString *POLocalizedPluralFormat(NSString *msgid, NSString *msgid_plural, NSInteger n) {
    return POLocalizedPluralFormatFromContextInBundle(NSBundle.mainBundle, msgid, msgid_plural, n, nil);
}

NSString *POLocalizedPluralFormatFromContext(NSString *msgid, NSString *msgid_plural, NSInteger n, NSString *context) {
    return POLocalizedPluralFormatFromContextInBundle(NSBundle.mainBundle, msgid, msgid_plural, n, context);
}

NSString *POLocalizedStringInBundle(NSBundle *bundle, NSString *msgid) {
    return POLocalizedStringFromContextInBundle(bundle, msgid, nil);
}

NSString *POLocalizedStringFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *context) {
    return [bundle localizedStringForMsgid:msgid context:context];
}

NSString *POLocalizedPluralFormatInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n) {
    return POLocalizedPluralFormatFromContextInBundle(bundle, msgid, msgid_plural, n, nil);
}

NSString *POLocalizedPluralFormatFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n, NSString *context) {
    return [bundle localizedFormatForMsgid:msgid plural:msgid_plural count:n context:context];
}

@interface NSBundle ()

@property (nonatomic, strong) Translations *translator;

@end

@implementation NSBundle (POLocalizedString)

- (Translations *)translator {
    Translations *translator = objc_getAssociatedObject(self, @selector(translator));
    if (!translator) {
        
        NSString *preferredLanguage = [[NSLocale preferredLanguages] firstObject];
        NSScanner *scanner = [[NSScanner alloc] initWithString:preferredLanguage];
        NSString *language;
        
        if(![scanner scanUpToString:@"-" intoString:&language]) {
            language = preferredLanguage;
        }
        
        NSString *filename = [NSString stringWithFormat:@"%@.%@", language, @"mo"];
        NSString *path = [self.bundlePath stringByAppendingPathComponent:filename];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:path]) {
            MOParser *parser = [MOParser new];
            [parser importFileAtPath:path];
            
            objc_setAssociatedObject(self, @selector(translator), parser, OBJC_ASSOCIATION_RETAIN);
            return parser;
        }
        
        filename = [NSString stringWithFormat:@"%@.%@", language, @"po"];
        path = [self.bundlePath stringByAppendingPathComponent:filename];
        
        if([fileManager fileExistsAtPath:path]) {
            POParser *parser = [POParser new];
            [parser importFileAtPath:path];
            
            objc_setAssociatedObject(self, @selector(translator), parser, OBJC_ASSOCIATION_RETAIN);
            return parser;
        }
        
        translator = [NOTranslations new];
        objc_setAssociatedObject(self, @selector(translator), translator, OBJC_ASSOCIATION_RETAIN);
    }
    
    return translator;
}

- (NSString *)localizedStringForMsgid:(NSString *)msgid context:(nullable NSString *)context {
    return [self.translator translate:msgid context:context];
}

- (NSString *)localizedFormatForMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context {
    return [self.translator translatePlural:msgid plural:msgid_plural count:count context:context];
}

@end

@implementation NSString (POLocalizedString)

- (const char *)ascii {
    return [self cStringUsingEncoding:NSASCIIStringEncoding];
}

- (const char *)unicode {
    return [self cStringUsingEncoding:NSUnicodeStringEncoding];
}

+ (instancetype)localizedStringWithMsgid:(NSString *)msgid, ... {
    va_list args;
    va_start(args, msgid);
    NSString *str = [[self alloc] initWithMsgid:msgid arguments:args bundle:NSBundle.mainBundle context:nil];
    va_end(args);
    return str;
}

+ (instancetype)localizedStringFromContext:(NSString *)context msgid:(NSString *)msgid, ... {
    va_list args;
    va_start(args, msgid);
    NSString *str = [[self alloc] initWithMsgid:msgid arguments:args bundle:NSBundle.mainBundle context:context];
    va_end(args);
    return str;
}

+ (instancetype)localizedStringInBundle:(NSBundle *)bundle msgid:(NSString *)msgid, ... {
    va_list args;
    va_start(args, msgid);
    NSString *str = [[self alloc] initWithMsgid:msgid arguments:args bundle:bundle context:nil];
    va_end(args);
    return str;
}

+ (instancetype)localizedStringFromContext:(NSString *)context bundle:(NSBundle *)bundle msgid:(NSString *)msgid, ... {
    va_list args;
    va_start(args, msgid);
    NSString *str = [[self alloc] initWithMsgid:msgid arguments:args bundle:bundle context:context];
    va_end(args);
    return str;
}

- (instancetype)initWithMsgid:(NSString *)msgid arguments:(va_list)argList bundle:(NSBundle *)bundle context:(NSString *)context {
    NSString *format = [bundle.translator translate:msgid context:context];  
    return [self initWithFormat:format arguments:argList];
}

@end

