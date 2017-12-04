//
//  Translations.h
//  pomo
//
//  Created by pronebird on 3/28/11.
//  Copyright 2011 Andrej Mihajlov. All rights reserved.
//

#import "POEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface Translations : NSObject

@property (nonatomic, readonly, copy) NSDictionary<NSString *, POEntry *> *entries;

@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *headers;

- (void)addEntry:(POEntry *)entry;

- (void)setHeader:(NSString *)header value:(NSString *)value;

- (NSUInteger)selectPluralForm:(NSInteger)count;

- (NSUInteger)numPlurals;

- (NSString *)translate:(NSString *)singular;

- (NSString *)translate:(NSString *)singular context:(nullable NSString *)context;

- (NSString *)translatePlural:(NSString *)singular plural:(NSString *)plural count:(NSInteger)count context:(NSString *)context;

@end

NS_ASSUME_NONNULL_END
