//
//  GettextTranslations.mm
//  pomo
//
//  Created by pronebird on 3/28/11.
//  Copyright 2011 Andrej Mihajlov. All rights reserved.
//

#import "GettextTranslations.h"
#import "muParserInt.h"

@implementation GettextTranslations {
	mu::ParserInt * muParser;
}

- (instancetype)init {
	if(self = [super init]) {
		_numPlurals = 0;
		_pluralRule = nil;
		
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

- (void)setHeader:(NSString*)header value:(NSString*)value {
	[super setHeader:header value:value];
	
	if([header isEqualToString:@"Plural-Forms"]) {
        
		NSDictionary *dict = [self _scanPluralFormsString:self.headers[header]];
		NSString *nplurals = dict[@"nplurals"];
		NSString *rule = dict[@"plural"];
		
        _numPlurals = nplurals ? nplurals.integerValue : 0;
		
		if(rule) {
			_pluralRule = [rule stringByReplacingOccurrencesOfString:@";" withString:@""];
			muParser->SetExpr(self.pluralRule.UTF8String);
		} else {
            _pluralRule = nil;
		}
		
        //NSLog(@"nplurals: %@. rule: %@", nplurals, rule);
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
	
	return [super selectPluralForm:count];
}

@end
