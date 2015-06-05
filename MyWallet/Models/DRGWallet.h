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

- (void)addMoney:(DRGMoney *)money;
- (DRGMoney *)takeAllMoneyWithCurrency:(NSString *)currency;

@end
