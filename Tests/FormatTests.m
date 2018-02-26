// CFormatTests.m
//
// Created by Maxime Epain on 26/02/2018.
// Copyright © 2017 Hulab. All rights reserved.
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

#import <XCTest/XCTest.h>
#import <POLocalizedString/POLocalizedString.h>

@interface CFormatTests : XCTestCase
@property (nonatomic, weak) NSBundle *bundle;
@end

@implementation CFormatTests

- (void)setUp {
    [super setUp];
    
    self.bundle = [NSBundle bundleForClass:self.class];
    self.bundle.language = @"format";
    
    NSBundle.localizedBundle = self.bundle;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCFormat {
    self.bundle.format = [[CFormat alloc] init];
    NSString *format = POLocalizedStringFromContext(@"Format Test", @"c-format");
    NSString *str = [NSString stringWithFormat:format, @" !\"#$%&", @"ÀÁÂÃÄÅÆ"];
    XCTAssertEqualObjects(str, @"ascii[ !\"#$%&];unicode[ÀÁÂÃÄÅÆ]");
}

- (void)testObjCFormat {
    self.bundle.format = [[ObjCFormat alloc] init];
    NSString *format = POLocalizedStringFromContext(@"Format Test", @"objc-format");
    NSString *str = [NSString stringWithFormat:format, @"⌘"];
    XCTAssertEqualObjects(str, @"NSString[⌘]");
}



@end
