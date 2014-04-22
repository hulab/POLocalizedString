//
//  Translations.h
//  pomo
//
//  Created by pronebird on 3/28/11.
//  Copyright 2011 Andrej Mihajlov. All rights reserved.
//

#import "TranslationEntry.h"
#import "TranslationsProtocol.h"


@interface Translations : NSObject<TranslationsProtocol>

@property (readonly, nonatomic, strong) NSMutableDictionary* entries;
@property (readonly, nonatomic, strong) NSMutableDictionary* headers;

@end
