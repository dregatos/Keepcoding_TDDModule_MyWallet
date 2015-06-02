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

- (void)testMultiplication {
    
    DRGEuro *euro = [[DRGEuro alloc] initWithAmount:5];
    DRGEuro *total = [euro times:2];
    
    XCTAssertEqual(total.amount, 10, @"5*2 should be 10");
}

@end
