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

- (void)testAmountAllocation {
    
    // EURO
    DRGMoney *twoEuros = [DRGMoney euroWithAmount:2];
    // DOLLAR
    DRGMoney *twoDollars = [DRGMoney dollarWithAmount:2];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    XCTAssertEqual(2, [((NSNumber *)[twoEuros performSelector:@selector(amount)]) integerValue],
                   @"The value retrieved must be the same as the assigned");
    XCTAssertEqual(2, [((NSNumber *)[twoDollars performSelector:@selector(amount)]) integerValue],
                   @"The value retrieved must be the same as the assigned");
#pragma clang diagnostic pop
    
}

- (void)testCurrency {
    // EURO
    XCTAssertEqualObjects(@"EUR", [[DRGMoney euroWithAmount:1] currency], @"The currency of euros should be EUR");
    // DOLLAR
    XCTAssertEqualObjects(@"USD", [[DRGMoney dollarWithAmount:1] currency], @"The currency of dollar should be USD");
}

- (void)testDifferentCurrencies {
    
    DRGMoney *euro = [DRGMoney euroWithAmount: 0];
    DRGMoney *dollar = [DRGMoney dollarWithAmount: 0];
    
    XCTAssertNotEqualObjects(euro, dollar, @"Different currencies must not be equal!!");
}

- (void)testEuroEquality {
    
    DRGMoney *zeroEuros = [DRGMoney euroWithAmount: 0];
    DRGMoney *tenEuros = [DRGMoney euroWithAmount: 10];
    
    DRGMoney *fiveEuros = [DRGMoney euroWithAmount: 5];
    DRGMoney *fiveTimesTwoEuros = [fiveEuros times:2];
    
    XCTAssertEqualObjects(tenEuros, fiveTimesTwoEuros, @"10€ should be equal to 5€ * 2");
    XCTAssertNotEqualObjects(tenEuros, fiveEuros, @"10€ should be different to 5€");
    XCTAssertNotEqualObjects(zeroEuros, nil, @"0€ should be different to nil");
}

- (void)testDollarEquality {
    
    DRGMoney *zeroDollars = [DRGMoney dollarWithAmount: 0];
    DRGMoney *tenDollars = [DRGMoney dollarWithAmount: 10];
    
    DRGMoney *fiveDollars = [DRGMoney dollarWithAmount: 5];
    DRGMoney *fiveTimesTwoDollars = [fiveDollars times:2];
    
    XCTAssertEqualObjects(tenDollars, fiveTimesTwoDollars, @"10€ should be equal to 5€ * 2");
    XCTAssertNotEqualObjects(tenDollars, fiveDollars, @"10€ should be different to 5€");
    XCTAssertNotEqualObjects(zeroDollars, nil, @"0€ should be different to nil");
}

- (void)testHash {
    
    // NOTE: If objects are equal, then their hash values must also be equal
    //       However, the converse does not hold: two objects need not be equal
    //       in order for their hash values to be equal.
    // SOURCE: http://nshipster.com/equality/
    
    DRGMoney *fiveEuros = [DRGMoney euroWithAmount: 5];
    DRGMoney *anotherFiveEuros = [DRGMoney euroWithAmount: 5];
    
    XCTAssertEqual([fiveEuros hash], [anotherFiveEuros hash], @"Two different 5€ must have same hash");
}

- (void)testEuroMultiplication { // depends on testEquality
    
    DRGMoney *fiveEuros = [DRGMoney euroWithAmount: 5];
    DRGMoney *tenEuros = [DRGMoney euroWithAmount: 10];
    
    DRGMoney *fiveTimesTwoEuros = [fiveEuros times:2];
    
    XCTAssertEqualObjects(fiveTimesTwoEuros, tenEuros, @"5€*2 should be 10€");
}

- (void)testDollarMultiplication { // depends on testEquality

    DRGMoney *fiveDollars = [DRGMoney dollarWithAmount: 5];
    DRGMoney *tenDollars = [DRGMoney dollarWithAmount: 10];
    
    DRGMoney *fiveTimesTwoDollars = [fiveDollars times:2];
    
    XCTAssertEqualObjects(fiveTimesTwoDollars, tenDollars, @"$5*2 should be $10");
}

- (void)testSameCurrencyAddition {
    XCTAssertEqualObjects([[DRGMoney euroWithAmount:8] plus:[DRGMoney euroWithAmount:2]],
                          [DRGMoney euroWithAmount:10], @"8€ +2€ = 10€");
    XCTAssertEqualObjects([[DRGMoney dollarWithAmount:5] plus:[DRGMoney dollarWithAmount:6]],
                             [DRGMoney dollarWithAmount:11], @"$5 +$5 = $11");
}

@end
