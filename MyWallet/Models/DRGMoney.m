//
//  DRGMoney.m
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGMoney.h"
#import "NSObject+GNUStepAddons.h"

@interface DRGMoney ()

@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *amount;

@end

@implementation DRGMoney

#pragma mark - init

+ (id)euroWithAmount:(NSInteger)amount {
    return [[DRGMoney alloc] initWithAmount:amount andCurrency:@"EUR"];
}

+ (id)dollarWithAmount:(NSInteger)amount {
    return [[DRGMoney alloc] initWithAmount:amount andCurrency:@"USD"];
}

- (instancetype)initWithAmount:(NSInteger)amount andCurrency:(NSString *)currency {
    
    if (self = [super init]) {
        _amount = @(amount);
        _currency = currency;
    }
    return self;
}

#pragma mark - Operations

- (DRGMoney *)times:(NSInteger)multiplier {
    
    DRGMoney *new = [[DRGMoney alloc] initWithAmount:[self.amount integerValue] * multiplier andCurrency:self.currency];
    return new;
}

- (DRGMoney *)plus:(DRGMoney *)other {
    
    NSInteger totalAmount = [self.amount integerValue] + [other.amount integerValue];
    DRGMoney *total = [[DRGMoney alloc] initWithAmount:totalAmount andCurrency:self.currency];
    return total;
}


#pragma mark - Overwritten

- (NSString *)description {
    NSString *objDescription = [NSString stringWithFormat:@"%ld", (long)self.amount]; //Wrap the custom description here.
    return [NSString stringWithFormat:@"<%@: %@>", [self class], objDescription];
}

- (BOOL)isEqual:(id)object {
    
    if (self && object && [self.currency isEqual:[object currency]]) {
        return  [self amount] == [object amount];
    }
    
    return NO;
}

- (NSUInteger)hash {
    
    if ([self.currency isEqualToString:@"EUR"]) {
        
    }
    return (NSUInteger)[self amount];
}

@end
