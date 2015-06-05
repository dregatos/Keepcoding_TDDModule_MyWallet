//
//  DRGWallet.m
//  MyWallet
//
//  Created by David Regatos on 04/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGWallet.h"
#import "DRGBroker.h"

@interface DRGWallet () 

@property (nonatomic, strong) NSMutableArray *moneys;

@end

@implementation DRGWallet

#pragma mark - init

- (instancetype)init {
    
    if (self = [super init]) {
        _moneys = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Operations

- (void)addMoney:(DRGMoney *)money {
    [self.moneys addObject:money];
}

- (DRGMoney *)takeAllMoneyWithCurrency:(NSString *)currency {
    
    DRGMoney *requested = [[DRGMoney alloc] initWithAmount:0 andCurrency:currency];
    for (DRGMoney *each in self.moneys) {
        if ([each.currency isEqualToString:currency]) {
            requested = [requested plus:each];
        }
    }
    
    return requested;
}

#pragma mark - DRGMoney Protocol

- (id<DRGMoney>)times:(double)multiplier {
    
    for (DRGMoney *money in self.moneys) {
        [money times:multiplier];
    }
    
    return self;
}

- (DRGMoney *)reduceToCurrency:(NSString *)currency withBroker:(DRGBroker *)broker {
    
    DRGMoney *result = [[DRGMoney alloc] initWithAmount:0 andCurrency:currency];
    
    for (DRGMoney *each in self.moneys) {
        result = [result plus:[each reduceToCurrency:currency withBroker:broker]];
    }
    
    return result;
}

@end
