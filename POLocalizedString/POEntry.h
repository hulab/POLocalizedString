//
//  POEntry.h
//  pomo
//
//  Created by pronebird on 3/28/11.
//  Copyright 2011 Andrej Mihajlov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface POEntry : NSObject

@property (assign) BOOL is_plural;
@property (strong, nonatomic, nullable) NSString *context;
@property (strong, nonatomic, nullable) NSString *singular;
@property (strong, nonatomic, nullable) NSString *plural;
@property (strong, nonatomic) NSMutableArray *translations;
@property (strong, nonatomic, nullable) NSString *translator_comments;
@property (strong, nonatomic, nullable) NSString *extracted_comments;
@property (strong, nonatomic) NSMutableArray *references;
@property (strong, nonatomic) NSMutableArray *flags;

@property (readonly, nonatomic) NSString *key;

+ (NSString *)stringKey:(NSString *)singular;
+ (NSString *)stringKey:(NSString *)singular context:(nullable NSString *)context;

- (void)debugPrint;

@end

NS_ASSUME_NONNULL_END
