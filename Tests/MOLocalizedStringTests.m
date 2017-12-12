//
//  POLocalizedStringTests.m
//  POLocalizedStringTests
//
//  Created by Maxime Epain on 04/12/2017.
//  Copyright © 2017 Hulab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <POLocalizedString/POLocalizedString.h>

@interface MOLocalizedStringTests : XCTestCase
@property (nonatomic, weak) NSBundle *bundle;
@end

@implementation MOLocalizedStringTests

- (void)setUp {
    [super setUp];
    
    self.bundle = [NSBundle bundleForClass:self.class];
    self.bundle.language = @"mo";
    
    NSBundle.localizedBundle = self.bundle;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMsgid {
    NSString *str = POLocalizedString(@"Test 1");
    XCTAssertEqualObjects(str, @"Simple string");
}

- (void)testContext {
    NSString *str = POLocalizedStringFromContext(@"Test 2", @"context");
    XCTAssertEqualObjects(str, @"Simple string with context");
}

- (void)testAsciiFormat {
    NSString *format = POLocalizedString(@"Test 3 %s");
    NSString *str = [NSString stringWithFormat:format, @"ascii".ascii];
    XCTAssertEqualObjects(str, @"Ascii format ascii");
}

- (void)testUnicodeFormat {
    NSString *format = POLocalizedString(@"Test 4 %S");
    NSString *str = [NSString stringWithFormat:format, @"unicode".unicode];
    XCTAssertEqualObjects(str, @"Unicode format unicode");
}

- (void)testPlurals {
    NSString *format = POLocalizedPluralFormat(@"Test 5 %i", @"Test 5 %i", 1);
    NSString *str = [NSString stringWithFormat:format, 1];
    XCTAssertEqualObjects(str, @"1 Singular");
    
    format = POLocalizedPluralFormat(@"Test 5 %i", @"Test 5 %i", 2);
    str = [NSString stringWithFormat:format, 2];
    XCTAssertEqualObjects(str, @"2 Plural");
}

- (void)testMultiline {
    NSString *str = POLocalizedString(@"Test\n6");
    XCTAssertEqualObjects(str, @"Multi\nline");
}

- (void)testLoadPerformance {
    [self measureBlock:^{
        self.bundle.language = @"mo";
        POLocalizedString(@"The URL is not valid and cannot be loaded.");
    }];
}

@end
