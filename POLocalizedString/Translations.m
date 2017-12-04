//
//  Translations.m
//  pomo
//
//  Created by pronebird on 3/28/11.
//  Copyright 2011 Andrej Mihajlov. All rights reserved.
//

#import "Translations.h"

@implementation Translations {
    NSMutableDictionary *_entries;
    NSMutableDictionary *_headers;
}

- (id)init {
	if(self = [super init]) {
		_entries = [NSMutableDictionary new];
		_headers = [NSMutableDictionary new];
	}
	return self;
}


- (void)addEntry:(POEntry *)entry {
	NSString *key = [entry key];
	
	if(key == nil)
		return;
	
    _entries[key] = entry;
}

- (void)setHeader:(NSString *)header value:(NSString *)value {
    _headers[header] = value;
}

- (NSUInteger)selectPluralForm:(NSInteger)count {
	return count == 1 ? 0 : 1;
}

- (NSUInteger)numPlurals {
	return 2;
}

- (NSString *)translate:(NSString *)singular {
	return [self translate:singular context:nil];
}

- (NSString *)translate:(NSString *)singular context:(NSString *)context {
    
    NSString *key = [POEntry stringKey:singular context:context];
	POEntry * entry = _entries[key];
	
	if(entry != nil && entry.translations.count) {
		return entry.translations.firstObject;
	}
	
	return singular;
}

- (NSString *)translatePlural:(NSString *)singular plural:(NSString *)plural count:(NSInteger)count context:(NSString *)context {
    
	NSString *key = [POEntry stringKey:singular context:context];
	POEntry *entry = _entries[key];
	
    NSUInteger index = [self selectPluralForm:count];
    NSUInteger nplurals = [self numPlurals];
	
    if(entry != nil && index < nplurals && index < entry.translations.count) {
		return entry.translations[index];
    }
	
	return count == 1 ? singular : plural;
}

@end
