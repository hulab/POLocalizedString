// POEntry.m
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

#import "POEntry.h"


@implementation POEntry

- (id)init {
	if(self = [super init]) {
		self.context = nil;
		self.msgid = nil;
		self.msgid_plural = nil;
		self.translations = [NSMutableArray new];
		self.translator_comments = nil;
		self.extracted_comments = nil;
		self.references = [NSMutableArray new];
		self.flags = [NSMutableArray new];
	}
	return self;
}


- (NSString *)key {
	return [POEntry keyWithMsgid:self.msgid context:self.context];
}

+ (NSString *)keyWithMsgid:(NSString *)msgid context:(NSString *)context {
    if (msgid == nil) {
		return nil;
    }
	
    if (context == nil || [context isEqualToString:@""]) {
        return msgid;
    }
    
	return [NSString stringWithFormat:@"%@%c%@", context, '\4', msgid];
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"new entry\nsingular: %@\nplural: %@\ntranslator comments:%@\n", self.msgid, self.msgid_plural, self.translator_comments];
	
	[description appendString:@"translations:\n"];
     
	NSUInteger i = 0;
	for (NSString * tr in self.translations) {
        [description appendFormat:@"[%lu] %@\n", (unsigned long)i++, tr];
	}
	
    [description appendString:@"references:\n"];
    
	i = 0;
	for (NSString * ref in self.references) {
        [description appendFormat:@"[%lu] %@\n", (unsigned long)i++, ref];
	}
	
    [description appendString:@"flags:\n"];
    
	i = 0;
	for (NSString *flag in self.flags) {
        [description appendFormat:@"[%lu] %@\n", (unsigned long)i++, flag];
	}
	
    [description appendString:@"--"];
    
     return description;
}

@end
