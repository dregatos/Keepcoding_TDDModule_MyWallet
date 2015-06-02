//
//  DRGEuroTest.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DRGEuro.h"

@interface DRGEuroTest : XCTestCase

@end

@implementation DRGEuroTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMultiplication { // depends on testEquality
    
    DRGEuro *five = [[DRGEuro alloc] initWithAmount:5];
    DRGEuro *ten = [[DRGEuro alloc] initWithAmount:10];

    DRGEuro *fiveTimesTwo = [five times:2];
    
    XCTAssertEqualObjects(fiveTimesTwo, ten, @"5€*2 should be 10€");
}

- (void)testEquality {
    
    DRGEuro *zero = [[DRGEuro alloc] initWithAmount:0];
    DRGEuro *ten = [[DRGEuro alloc] initWithAmount:10];
    
    DRGEuro *five = [[DRGEuro alloc] initWithAmount:5];
    DRGEuro *fiveTimesTwo = [five times:2];
    
    XCTAssertEqualObjects(ten, fiveTimesTwo, @"10€ should be equal to 5€ * 2");
    XCTAssertNotEqualObjects(ten, five, @"10€ should be different to 5€");
    XCTAssertNotEqualObjects(zero, nil, @"0€ should be different to nil");
}

@end
