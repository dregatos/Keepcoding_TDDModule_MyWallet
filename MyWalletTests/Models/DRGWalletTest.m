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

@property (nonatomic, strong) DRGWallet *wallet;
@property (nonatomic, strong) DRGBroker *broker;

@end

@implementation DRGWalletTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.wallet = [[DRGWallet alloc] init];
    self.broker = [[DRGBroker alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.wallet = nil;
    self.broker = nil;
}

#pragma mark - Addition + Extraction

- (void)testSimpleAdditionWithExtraction {

    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    
    XCTAssertEqualObjects([self.wallet takeAllMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 50],
                          @"Wallet should have €50");
}

- (void)testMultipleAdditionOfSameCurrencyWithExtraction {

    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 5]];
    
    XCTAssertEqualObjects([self.wallet takeAllMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 55],
                          @"Wallet should have €55");
}

- (void)testMultipleAdditionOfDifferentCurrenciesWithExtraction {
    
    [self.wallet addMoney:[DRGMoney dollarWithAmount: 34]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 5]];
    
    XCTAssertEqualObjects([self.wallet takeAllMoneyWithCurrency: @"USD"],
                          [DRGMoney dollarWithAmount: 34],
                          @"Wallet should have $34");
    XCTAssertEqualObjects([self.wallet takeAllMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 5],
                          @"Wallet should have €5");
}

#pragma mark - Reduction

// €40 + $20 = $64.8 if EURUSD = 1.12
- (void)testReduction {
    
    [self.broker addRate:1.12 fromCurrency:@"EUR" toCurrency:@"USD"];
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 40]];
    [self.wallet addMoney:[DRGMoney dollarWithAmount: 20]];
    
    DRGMoney *reduced = [self.broker reduce:self.wallet toCurrency:@"USD"];
    
    XCTAssertEqualObjects(reduced, [DRGMoney dollarWithAmount:64.8], @"€40 + $20 = $64.8 if EURUSD = 1.12");
}

@end
