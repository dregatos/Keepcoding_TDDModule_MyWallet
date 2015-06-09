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

- (void)testSaveBtnCreateMoney {
    
    DRGMoneyVC *moneyVC = [[DRGMoneyVC alloc] initWithMoney:nil];
    moneyVC.adding = YES;
    
    UITextField *inputTxtField = [[UITextField alloc] init];
    inputTxtField.text = @"50";
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"EUR", @"USD", @"GBP"]];
    segCtrl.selectedSegmentIndex = 2;
    
    moneyVC.inputTxtField = inputTxtField;
    moneyVC.currencyControl = segCtrl;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [moneyVC performSelector:@selector(saveBtnPressed:) withObject:nil];
    
#pragma clang diagnostic pop
    
    XCTAssertEqualObjects(moneyVC.money, [DRGMoney poundWithAmount:50], @"Money added should be equal to GBP50");
}


- (void)testSaveBtnTriggerNotificationInAddingMode {
    
    DRGMoneyVC *moneyVC = [[DRGMoneyVC alloc] initWithMoney:nil];
    moneyVC.adding = YES;
    
    UITextField *inputTxtField = [[UITextField alloc] init];
    inputTxtField.text = @"13.13";
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
        XCTAssertEqualObjects([DRGMoney euroWithAmount:13.13], value, @"");
        return YES;
    }]];
     
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wundeclared-selector"
 
     [moneyVC performSelector:@selector(saveBtnPressed:) withObject:nil];
 
 #pragma clang diagnostic pop
     
     [observerMock verify];
     [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

- (void)testSaveBtnTriggerNotificationInSubtractionMode {
    
    DRGMoneyVC *moneyVC = [[DRGMoneyVC alloc] initWithMoney:nil];
    moneyVC.adding = NO;
    
    UITextField *inputTxtField = [[UITextField alloc] init];
    inputTxtField.text = @"13.13";
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"EUR", @"USD", @"GBP"]];
    segCtrl.selectedSegmentIndex = 0;
    
    moneyVC.inputTxtField = inputTxtField;
    moneyVC.currencyControl = segCtrl;
    
    NSString *notificationName = @"DID_REMOVE_MONEY_NOTIFICATION";
    id observerMock = [OCMockObject observerMock];
    [[NSNotificationCenter defaultCenter] addMockObserver:observerMock name:notificationName object:moneyVC];
    [[observerMock expect] notificationWithName:notificationName object:moneyVC
                                       userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
        id value = [userInfo objectForKey:MONEY_KEY];
        XCTAssertEqualObjects([DRGMoney euroWithAmount:13.13], value, @"");
        return YES;
    }]];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [moneyVC performSelector:@selector(saveBtnPressed:) withObject:nil];
    
#pragma clang diagnostic pop
    
    [observerMock verify];
    [[NSNotificationCenter defaultCenter] removeObserver:observerMock];
}

@end
