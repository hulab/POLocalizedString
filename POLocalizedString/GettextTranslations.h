//
//  GettextTranslations.h
//  pomo
//
//  Created by pronebird on 3/28/11.
//  Copyright 2011 Andrej Mihajlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Translations.h"

NS_ASSUME_NONNULL_BEGIN

@interface GettextTranslations : Translations

@property (readonly) NSUInteger numPlurals;

@property (nonatomic, nullable, readonly) NSString *pluralRule;

@end

NS_ASSUME_NONNULL_END
