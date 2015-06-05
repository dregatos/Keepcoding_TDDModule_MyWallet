//
//  DRGWalletTableVCTest.m
//  MyWallet
//
//  Created by David Regatos on 05/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DRGWallet.h"
#import "DRGMoney.h"
#import "DRGBroker.h"
#import "DRGWalletTableVC.h"

@interface DRGWalletTableVCTest : XCTestCase

@property (nonatomic, strong) DRGWallet *myWallet;
@property (nonatomic, strong) DRGBroker *myBroker;

@end

@implementation DRGWalletTableVCTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.myWallet = [[DRGWallet alloc] init];
    self.myBroker = [[DRGBroker alloc] init];
    [self.myBroker addRate:1.12 fromCurrency:@"EUR" toCurrency:@"USD"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.myWallet = nil;
    self.myBroker = nil;
}

#pragma mark - Data Source

// SECTIONS
- (void)testThatNumberOfSectionsIfEmptyWalletIsEqualToOne {
    
    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:self.myBroker andWallet:self.myWallet];
    
    NSInteger sections = [tableVC numberOfSectionsInTableView:nil];
    XCTAssertEqual(sections, 1, @"Number of sections should be = 1 if wallet is empty");
}

- (void)testThatNumberOfSectionIsEqualToNumberOfCurrenciesPlusOne {
    
    [self.myWallet addMoney:[DRGMoney euroWithAmount:10.5]];
    [self.myWallet addMoney:[DRGMoney dollarWithAmount:0.5]];

    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:self.myBroker andWallet:self.myWallet];
    
    NSInteger sections = [tableVC numberOfSectionsInTableView:nil];
    XCTAssertEqual(sections, [self.myWallet numberOfAvailableCurrencies] + 1,
                   @"Number of sections should be = 'numberOfAvailableCurrencies + 1'");
}

// ROWS
- (void)testThatNumberOfRowsInCurrencySectionIsEqualToNumberOfMoneysOfThisCurrencyPlusOne {
    
    [self.myWallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"EUR"]];
    [self.myWallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"USD"]];
    [self.myWallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"GBP"]];
    [self.myWallet addMoney:[[DRGMoney alloc] initWithAmount:2 andCurrency:@"GBP"]];
    [self.myWallet addMoney:[[DRGMoney alloc] initWithAmount:1 andCurrency:@"CAD"]];
    
    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:self.myBroker andWallet:self.myWallet];
    
    NSArray *currencies = [self.myWallet availableCurrencies];

    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:0],
                   [[self.myWallet getMoneyListWithCurrency: currencies[0]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:1],
                   [[self.myWallet getMoneyListWithCurrency: currencies[1]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:2],
                   [[self.myWallet getMoneyListWithCurrency: currencies[2]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:3],
                   [[self.myWallet getMoneyListWithCurrency: currencies[3]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
}

- (void)testThatNumberOfRowsInExtraSectionIsEqualToOne {
    
    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:self.myBroker andWallet:self.myWallet];

    NSArray *currencies = [self.myWallet availableCurrencies];

    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:0],
                   [[self.myWallet getMoneyListWithCurrency: [currencies lastObject]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
}

@end
