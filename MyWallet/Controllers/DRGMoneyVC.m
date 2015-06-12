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

@property (nonatomic, readwrite) DRGMoney *money;

@end

@implementation DRGMoneyVC

#pragma mark - Init

- (instancetype)initWithMoney:(DRGMoney *)aMoney {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        _money = aMoney;
    }
    
    return self;
}

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
    
    [self notifyMoney:self.money toObservers:[NSNotificationCenter defaultCenter]];
    
    // Go back
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Notification

- (void)notifyMoney:(DRGMoney *)money toObservers:(NSNotificationCenter *)nc {
    // Notify if it is adding or removing money
    if (money) {
        NSString *notificationName = self.isAdding ? DID_ADD_MONEY_NOTIFICATION : DID_REMOVE_MONEY_NOTIFICATION;
        [nc postNotificationName:notificationName object:self userInfo:@{MONEY_KEY:money}];
    } else {
        // TODO - show an alert
    }
}

#pragma mark - Helpers

- (DRGMoney *)money {
    NSInteger index = self.currencyControl.selectedSegmentIndex;
    NSString *currency = [self.currencyControl titleForSegmentAtIndex:index];
    double amount = [self.inputTxtField.text doubleValue];
    
    return [[DRGMoney alloc] initWithAmount:amount andCurrency:currency];
}


@end
