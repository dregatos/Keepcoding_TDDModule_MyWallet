//
//  DRGMoneyTest.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DRGMoney.h"

@interface DRGMoneyTest : XCTestCase

@end

@implementation DRGMoneyTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatTimesRaisesException {
    DRGMoney *money = [[DRGMoney alloc] initWithAmount:1];
    XCTAssertThrows([money times:2], @"Should raise an exception");
}

@end
