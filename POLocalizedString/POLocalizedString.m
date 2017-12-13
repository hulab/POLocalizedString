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

#import "Gettext.h"
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

@property (nonatomic, strong) Gettext *gettext;

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
    return objc_getAssociatedObject(self, @selector(language));
}

- (void)setLanguage:(NSString *)language {
    objc_setAssociatedObject(self, @selector(language), language, OBJC_ASSOCIATION_RETAIN);
    
    // Reset gettext
    objc_setAssociatedObject(self, @selector(gettext), nil, OBJC_ASSOCIATION_RETAIN);
}

- (Gettext *)gettext {
    Gettext *gettext = objc_getAssociatedObject(self, @selector(gettext));
    
    if (!gettext) {
        
        NSString *file = [self localizedFile];
        NSString *path = [self.bundlePath stringByAppendingPathComponent:file];
        
        if ([file hasSuffix:@".mo"]) {
            gettext = [MOParser loadFile:path];
        } else if([file hasSuffix:@".po"]) {
            gettext = [POParser loadFile:path];
        } else {
            gettext = [[Gettext alloc] init];
        }
        
        objc_setAssociatedObject(self, @selector(gettext), gettext, OBJC_ASSOCIATION_RETAIN);
    }
    
    return gettext;
}

- (NSString *)localizedFile {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray<NSString *> *files = [manager contentsOfDirectoryAtPath:self.bundlePath error:&error];
    if (!files) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    files = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mo' OR self ENDSWITH '.po'"]];
    
    // First check for the specified language.
    if (self.language) {
        
        NSString *file = [NSString stringWithFormat:@"%@.%@", self.language, @"mo"];
        if ([files containsObject:file]) {
            return file;
        }
        
        file = [NSString stringWithFormat:@"%@.%@", self.language, @"po"];
        if ([files containsObject:file]) {
            return file;
        }
        
        NSLog(@"The specified language is not available");
    }
    
    // Interate throught preferred languages to get a match.
    for (NSString *language in NSLocale.preferredLanguages) {
        NSString *iso = [language stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        
        NSArray *match = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", iso]];
        if (match.count) {
            self.language = iso;
            return match.firstObject;
        }
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:iso];
        if(![scanner scanUpToString:@"_" intoString:&iso]) {
            continue;
        }
        
        match = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", iso]];
        if (match.count) {
            self.language = iso;
            return match.firstObject;
        }
    }
    
    return nil;
}

- (NSString *)localizedStringForMsgid:(NSString *)msgid context:(nullable NSString *)context {
    return [self.gettext stringWithMsgid:msgid context:context];
}

- (NSString *)localizedFormatForMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context {
    return [self.gettext stringWithMsgid:msgid plural:msgid_plural count:count context:context];
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
    NSString *format = [bundle.gettext stringWithMsgid:msgid context:context];
    return [self initWithFormat:format arguments:argList];
}

@end

