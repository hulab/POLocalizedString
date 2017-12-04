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

NSString *POLocalizedPluralString(NSString *msgid, NSString *msgid_plural, NSInteger n) {
    return POLocalizedPluralStringFromContextInBundle(NSBundle.mainBundle, msgid, msgid_plural, n, nil);
}

NSString *POLocalizedPluralStringFromContext(NSString *msgid, NSString *msgid_plural, NSInteger n, NSString *context) {
    return POLocalizedPluralStringFromContextInBundle(NSBundle.mainBundle, msgid, msgid_plural, n, context);
}

NSString *POLocalizedStringInBundle(NSBundle *bundle, NSString *msgid) {
    return POLocalizedStringFromContextInBundle(bundle, msgid, nil);
}

NSString *POLocalizedStringFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *context) {
    return [bundle localizedStringForMsgid:msgid context:context];
}

NSString *POLocalizedPluralStringInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n) {
    return POLocalizedPluralStringFromContextInBundle(bundle, msgid, msgid_plural, n, nil);
}

NSString *POLocalizedPluralStringFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n, NSString *context) {
    return [bundle localizedStringForMsgid:msgid plural:msgid_plural count:n context:context];
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

- (NSString *)localizedStringForMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context {
    return [self.translator translatePlural:msgid plural:msgid_plural count:count context:context];
}

@end
