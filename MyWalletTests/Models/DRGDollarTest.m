//
//  DRGDollarTest.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DRGDollar.h"

@interface DRGDollarTest : XCTestCase

@end

@implementation DRGDollarTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMultiplication { // depends on testEquality
    
    DRGDollar *five = [[DRGDollar alloc] initWithAmount:5];
    DRGDollar *ten = [[DRGDollar alloc] initWithAmount:10];
    
    DRGDollar *fiveTimesTwo = [five times:2];
    
    XCTAssertEqualObjects(fiveTimesTwo, ten, @"$5*2 should be $10");
}

- (void)testEquality {
    
    DRGDollar *zero = [[DRGDollar alloc] initWithAmount:0];
    DRGDollar *ten = [[DRGDollar alloc] initWithAmount:10];
    
    DRGDollar *five = [[DRGDollar alloc] initWithAmount:5];
    DRGDollar *fiveTimesTwo = [five times:2];
    
    XCTAssertEqualObjects(ten, fiveTimesTwo, @"$10 should be equal to $5 * 2");
    XCTAssertNotEqualObjects(ten, five, @"$10 should be different to $5");
    XCTAssertNotEqualObjects(zero, nil, @"$0 should be different to nil");
}

- (void)testHash {
    
    DRGDollar *five1 = [[DRGDollar alloc] initWithAmount:5];
    DRGDollar *five2 = [[DRGDollar alloc] initWithAmount:5];
    
    DRGDollar *ten = [[DRGDollar alloc] initWithAmount:10];
    
    XCTAssertEqual([five1 hash], [five2 hash], @"Equal objects must have same hash");
    XCTAssertNotEqual([five1 hash], [ten hash], @"Different objects must have different hash");
}

@end
