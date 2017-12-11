// POLocalizedString.m
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
// THE SOFTWARE.opyright © 2017 Hulab. All rights reserved.
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
    return [NSBundle.localizedBundle localizedStringForMsgid:msgid context:nil];
}

NSString *POLocalizedStringFromContext(NSString *msgid, NSString *context) {
    return [NSBundle.localizedBundle localizedStringForMsgid:msgid context:context];
}

NSString *POLocalizedPluralFormat(NSString *msgid, NSString *msgid_plural, NSInteger n) {
    return [NSBundle.localizedBundle localizedFormatForMsgid:msgid plural:msgid_plural count:n context:nil];
}

NSString *POLocalizedPluralFormatFromContext(NSString *msgid, NSString *msgid_plural, NSInteger n, NSString *context) {
    return [NSBundle.localizedBundle localizedFormatForMsgid:msgid plural:msgid_plural count:n context:context];
}

NSString *POLocalizedStringInBundle(NSBundle *bundle, NSString *msgid) {
    return [bundle localizedStringForMsgid:msgid context:nil];
}

NSString *POLocalizedStringFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *context) {
    return [bundle localizedStringForMsgid:msgid context:context];
}

NSString *POLocalizedPluralFormatInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n) {
    return [bundle localizedFormatForMsgid:msgid plural:msgid_plural count:n context:nil];
}

NSString *POLocalizedPluralFormatFromContextInBundle(NSBundle *bundle, NSString *msgid, NSString *msgid_plural, NSInteger n, NSString *context) {
    return [bundle localizedFormatForMsgid:msgid plural:msgid_plural count:n context:context];
}

@interface NSBundle ()

@property (nonatomic, strong) Translations *translator;

@end

@implementation NSBundle (POLocalizedString)

static NSBundle *localizedBundle = nil;

+ (NSBundle *)localizedBundle {
    if (localizedBundle) {
        return localizedBundle;
    }
    return NSBundle.mainBundle;
}

+ (void)setLocalizedBundle:(NSBundle *)bundle {
    localizedBundle = bundle;
}

- (NSString *)language {
    NSString *language = objc_getAssociatedObject(self, @selector(language));
    
    if (!language) {
        NSString *preferredLanguage = NSLocale.preferredLanguages.firstObject;
        NSScanner *scanner = [[NSScanner alloc] initWithString:preferredLanguage];
        
        if(![scanner scanUpToString:@"-" intoString:&language]) {
            language = preferredLanguage;
        }
        
        objc_setAssociatedObject(self, @selector(language), language, OBJC_ASSOCIATION_RETAIN);
    }
    return language;
}

- (void)setLanguage:(NSString *)language {
    objc_setAssociatedObject(self, @selector(language), language, OBJC_ASSOCIATION_RETAIN);
    
    // Reset translator
    objc_setAssociatedObject(self, @selector(translator), nil, OBJC_ASSOCIATION_RETAIN);
}

- (Translations *)translator {
    Translations *translator = objc_getAssociatedObject(self, @selector(translator));
    
    if (!translator) {
        
        NSString *language = self.language;

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
    NSString *str = [[self alloc] initWithMsgid:msgid arguments:args bundle:NSBundle.localizedBundle context:nil];
    va_end(args);
    return str;
}

+ (instancetype)localizedStringFromContext:(NSString *)context msgid:(NSString *)msgid, ... {
    va_list args;
    va_start(args, msgid);
    NSString *str = [[self alloc] initWithMsgid:msgid arguments:args bundle:NSBundle.localizedBundle context:context];
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

