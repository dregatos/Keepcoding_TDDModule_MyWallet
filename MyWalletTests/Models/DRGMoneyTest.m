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

@property (nonatomic, strong) DRGMoney *oneEuro;
@property (nonatomic, strong) DRGMoney *oneDollar;
@end

@implementation DRGMoneyTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.oneEuro = [DRGMoney euroWithAmount:1];
    self.oneDollar = [DRGMoney dollarWithAmount:1];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.oneEuro = nil;
    self.oneDollar = nil;
}

#pragma mark - Basics

- (void)testDescription {
    XCTAssertEqualObjects([self.oneEuro description],
                          @"<DRGMoney: EUR1>",
                          @"Description format should be <DRGMoney: 'Currency_symbol'+'amount'>");
    XCTAssertEqualObjects([self.oneDollar description],
                          @"<DRGMoney: USD1>",
                          @"Description format should be <DRGMoney: 'Currency_symbol'+'amount'>");
}

- (void)testAmountAllocation {
    XCTAssertEqual(1, [self.oneEuro.amount doubleValue],
                   @"The value retrieved must be the same as the assigned");
    XCTAssertEqual(1, [self.oneDollar.amount doubleValue],
                   @"The value retrieved must be the same as the assigned");
}

- (void)testCurrency {
    // EURO
    XCTAssertEqualObjects(@"EUR", [self.oneEuro currency],
                          @"The currency of euros should be EUR");
    // DOLLAR
    XCTAssertEqualObjects(@"USD", [self.oneDollar currency],
                          @"The currency of dollar should be USD");
}

- (void)testDifferentCurrencies {
    XCTAssertNotEqualObjects(self.oneEuro,self.oneDollar,
                             @"Different currencies must not be equal!!");
}

#pragma mark - Equality

- (void)testEuroEquality {
    XCTAssertEqualObjects([DRGMoney euroWithAmount: 10],
                          [DRGMoney euroWithAmount: 5 * 2],
                          @"10€ should be equal to 5€ * 2");
    XCTAssertNotEqualObjects([DRGMoney euroWithAmount: 10],
                             [DRGMoney euroWithAmount: 5],
                             @"10€ should be different to 5€");
    XCTAssertNotEqualObjects([DRGMoney euroWithAmount: 0], nil, @"0€ should be different to nil");
}

- (void)testDollarEquality {
    XCTAssertEqualObjects([DRGMoney dollarWithAmount: 10],
                          [DRGMoney dollarWithAmount: 5 * 2],
                          @"10€ should be equal to 5€ * 2");
    XCTAssertNotEqualObjects([DRGMoney dollarWithAmount: 10],
                             [DRGMoney dollarWithAmount: 5],
                             @"$10 should be different to $5");
    XCTAssertNotEqualObjects([DRGMoney dollarWithAmount: 0], nil, @"0€ should be different to nil");
}

- (void)testHash {
    XCTAssertEqual([self.oneEuro hash], 1, @"The hash must be = to amount");
    XCTAssertEqual([self.oneDollar hash], 1, @"The hash must be = to amount");
}

- (void)testHashEquality {
    
    // NOTE: If objects are equal, then their hash values must also be equal
    //       However, the converse does not hold: two objects need not be equal
    //       in order for their hash values to be equal.
    // SOURCE: http://nshipster.com/equality/
    
    XCTAssertEqual([[DRGMoney euroWithAmount: 5] hash],
                   [[DRGMoney euroWithAmount: 5] hash],
                   @"Two different 5€ must have same hash");
}

- (void)testIntegerDoubleEquality {
    XCTAssertEqualObjects([DRGMoney euroWithAmount:1],
                          [DRGMoney euroWithAmount:1.0],
                          @"€1 should be equal to €1.0");
    XCTAssertEqualObjects([DRGMoney dollarWithAmount:1],
                          [DRGMoney dollarWithAmount:1.0],
                          @"$1 should be equal to $1.0");
}

#pragma mark - Operations

- (void)testIntMultiplication { // depends on testEquality
    XCTAssertEqualObjects([[DRGMoney dollarWithAmount: 2] times:5],
                          [DRGMoney dollarWithAmount: 10],
                          @"2€*5 should be $10");
    XCTAssertEqualObjects([[DRGMoney dollarWithAmount: 5] times:2],
                          [DRGMoney dollarWithAmount: 10],
                          @"$5*2 should be $10");
}

- (void)testSameCurrencyAddition {
    XCTAssertEqualObjects([[DRGMoney euroWithAmount:8] plus:[DRGMoney euroWithAmount:2]],
                          [DRGMoney euroWithAmount:10], @"8€ + 2€ = 10€");
    XCTAssertEqualObjects([[DRGMoney dollarWithAmount:5] plus:[DRGMoney dollarWithAmount:6]],
                             [DRGMoney dollarWithAmount:11], @"$5 + $6 = $11");
}

- (void)testAdditionOfNotIntegers {
    XCTAssertEqualObjects([DRGMoney euroWithAmount:5.3],
                          [[DRGMoney euroWithAmount:1.1] plus:[DRGMoney euroWithAmount:4.2]],
                          @"€5.3 should be equal to €1.1+€4.2");
    XCTAssertEqualObjects([DRGMoney dollarWithAmount:13.15],
                          [[DRGMoney dollarWithAmount:6.65] plus:[DRGMoney dollarWithAmount:6.5]],
                          @"$13.1 should be equal to $6.6+$6.5");
}

- (void)testMultiplicationOfNotIntegers {
    
    XCTAssertEqualObjects([DRGMoney euroWithAmount: 8.325],
                          [[DRGMoney euroWithAmount: 3.33] times:2.5],
                          @"3.33€*2.5 should be 8.325€");
    XCTAssertEqualObjects([DRGMoney dollarWithAmount: 2.02],
                          [[DRGMoney dollarWithAmount: 1.01] times:2.0],
                          @"$1.01*2.0 should be $2.02");
}

- (void)testRounded {
    XCTAssertEqualObjects([DRGMoney euroWithAmount: 18.125],
                          [DRGMoney euroWithAmount: 18.13],
                          @"18.125€ should be rounded to 18.13€");
    XCTAssertEqualObjects([DRGMoney euroWithAmount: 18.1249],
                          [DRGMoney euroWithAmount: 18.12],
                          @"18.1249€ should be rounded to 18.12€");
    XCTAssertEqualObjects([DRGMoney euroWithAmount: 18],
                          [DRGMoney euroWithAmount: 18.00],
                          @"18€ should be equal to 18.00€");
}


@end
