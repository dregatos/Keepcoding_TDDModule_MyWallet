//
//  DRGBroker.m
//  MyWallet
//
//  Created by David Regatos on 04/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGBroker.h"
#import "DRGMoney.h"

@interface DRGBroker ()

@property (nonatomic, strong) NSMutableDictionary *rates;

@end

@implementation DRGBroker

- (instancetype)init {
    if (self = [super init]) {
        _rates = [@{} mutableCopy];
    }
    return self;
}

- (DRGMoney *)reduce:(id<DRGMoney>)money toCurrency:(NSString *)currency {
    
    // double dispatch - Devuelvo la pregunta
    DRGMoney *new = [money reduceToCurrency:currency withBroker:self];
    return new;
}

- (void)addRate:(double)rate fromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency {
    
    [self.rates setObject:@(rate) forKey:[self keyFromCurrency:fromCurrency toCurrency:toCurrency]];
    [self.rates setObject:@(1.0/rate) forKey:[self keyFromCurrency:toCurrency toCurrency:fromCurrency]];
}

- (NSString *)keyFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency {
    return [NSString stringWithFormat:@"%@%@", fromCurrency, toCurrency];
}

@end
