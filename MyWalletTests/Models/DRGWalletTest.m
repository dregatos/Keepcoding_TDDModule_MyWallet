//
//  DRGWalletTest.m
//  MyWallet
//
//  Created by David Regatos on 04/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DRGBroker.h"
#import "DRGMoney.h"
#import "DRGWallet.h"

@interface DRGWalletTest : XCTestCase

@end

@implementation DRGWalletTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// €40 + $20 = $64.8 if EURUSD = 1.12
- (void)testAdditionWithReduction {
    
    DRGBroker *broker = [[DRGBroker alloc] init];
    [broker addRate:1.12 fromCurrency:@"EUR" toCurrency:@"USD"];
    
    DRGWallet *wallet = [[DRGWallet alloc] initWithAmount:40 andCurrency:@"EUR"];
    [wallet plus:[DRGMoney dollarWithAmount: 20]];
    
    DRGMoney *reduced = [broker reduce:wallet toCurrency:@"USD"];
    
    XCTAssertEqualObjects(reduced, [DRGMoney dollarWithAmount:64.8], @"€40 + $20 = $64.8 if EURUSD = 1.12");
}

@end
