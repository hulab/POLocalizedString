//
//  POLocalizedStringTests.m
//  POLocalizedStringTests
//
//  Created by Maxime Epain on 04/12/2017.
//  Copyright © 2017 Hulab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <POLocalizedString/POLocalizedString.h>

@interface POLocalizedStringTests : XCTestCase
@property (nonatomic, weak) NSBundle *bundle;
@end

@implementation POLocalizedStringTests

- (void)setUp {
    [super setUp];
    
    self.bundle = [NSBundle bundleForClass:self.class];
    self.bundle.language = @"af";
    
    NSBundle.localizedBundle = self.bundle;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMsgid {
    NSString *str = POLocalizedString(@"The URL is not valid and cannot be loaded.");
    XCTAssertEqualObjects(str, @"Die URL is ongeldig en kan nie gelaai word nie.");
}

- (void)testAsciiFormat {
    NSString *format = POLocalizedString(@"Firefox can't find the server at %s.");
    NSString *str = [NSString stringWithFormat:format, @"location".ascii];
    XCTAssertEqualObjects(str, @"Firefox kan nie die bediener vind by location nie.");
}

- (void)testUnicodeFormat {
    NSString *format = POLocalizedString(@"Firefox can't find the file at %S.");
    NSString *str = [NSString stringWithFormat:format, @"location".unicode];
    XCTAssertEqualObjects(str, @"Firefox kan nie 'n lêer vind by location nie.");
}

- (void)testPlurals {
    NSString *format = POLocalizedString(@"Firefox can't find the file at %S.");
    NSString *str = [NSString stringWithFormat:format, @"location".unicode];
    XCTAssertEqualObjects(str, @"Firefox kan nie 'n lêer vind by location nie.");
}

- (void)testLoadPerformance {
    [self measureBlock:^{
        self.bundle.language = @"af";
        POLocalizedString(@"The URL is not valid and cannot be loaded.");
    }];
}

@end
