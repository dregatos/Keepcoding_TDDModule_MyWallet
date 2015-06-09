//
//  DRGWalletTableVC.m
//  MyWallet
//
//  Created by David Regatos on 05/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGWalletTableVC.h"
#import "DRGMoneyVC.h"

#import "DRGWallet.h"
#import "DRGMoney.h"
#import "DRGBroker.h"

#import "NotificationKeys.h"


@interface DRGWalletTableVC ()

@property (nonatomic, strong) DRGWallet *wallet;
@property (nonatomic, strong) DRGBroker *broker;

@end

@implementation DRGWalletTableVC

#pragma mark - init

- (instancetype)initWithBroker:(DRGBroker *)aBroker andWallet:(DRGWallet *)aWallet {

    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _broker = aBroker;
        _wallet = aWallet;
    }
    
    return self;
}

#pragma mark - View Events

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Wallet";

    // NavBar buttons
    UIBarButtonItem *takeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Take"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(takeBtnPressed:)];
    self.navigationItem.leftBarButtonItem = takeBtn;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(addBtnPressed:)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Notifications **********************
    [self registerForNotifications];
}

#pragma mark - NSNotification

- (void)dealloc {
    [self unregisterForNotifications];
}

- (void)registerForNotifications {
    // Add your notification observer here
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyMoneyWasAdded:)
                                                 name:DID_ADD_MONEY_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyMoneyWasRemoved:)
                                                 name:DID_REMOVE_MONEY_NOTIFICATION
                                               object:nil];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)notifyMoneyWasAdded:(NSNotification *)notification {
    DRGMoney *money = (DRGMoney *)[notification.userInfo objectForKey:MONEY_KEY];
    [self.wallet addMoney:money];
    [self.tableView reloadData];
}

- (void)notifyMoneyWasRemoved:(NSNotification *)notification {
    DRGMoney *money = (DRGMoney *)[notification.userInfo objectForKey:MONEY_KEY];
    [self.wallet substractMoney:money withResult:^(BOOL success, NSError *error) {
        if (success) {
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                        message:error.localizedFailureReason
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil, nil] show];
        }
    }];
}

#pragma mark - IBActions

- (void)takeBtnPressed:(UIBarButtonItem *)barBtn {
    DRGMoneyVC *moneyVC = [[DRGMoneyVC alloc] initWithMoney:nil];
    [self.navigationController pushViewController:moneyVC animated:YES];
}

- (void)addBtnPressed:(UIBarButtonItem *)barBtn {
    DRGMoneyVC *moneyVC = [[DRGMoneyVC alloc] initWithMoney:nil];
    moneyVC.adding = YES;
    [self.navigationController pushViewController:moneyVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.wallet numberOfAvailableCurrencies] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([self isLastSection:section]) {  // last section
        return 1;
    } else {
        NSArray *currencies = [self.wallet availableCurrencies];
        return [[self.wallet getMoneysWithCurrency:currencies[section]] count] + 1;  // +1 for the total amount
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Regular Cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    DRGMoney *money = [self moneyAtIndexPath:indexPath];
    // Regular Cell
    cell.textLabel.text = [NSString stringWithFormat:@"%.02f", [money.amount doubleValue]];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    if ([self shouldMoney:money beShownInTotalSection:indexPath]) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    } else if ([self shouldMoney:money beShownInTotalRow:indexPath]) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    return cell;
}

#pragma mark - Table view delegates

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([self isLastSection:section]) {  // last section
        return @"TOTAL in EUROS";
    } else {
        NSArray *currencies = [self.wallet availableCurrencies];
        return currencies[section];
    }
}

#pragma mark - Helpers

- (DRGMoney *)moneyAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [self.wallet numberOfAvailableCurrencies]) {  // last section
        return [self.broker reduce:self.wallet toCurrency:@"EUR"];
    } else {
        NSArray *currencies = [self.wallet availableCurrencies];
        
        if (indexPath.row == [[self.wallet getMoneysWithCurrency:currencies[indexPath.section]] count] ) {
            return [self.wallet getTotalMoneyWithCurrency:currencies[indexPath.section]];
        }
        
        NSArray *moneyList = [self.wallet getMoneysWithCurrency:currencies[indexPath.section]];
        return moneyList[indexPath.row];
    }
}

- (BOOL)shouldMoney:(DRGMoney *)money beShownInTotalSection:(NSIndexPath *)indexPath {
    return indexPath.section == [self.wallet numberOfAvailableCurrencies];
}

- (BOOL)shouldMoney:(DRGMoney *)money beShownInTotalRow:(NSIndexPath *)indexPath {
    return indexPath.row == [[self.wallet getMoneysWithCurrency:money.currency] count];
}

- (BOOL)isLastSection:(NSUInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    return [self shouldMoney:nil beShownInTotalSection:indexPath];
}

@end
