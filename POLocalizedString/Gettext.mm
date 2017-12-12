// Gettext.mm
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

#import "Gettext.h"
#import "muParserInt.h"

@implementation Gettext {
    NSMutableDictionary *_entries;
    NSMutableDictionary *_headers;
	mu::ParserInt * muParser;
}

- (instancetype)init {
    
	if(self = [super init]) {
		_numPlurals = 2;
		_pluralRule = nil;
        
        _entries = [NSMutableDictionary dictionary];
        _headers = [NSMutableDictionary dictionary];
		
		muParser = new mu::ParserInt();
		muParser->EnableBuiltInOprt();
		muParser->DefineOprt("%", fmod, 5);
	}
	return self;
}

- (void)dealloc {
	delete muParser;
	muParser = NULL;
}

- (NSDictionary<NSString *,NSString *> *)headers {
    return _headers.copy;
}

- (NSDictionary<NSString *,POEntry *> *)entries {
    return _entries.copy;
}

- (void)addEntry:(POEntry *)entry {
    NSString *key = [entry key];
    
    if(key == nil)
        return;
    
    _entries[key] = entry;
}

- (NSString *)stringWithMsgid:(NSString *)msgid context:(nullable NSString *)context {
    
    NSString *key = [POEntry keyWithMsgid:msgid context:context];
    POEntry *entry = _entries[key];
    
    if(entry != nil && entry.translations.count) {
        return entry.translations.firstObject;
    }
    
    return msgid;
}

- (NSString *)stringWithMsgid:(NSString *)msgid plural:(NSString *)msgid_plural count:(NSInteger)count context:(nullable NSString *)context{
    
    NSString *key = [POEntry keyWithMsgid:msgid context:context];
    POEntry *entry = _entries[key];
    
    NSUInteger index = [self selectPluralForm:count];
    NSUInteger nplurals = [self numPlurals];
    
    if(entry != nil && index < nplurals && index < entry.translations.count) {
        return entry.translations[index];
    }
    
    return count == 1 ? msgid : msgid_plural;
}

- (NSDictionary *)_scanPluralFormsString:(NSString *)src {
    
	NSMutableDictionary *result = [NSMutableDictionary new];
	NSArray *strings = [src componentsSeparatedByString:@";"];
	NSCharacterSet *charset = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
	for(NSString *str in strings)  {
		NSScanner *scanner = [NSScanner scannerWithString:str];
		NSString *key = nil;
		
		if([scanner scanUpToString:@"=" intoString:&key]) {

            key = [key stringByTrimmingCharactersInSet:charset];
            result[key] = [[str substringFromIndex:scanner.scanLocation + 1] stringByTrimmingCharactersInSet:charset];
		}
	}
	
	return result;
}

- (void)setHeader:(NSString *)header forKey:(NSString *)key {
	_headers[key] = header;
	
	if([key isEqualToString:@"Plural-Forms"]) {
        
		NSDictionary *dict = [self _scanPluralFormsString:header];
		NSString *nplurals = dict[@"nplurals"];
		NSString *rule = dict[@"plural"];
		
        _numPlurals = nplurals ? nplurals.integerValue : 0;
		
		if(rule) {
			_pluralRule = [rule stringByReplacingOccurrencesOfString:@";" withString:@""];
			muParser->SetExpr(self.pluralRule.UTF8String);
		} else {
            _pluralRule = nil;
		}
	}
}

- (NSUInteger)selectPluralForm:(NSInteger)count {
	double retval;
	
	if(self.pluralRule) {
		muParser->DefineConst("n", count);
		
		try {
			retval = muParser->Eval();
			return (NSUInteger)retval;
		} catch (mu::ParserInt::exception_type &e) {
			std::cerr << "Gettext parser error: " << e.GetMsg() << std::endl;
		}
	}
	
	return count == 1 ? 0 : 1;
}

@end
