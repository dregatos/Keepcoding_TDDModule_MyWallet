//
//  DRGBroker.h
//  MyWallet
//
//  Created by David Regatos on 04/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRGMoney.h"

@interface DRGBroker : NSObject

@property (nonatomic, readonly) NSMutableDictionary *rates;

- (void)addRate:(double)rate fromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency;
- (NSString *)keyFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency;

- (DRGMoney *)reduce:(id<DRGMoney>)money toCurrency:(NSString *)currency;

@end
