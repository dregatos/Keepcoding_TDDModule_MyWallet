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

#pragma mark - Basics

- (void)testNumberOfAvailableCurrencies {
    
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"EUR"]];
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"USD"]];
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"GBP"]];
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"CAD"]];
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"CAD"]];

    XCTAssertEqual([self.wallet numberOfAvailableCurrencies],
                   4, @"numberOfAvailableCurrencies shoulb be = 4");
}

- (void)testAvailableCurrencies {
    
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"EUR"]];
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"USD"]];
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"GBP"]];
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"USD"]];
    [self.wallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"CAD"]];
    
    NSArray *currArr = [self.wallet availableCurrencies];
    XCTAssertEqualObjects([self.wallet availableCurrencies], currArr,
                          @"numberOfAvailableCurrencies shoulb be = 2");
}

#pragma mark - Addition

- (void)testSimpleAdditionWithExtraction {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    
    XCTAssertEqualObjects([[self.wallet getMoneysWithCurrency: @"EUR"] objectAtIndex:0],
                          [DRGMoney euroWithAmount: 50],
                          @"Wallet's money with EUR at index 0 should be = €50");
}

- (void)testSimpleAdditionWithTotalExtraction {

    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 50],
                          @"Wallet should have €50");
}

- (void)testMultipleAdditionOfSameCurrencyWithExtraction {

    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 5]];
    
    XCTAssertEqualObjects([[self.wallet getMoneysWithCurrency: @"EUR"] objectAtIndex:0],
                          [DRGMoney euroWithAmount: 50],
                          @"Wallet's money with EUR at index 0 should be = €50");
    XCTAssertEqualObjects([[self.wallet getMoneysWithCurrency: @"EUR"] objectAtIndex:1],
                          [DRGMoney euroWithAmount: 5],
                          @"Wallet's money with EUR at index 1 should be = €5");
}

- (void)testMultipleAdditionOfSameCurrencyWithTotalExtraction {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 5]];
    
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 55],
                          @"Wallet should have €55");
}

- (void)testMultipleAdditionOfDifferentCurrenciesWithExtraction {
    
    [self.wallet addMoney:[DRGMoney dollarWithAmount: 34]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 5]];
    
    XCTAssertEqualObjects([[self.wallet getMoneysWithCurrency: @"USD"] objectAtIndex:0],
                          [DRGMoney dollarWithAmount: 34],
                          @"Wallet's money with EUR at index 0 should be = $34");
    XCTAssertEqualObjects([[self.wallet getMoneysWithCurrency: @"EUR"] objectAtIndex:0],
                          [DRGMoney euroWithAmount: 5],
                          @"Wallet's money with USD at index 0 should be = €5");
}

- (void)testMultipleAdditionOfDifferentCurrenciesWithTotalExtraction {
    
    [self.wallet addMoney:[DRGMoney dollarWithAmount: 34]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 5]];
    
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"USD"],
                          [DRGMoney dollarWithAmount: 34],
                          @"Wallet should have $34");
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 5],
                          @"Wallet should have €5");
}

#pragma mark - Substraction

- (void)testSimpleSubstraction {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    
    [self.wallet substractMoney:[DRGMoney euroWithAmount: 25] withResult:nil];
    
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 25],
                          @"Wallet should have €25");
}

- (void)testComplexSubstraction {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 35.5]];
    
    [self.wallet substractMoney:[DRGMoney euroWithAmount: 65] withResult:nil];
    
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 20.5],
                          @"Wallet should have €20");
}

- (void)testSubstractionDoesntKeepMoneyWithZeroAmountInTheWallet {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 20]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 20]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 10]];
    [self.wallet addMoney:[DRGMoney euroWithAmount: 35.5]];
    
    [self.wallet substractMoney:[DRGMoney euroWithAmount: 65] withResult:nil];
    
    XCTAssertEqual([[self.wallet getMoneysWithCurrency: @"EUR"] count],
                   1, @"Wallet's money with EUR count should be = 1");
    XCTAssertEqualObjects([[self.wallet getMoneysWithCurrency: @"EUR"] objectAtIndex:0],
                          [DRGMoney euroWithAmount: 20.5],
                          @"Wallet's money with EUR at index 0 should be = €20.5");
}

- (void)testThatSubstractionALargerAmountOfMoneyThanItIsAvailableDoesntCrash {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    
    XCTAssertNoThrow([self.wallet substractMoney:[DRGMoney euroWithAmount: 65] withResult:nil]);
}

- (void)testSubstractionResult {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    
    DRGMoney *available = [self.wallet getTotalMoneyWithCurrency:@"EUR"];
    NSString *desc = @"Operation was unsuccessful.";
    NSString *reason = [NSString stringWithFormat:@"Your wallet only got %@%@", available.currency, available.amount];
    NSString *sugg = [NSString stringWithFormat:@"Try with an amount < %@", available.description];

    [self.wallet substractMoney:[DRGMoney euroWithAmount: 65]
                     withResult:^(BOOL success, NSError *error) {
                         XCTAssertFalse(success, @"50€ - 65€ shouldn't success");
                         XCTAssertEqualObjects(error.localizedDescription, desc);
                         XCTAssertEqualObjects(error.localizedFailureReason, reason);
                         XCTAssertEqualObjects(error.localizedRecoverySuggestion, sugg);
    }];
}

#pragma mark - Deletion

- (void)testCleanWallet {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    [self.wallet addMoney:[DRGMoney dollarWithAmount: 35]];
    
    // Clean
    [self.wallet emptyWallet];
    
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"USD"],
                          [DRGMoney dollarWithAmount: 0],
                          @"Wallet should have $0");
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 0],
                          @"Wallet should have €0");
}

- (void)testCleanWalletForCurrency {
    
    [self.wallet addMoney:[DRGMoney euroWithAmount: 50]];
    [self.wallet addMoney:[DRGMoney dollarWithAmount: 35]];
    
    // Clean
    [self.wallet substractAllMoneysWithCurrency: @"USD"];
    
    XCTAssertEqual([[self.wallet getMoneysWithCurrency:@"USD"] count],
                   0, @"Wallet should have any USD");
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"USD"],
                          [DRGMoney dollarWithAmount: 0],
                          @"Wallet should have $0");
    XCTAssertEqual([[self.wallet getMoneysWithCurrency:@"EUR"] count],
                   1, @"Wallet should have one EUR Money");
    XCTAssertEqualObjects([self.wallet getTotalMoneyWithCurrency: @"EUR"],
                          [DRGMoney euroWithAmount: 50],
                          @"Wallet should have €50");
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
