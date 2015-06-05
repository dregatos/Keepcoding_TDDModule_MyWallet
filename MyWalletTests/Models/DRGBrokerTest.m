//
//  DRGBrokerTest.m
//  MyWallet
//
//  Created by David Regatos on 04/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DRGMoney.h"
#import "DRGBroker.h"

@interface DRGBrokerTest : XCTestCase

@property (nonatomic, strong) DRGBroker *emptyBroker;
@property (nonatomic, strong) DRGMoney *oneDollar;

@end

@implementation DRGBrokerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.emptyBroker = [[DRGBroker alloc] init];
    self.oneDollar = [DRGMoney dollarWithAmount:1];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.emptyBroker = nil;
    self.oneDollar = nil;
}

#pragma mark - Reduction

- (void)testReductionToSameCurrency {
    
    DRGMoney *twoDollars = [DRGMoney dollarWithAmount:2];
    
    DRGMoney *reduced = [self.emptyBroker reduce:twoDollars toCurrency: @"USD"];
    
    XCTAssertEqualObjects(twoDollars, reduced, @"$2 should be = $2 after reducing it");
}


// $10 == 5€ if 2:1
- (void)testReduction {
    
    [self.emptyBroker addRate:2 fromCurrency: @"EUR" toCurrency: @"USD"];
    
    DRGMoney *tenDollars = [DRGMoney dollarWithAmount:10];
    DRGMoney *fiveEuros = [DRGMoney euroWithAmount:5];
    
    DRGMoney *converted = [self.emptyBroker reduce:tenDollars toCurrency: @"EUR"];
    
    XCTAssertEqualObjects(fiveEuros, converted, @"$10 should be = 5€ if EURUSD = 2");

}

#pragma mark - Exceptions

- (void)testThatNoRateRaisesException {
    XCTAssertThrows([self.emptyBroker reduce:self.oneDollar toCurrency:@"EUR"]);
}

@end
