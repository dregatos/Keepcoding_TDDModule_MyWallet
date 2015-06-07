//
//  DRGMoneyVC.m
//  MyWallet
//
//  Created by David Regatos on 07/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGMoneyVC.h"

#import "DRGMoney.h"

#import "NotificationKeys.h"

@interface DRGMoneyVC ()

@end

@implementation DRGMoneyVC

#pragma mark - View Events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Message Lbl
    if (self.isAdding) {
        self.messageLbl.text = @"Add some money to your wallet";
    } else {
        self.messageLbl.text = @"Take some money out of your wallet";
    }
    
    // Nav bar
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(saveBtnPressed:)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Input txtField
    [self.inputTxtField becomeFirstResponder];
}

#pragma mark - IBActions

- (void)saveBtnPressed:(UIBarButtonItem *)barBtn {
    
    // Create money
    NSInteger index = self.currencyControl.selectedSegmentIndex;
    NSString *currency = [self.currencyControl titleForSegmentAtIndex:index];
    double amount = [self.inputTxtField.text doubleValue];
    DRGMoney *money = [[DRGMoney alloc] initWithAmount:amount andCurrency:currency];
    
    // Notify if it is adding or removing money
    NSString *notificationName = self.isAdding ? DID_ADD_MONEY_NOTIFICATION : DID_REMOVE_MONEY_NOTIFICATION;
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:@{MONEY_KEY:money}];
    
    // Go back
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
