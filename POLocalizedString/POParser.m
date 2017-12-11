// POParser.m
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

#import "POParser.h"

@interface NSString (PO)

- (NSString *)decodePO;

- (NSString *)encodePO;

- (NSString *)stringByRemovingQuotes;

@end

@implementation POParser

+ (nullable Gettext *)loadFile:(NSString *)path {
	
	NSError *error = nil;
	NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!content) {
        return nil;
    }

    Gettext *gettext = [[Gettext alloc] init];
	NSArray *split = [content componentsSeparatedByString:@"\n\n"];

	for (NSString *str in split) {
        
        NSArray *strings = [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        POEntry *entry = nil;
        for (NSString *s in strings) {
            
            NSString *str = s;
            
            if(!str.length) {
                continue;
            }
            
            if(!entry) {
                entry = [POEntry new];
            }
            
            // parse header
            if([str characterAtIndex:0] == '"' && [str characterAtIndex:str.length - 1] == '"') {
                
                str = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                NSArray<NSString *> *arr = [str componentsSeparatedByString:@":"];
                
                if(arr.count < 2)
                    continue;
                
                NSString *value = [arr[1].decodePO stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                [gettext setHeader:arr[0] value:value];
                
            } else { // parse actual entry
                NSArray *arr = [str componentsSeparatedByString:@" "];
                NSString *key, *value;
                NSUInteger keylen = 0;
                unichar c;
                
                if(arr.count < 2)
                    continue;
                
                key = arr[0];
                value = arr[1];
                
                keylen = key.length;
                
                if([str characterAtIndex:0] == '#') { // #. section
                    // don't use "key" here because of #_ (space) format
                    // for translator comments
                    c = [str characterAtIndex:1];
                    
                    switch(c)  {
                            // reference
                        case ':':
                            [entry.references addObject:value];
                            break;
                            
                            // flag
                        case ',':
                            [entry.flags addObject:value];
                            break;
                            
                            // translator comments
                        case ' ':
                            entry.translator_comments = value;
                            break;
                            
                            // extracted comments
                        case '.':
                            entry.extracted_comments = value;
                            break;
                            
                            // previous message, not implemented
                        case '|':
                            break;
                            
                        default:
                            continue;
                            break;
                    }
                } else if([key isEqualToString:@"msgctxt"]) { // msgctxt
                    entry.context = value.decodePO.stringByRemovingQuotes;
                } else if([key isEqualToString:@"msgid"]) { // msgid
                    entry.msgid = value.decodePO.stringByRemovingQuotes;
                } else if([key isEqualToString:@"msgstr"]) { // msgid
                    [entry.translations addObject:value.decodePO.stringByRemovingQuotes];
                } else if([key isEqualToString:@"msgid_plural"]) { // msgid
                    entry.msgid_plural = value.decodePO.stringByRemovingQuotes;
                } else if(keylen >= 8 && [[key substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"msgstr["]) {
                    [entry.translations addObject:value.decodePO.stringByRemovingQuotes];
                }
            }
        }
        
        if (entry) {
            [gettext addEntry:entry];
        }
        
	}

	return gettext;
}

@end

@implementation NSString (PO)

- (NSString *)decodePO {
    NSString *string = self.copy;
    
    string = [string stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    string = [string stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
    string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    return string;
}

- (NSString *)encodePO {
    NSString *string = self.copy;
    
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    string = [string stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    return string;
}

- (NSString *)stringByRemovingQuotes {
    NSString *string = self.copy;
    
    NSUInteger x = 0, y = 0;
    
    y = string.length;
    
    if (y) {
        
        if([string characterAtIndex:0] == '"') {
            x++;
        }
        
        if(x < y && [string characterAtIndex:string.length - 1] == '"') {
            y--;
        }
        
        string = [string substringWithRange:NSMakeRange(x, y - x)];
    }
    
    return string;
}

@end





