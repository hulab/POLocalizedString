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

@property (nonatomic, strong) Gettext *source;

@property (nonatomic, strong) Gettext *translation;

@end

@interface Gettext (Load)

+ (Gettext *)sourceFromBundle:(NSBundle *)bundle;

+ (Gettext *)translationFromBundle:(NSBundle *)bundle;

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
    objc_setAssociatedObject(self, @selector(translation), nil, OBJC_ASSOCIATION_RETAIN);
}

- (id<POFormat>)format {
    id<POFormat> format = objc_getAssociatedObject(self, @selector(format));
    if (!format) {
        format = [[ObjCFormat alloc] init];
        objc_setAssociatedObject(self, @selector(format), format, OBJC_ASSOCIATION_RETAIN);
    }
    return format;
}

- (void)setFormat:(id<POFormat>)format {
    objc_setAssociatedObject(self, @selector(format), format, OBJC_ASSOCIATION_RETAIN);
}

- (Gettext *)source {
    Gettext *source = objc_getAssociatedObject(self, @selector(source));

    if (!source) {
        source = [Gettext sourceFromBundle:self];
        objc_setAssociatedObject(self, @selector(source), source, OBJC_ASSOCIATION_RETAIN);
    }

    return source;
}

- (Gettext *)translation {
    Gettext *translation = objc_getAssociatedObject(self, @selector(translation));
    
    if (!translation) {
        translation = [Gettext translationFromBundle:self];
        objc_setAssociatedObject(self, @selector(translation), translation, OBJC_ASSOCIATION_RETAIN);
    }
    
    return translation;
}

- (NSString *)localizedStringForMsgid:(NSString *)msgid context:(nullable NSString *)context {

    NSString *translation = [self.translation msgstrForMsgid:msgid context:context];
    if (translation && translation.length > 0) {
        return [self.format convertString:translation];
    }

    translation = [self.source msgstrForMsgid:msgid context:context];
    if (translation && translation.length > 0) {
        return [self.format convertString:translation];
    }
    
    return [self.format convertString:msgid];
}

- (NSString *)localizedFormatForMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context {

    NSString *translation = [self.translation msgstrForMsgid:msgid plural:msgid_plural count:count context:context];
    if (translation && translation.length > 0) {
        return [self.format convertString:translation];
    }

    translation = [self.source msgstrForMsgid:msgid plural:msgid_plural count:count context:context];
    if (translation && translation.length > 0) {
        return [self.format convertString:translation];
    }

    translation = count == 1 ? msgid : msgid_plural;
    return [self.format convertString:translation];
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
    NSString *format = [bundle localizedStringForMsgid:msgid context:context];
    return [self initWithFormat:format arguments:argList];
}

@end

@implementation Gettext (Load)

+ (Gettext *)gettext:(NSString *)file {
    if ([file hasSuffix:@".mo"]) {
        return [MOParser loadFile:file];
    }
    if([file hasSuffix:@".po"]) {
        return [POParser loadFile:file];
    }
    return [[Gettext alloc] init];
}

+ (Gettext *)sourceFromBundle:(NSBundle *)bundle {
    NSFileManager *manager = [NSFileManager defaultManager];

    NSError *error = nil;
    NSArray<NSString *> *files = [manager contentsOfDirectoryAtPath:bundle.resourcePath error:&error];
    if (!files) {
        NSLog(@"Error: %@", error);
        return nil;
    }

    files = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mo' OR self ENDSWITH '.po'"]];

    NSString *language = [bundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleDevelopmentRegionKey];
    if (language) {
        NSArray *match = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", language]];

        if (match.count) {
            NSString *file = [bundle.resourcePath stringByAppendingPathComponent:match.firstObject];
            return [self gettext:file];
        }
    }

    return nil;
}

+ (Gettext *)translationFromBundle:(NSBundle *)bundle {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray<NSString *> *files = [manager contentsOfDirectoryAtPath:bundle.resourcePath error:&error];
    if (!files) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    files = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.mo' OR self ENDSWITH '.po'"]];
    
    // First check for the specified language.
    if (bundle.language) {
        
        NSString *file = [NSString stringWithFormat:@"%@.%@", bundle.language, @"mo"];
        if ([files containsObject:file]) {
            file = [bundle.resourcePath stringByAppendingPathComponent:file];
            return [self gettext:file];
        }
        
        file = [NSString stringWithFormat:@"%@.%@", bundle.language, @"po"];
        if ([files containsObject:file]) {
            file = [bundle.resourcePath stringByAppendingPathComponent:file];
            return [self gettext:file];
        }
        
        NSLog(@"The specified language is not available");
    }
    
    // Iterate through preferred languages to get a match.
    for (NSString *language in NSLocale.preferredLanguages) {
        NSString *iso = [language stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        
        NSArray *match = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", iso]];
        if (match.count) {
            bundle.language = iso;
            NSString *file = [bundle.resourcePath stringByAppendingPathComponent:match.firstObject];
            return [self gettext:file];
        }
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:iso];
        if(![scanner scanUpToString:@"_" intoString:&iso]) {
            continue;
        }
        
        match = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", iso]];
        if (match.count) {
            bundle.language = iso;
            NSString *file = [bundle.resourcePath stringByAppendingPathComponent:match.firstObject];
            return [self gettext:file];
        }
    }
    
    return nil;
}

@end

