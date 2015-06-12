//
//  DRGMoneyVCTest.m
//  MyWallet
//
//  Created by David Regatos on 07/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DRGMoneyVC.h"
#import "DRGMoney.h"

#import <OCMock/OCMock.h>
#import "DRGFakeNotificationCenter.h"
#import "NotificationKeys.h"

@interface DRGMoneyVCTest : XCTestCase

@end

@implementation DRGMoneyVCTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - IBActions

- (void)testSaveBtnCreateRightMoney {
    
    DRGMoneyVC *moneyVC = [[DRGMoneyVC alloc] initWithMoney:nil];
    moneyVC.adding = YES;
    
    UITextField *inputTxtField = [[UITextField alloc] init];
    inputTxtField.text = @"13.13";
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"EUR", @"USD", @"GBP"]];
    segCtrl.selectedSegmentIndex = 2;
    
    moneyVC.inputTxtField = inputTxtField;
    moneyVC.currencyControl = segCtrl;
    
    XCTAssertEqualObjects(moneyVC.money, [DRGMoney poundWithAmount:13.13], @"Money added should be equal to GBP13.13");
}

#pragma mark - Notifications (using OCMock)

- (void)testNotifyUserWantsAddMoney {
    
    DRGMoneyVC *moneyVC = [[DRGMoneyVC alloc] initWithMoney:nil];
    moneyVC.adding = YES;
    
    NSString *notificationName = @"DID_ADD_MONEY_NOTIFICATION";
    id observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:notificationName object:moneyVC];
    [[observerMock expect] notificationWithName:notificationName object:moneyVC userInfo:[OCMArg any]];
     
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wundeclared-selector"
 
    [moneyVC performSelector:@selector(notifyMoney:toObservers:)
                  withObject:[DRGMoney poundWithAmount:1]
                  withObject:[NSNotificationCenter defaultCenter]];
    
 #pragma clang diagnostic pop
     
     [observerMock verify];
     [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testUserInfoNotificationWhenUserWantsAddMoney {
    
    DRGMoney *notifiedMoney = [DRGMoney euroWithAmount:3.75];
    DRGMoneyVC *moneyVC = [[DRGMoneyVC alloc] initWithMoney:nil];
    moneyVC.adding = YES;
    
    UITextField *inputTxtField = [[UITextField alloc] init];
    inputTxtField.text = @"3.75";
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"EUR", @"USD", @"GBP"]];
    segCtrl.selectedSegmentIndex = 0;
    
    moneyVC.inputTxtField = inputTxtField;
    moneyVC.currencyControl = segCtrl;
    
    NSString *notificationName = @"DID_ADD_MONEY_NOTIFICATION";
    id observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:notificationName object:moneyVC];
    [[observerMock expect] notificationWithName:notificationName object:moneyVC
                                       userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
        id value = [userInfo objectForKey:MONEY_KEY];
        XCTAssertEqualObjects(notifiedMoney, value, @"Notified money should be equal to EUR3.75");
        return YES;
    }]];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [moneyVC performSelector:@selector(notifyMoney:toObservers:)
                  withObject:notifiedMoney
                  withObject:[NSNotificationCenter defaultCenter]];
    
#pragma clang diagnostic pop
    
    [observerMock verify];
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

@end
