//
//  DRGMoney.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGMoney.h"
#import "DRGBroker.h"

@interface DRGMoney ()

@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *amount;

@end

@implementation DRGMoney

#pragma mark - init

+ (instancetype)euroWithAmount:(double)amount {
    return [[DRGMoney alloc] initWithAmount:amount andCurrency:@"EUR"];
}

+ (instancetype)dollarWithAmount:(double)amount {
    return [[DRGMoney alloc] initWithAmount:amount andCurrency:@"USD"];
}

+ (instancetype)poundWithAmount:(double)amount {
    return [[DRGMoney alloc] initWithAmount:amount andCurrency:@"GBP"];
}

- (instancetype)initWithAmount:(double)amount andCurrency:(NSString *)currency {
    
    if (!currency || [currency isEqualToString:@""]) {
        return nil;
    }
    
    if (self = [super init]) {
        double rounded = round (amount * 100) / 100.0;
        _amount = [NSNumber numberWithDouble:rounded];
        _currency = currency;
    }
    return self;
}

#pragma mark - Operations

- (instancetype)times:(double)multiplier {
    
    DRGMoney *new = [[DRGMoney alloc] initWithAmount:[self.amount doubleValue] * multiplier andCurrency:self.currency];
    return new;
}

- (instancetype)plus:(DRGMoney *)other {
    
    if (![self.currency isEqualToString:other.currency]) {
        [NSException raise:@"SummandDifferentCurrencyException"
                    format:@"Augend (%@) must have same currency than Addend (%@)",self.currency, other.currency];
        return self;
    }
    
    double totalAmount = [self.amount doubleValue] + [other.amount doubleValue];
    DRGMoney *total = [[DRGMoney alloc] initWithAmount:totalAmount andCurrency:self.currency];
    return total;
}

- (instancetype)minus:(DRGMoney *)other {
    
    double newAmount = [self.amount doubleValue] - [other.amount doubleValue];

    if (newAmount < 0) {
        [NSException raise:@"SubtrahendBiggerThanMinuendException"
                    format:@"Subtrahend (%f) must be < than Minuend (%f)",[other.amount doubleValue], [self.amount doubleValue]];
        return self;
    }
    
    DRGMoney *total = [[DRGMoney alloc] initWithAmount:newAmount andCurrency:self.currency];
    return total;
}

#pragma mark - DRGMoney Protocol

- (DRGMoney *)reduceToCurrency:(NSString *)currency withBroker:(DRGBroker *)broker {
    
    NSNumber *rate = [broker.rates objectForKey:[broker keyFromCurrency:self.currency toCurrency:currency]];
    
    if ([self.currency isEqualToString:currency]) {
        return self;
    } else if (!rate && ![rate isEqual:@(0)]) {
        // No hay tasa de conversión
        [NSException raise:@"NoConversionRateException"
                    format:@"Must have a conversion from %@ to %@", self.currency, currency];
        return nil;
    } else {
        double rateValue = [rate doubleValue];
        
        double newAmount = rateValue * [self.amount doubleValue];
        
        return [[DRGMoney alloc] initWithAmount:newAmount andCurrency:currency];
    }
}

#pragma mark - Overwritten

- (NSString *)description {
    NSString *objDescription = [NSString stringWithFormat:@"%@%@",
                                self.currency, [NSString stringWithFormat:@"%.02f", [self.amount doubleValue]]];
    return [NSString stringWithFormat:@"<%@: %@>", [self class], objDescription];
}

- (BOOL)isEqual:(id)object {
    
    if (self && object && [self.currency isEqual:[object currency]]) {
//        NSLog(@"self.amount = %f",[self.amount doubleValue]);
//        NSLog(@"money.amount = %f",[((DRGMoney *)object).amount doubleValue]);
        return  [self.amount doubleValue] == [((DRGMoney *)object).amount doubleValue];
    }
    
    return NO;
}

- (NSUInteger)hash {
    return [self.amount doubleValue];
}

@end
