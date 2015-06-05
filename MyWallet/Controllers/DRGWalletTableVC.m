//
//  DRGWalletTableVC.m
//  MyWallet
//
//  Created by David Regatos on 05/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGWalletTableVC.h"
#import "DRGWallet.h"
#import "DRGMoney.h"
#import "DRGBroker.h"

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.wallet numberOfAvailableCurrencies] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == [self.wallet numberOfAvailableCurrencies]) {  // last section
        return 1;
    } else {
        NSArray *currencies = [self.wallet availableCurrencies];
        return [[self.wallet getMoneyListWithCurrency:currencies[section]] count] + 1;  // +1 for the total amount
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", money.currency,
                           [NSString stringWithFormat:@"%.02f", [money.amount doubleValue]]];
    
    return cell;
}

#pragma mark - Table view delegates

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == [self.wallet numberOfAvailableCurrencies]) {  // last section
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
        
        if (indexPath.row == [[self.wallet getMoneyListWithCurrency:currencies[indexPath.section]] count] ) {
            return [self.wallet getTotalMoneyWithCurrency:currencies[indexPath.section]];
        }
        
        
        NSArray *moneyList = [self.wallet getMoneyListWithCurrency:currencies[indexPath.section]];
        return moneyList[indexPath.row];
    }
}

@end
