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

- (id)initWithAmount:(double)amount andCurrency:(NSString *)currency {
    
    if (self = [super init]) {
        DRGMoney *money = [[DRGMoney alloc] initWithAmount:amount andCurrency:currency];
        _moneys = [NSMutableArray array];
        [_moneys addObject:money];
    }
    
    return self;
}

- (id<DRGMoney>)plus:(DRGMoney *)other {
    [self.moneys addObject:other];
    return self;
}

- (id<DRGMoney>)times:(double)multiplier {
    
    for (DRGMoney *money in self.moneys) {
        [money times:multiplier];
    }
    
    return self;
}

- (id<DRGMoney>)reduceToCurrency:(NSString *)currency withBroker:(DRGBroker *)broker {
    
    DRGMoney *result = [[DRGMoney alloc] initWithAmount:0 andCurrency:currency];
    
    for (DRGMoney *each in self.moneys) {
        result = [result plus:[each reduceToCurrency:currency withBroker:broker]];
    }
    
    return result;
}

@end
