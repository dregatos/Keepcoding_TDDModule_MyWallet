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

#import "DRGFakeNotificationCenter.h"
#import "NotificationKeys.h"

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
- (void)testThatNumberOfSectionsIfWalletIsEmptyIsEqualToOne {
    
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
                   [[self.myWallet getMoneysWithCurrency: currencies[0]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:1],
                   [[self.myWallet getMoneysWithCurrency: currencies[1]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:2],
                   [[self.myWallet getMoneysWithCurrency: currencies[2]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:3],
                   [[self.myWallet getMoneysWithCurrency: currencies[3]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
}

- (void)testThatNumberOfRowsInExtraSectionIsEqualToOne {
    
    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:self.myBroker andWallet:self.myWallet];

    NSArray *currencies = [self.myWallet availableCurrencies];

    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:0],
                   [[self.myWallet getMoneysWithCurrency: [currencies lastObject]] count] + 1,
                   @"Number of rows should be = 'numberOfMoneys + 1'");
}

#pragma mark - Notifications

-(void)testDidSuscribeToNotifications {
    
    DRGFakeNotificationCenter *fakeNC = [[DRGFakeNotificationCenter alloc] init];
    
    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:self.myBroker andWallet:self.myWallet];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [tableVC performSelector:@selector(registerForNotifications:) withObject:fakeNC];
    
#pragma clang diagnostic pop
    
    NSDictionary *obs = [fakeNC observers];
    id observer1 = [obs objectForKey:DID_ADD_MONEY_NOTIFICATION];
    id observer2 = [obs objectForKey:DID_REMOVE_MONEY_NOTIFICATION];

    XCTAssertEqualObjects(observer1, tableVC, @"tableVC must be suscribed to DID_ADD_MONEY_NOTIFICATION");
    XCTAssertEqualObjects(observer2, tableVC, @"tableVC must be suscribed to DID_REMOVE_MONEY_NOTIFICATION");
    
    [[NSNotificationCenter defaultCenter] removeObserver:tableVC];
}

- (void)testMoneyWasAddedNotificationUpdateWalletAndTable {
    
    [self.myWallet addMoney:[DRGMoney euroWithAmount:10.5]];

    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:self.myBroker andWallet:self.myWallet];
    NSInteger previousCount = [[self.myWallet getMoneysWithCurrency:@"EUR"] count];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [tableVC performSelector:@selector(registerForNotifications:) withObject:[NSNotificationCenter defaultCenter]];
    
#pragma clang diagnostic pop
    
    DRGMoney *money = [DRGMoney euroWithAmount:2.22];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_ADD_MONEY_NOTIFICATION
                          object:nil
                        userInfo:@{MONEY_KEY:money}];
    NSInteger newCount = [[self.myWallet getMoneysWithCurrency:@"EUR"] count];

    XCTAssertEqual(previousCount+1, newCount, @"New count of EUR moneys should be equal to previous count + 1");
    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:0], newCount+1,
                   @"numberOfRowsInSection should be equal to new count of moneys with EUR + 1");
    
    [[NSNotificationCenter defaultCenter] removeObserver:tableVC];
}

- (void)testMoneyWasRemovedNotificationUpdateWalletAndTable {
    
    [self.myWallet addMoney:[DRGMoney euroWithAmount:10]];
    [self.myWallet addMoney:[DRGMoney euroWithAmount:5]];

    DRGWalletTableVC *tableVC = [[DRGWalletTableVC alloc] initWithBroker:self.myBroker andWallet:self.myWallet];
    NSInteger previousCount = [[self.myWallet getMoneysWithCurrency:@"EUR"] count];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [tableVC performSelector:@selector(registerForNotifications:) withObject:[NSNotificationCenter defaultCenter]];
    
#pragma clang diagnostic pop
    
    DRGMoney *money = [DRGMoney euroWithAmount:10];
    [[NSNotificationCenter defaultCenter] postNotificationName:DID_REMOVE_MONEY_NOTIFICATION
                          object:nil
                        userInfo:@{MONEY_KEY:money}];
    NSInteger newCount = [[self.myWallet getMoneysWithCurrency:@"EUR"] count];
    
    XCTAssertEqual(previousCount-1, newCount, @"New count of EUR moneys should be equal to previous count + 1");
    XCTAssertEqual([tableVC tableView:nil numberOfRowsInSection:0], newCount+1,
                   @"numberOfRowsInSection should be equal to new count of moneys with EUR + 1");
    
    [[NSNotificationCenter defaultCenter] removeObserver:tableVC];
}


@end
