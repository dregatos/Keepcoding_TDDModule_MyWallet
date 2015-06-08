//
//  DRGWallet.h
//  MyWallet
//
//  Created by David Regatos on 04/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRGMoney.h"


@interface DRGWallet : NSObject <DRGMoney>

- (NSUInteger)numberOfAvailableCurrencies;
- (NSArray *)availableCurrencies;          // returns an array of string. Ex: @[@"EUR",@"USD"...]

- (void)addMoney:(DRGMoney *)money;
- (void)substractMoney:(DRGMoney *)money withResult:(void(^)(BOOL success, NSError *error))resultBlock;  // == takeMoney:
- (void)substractAllMoneysWithCurrency:(NSString *)currency;
- (BOOL)canSubstractMoney:(DRGMoney *)money;

- (NSArray *)getMoneysWithCurrency:(NSString *)currency;
- (DRGMoney *)getTotalMoneyWithCurrency:(NSString *)currency;

- (void)emptyWallet;

@end
