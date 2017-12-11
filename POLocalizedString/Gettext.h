// Gettext.h
//
// Created by pronebird on 3/28/11.
// Copyright 2011 Andrej Mihajlov. All rights reserved.
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
#import "POEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface Gettext : NSObject

@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *headers;

@property (nonatomic, readonly, copy) NSDictionary<NSString *, POEntry *> *entries;

@property (readonly) NSUInteger numPlurals;

@property (nonatomic, nullable, readonly) NSString *pluralRule;

- (void)addEntry:(POEntry *)entry;

- (void)setHeader:(NSString *)header value:(NSString *)value;

- (NSUInteger)selectPluralForm:(NSInteger)count;

- (NSString *)stringWithMsgid:(NSString *)msgid context:(nullable NSString *)context;

- (NSString *)stringWithMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context;

@end

NS_ASSUME_NONNULL_END
