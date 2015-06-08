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
        _moneys = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Currencies

- (NSUInteger)numberOfAvailableCurrencies {
    return [[self availableCurrencies] count];
}

- (NSArray *)availableCurrencies {
    
    NSMutableArray *currencies = [NSMutableArray array];
    for (DRGMoney *each in self.moneys) {
        if (![currencies containsObject:each.currency]) {
            [currencies addObject:each.currency];
        }
    }
    
    return [[currencies sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] copy];
}

#pragma mark - Quering

- (DRGMoney *)getTotalMoneyWithCurrency:(NSString *)currency {
    
    DRGMoney *requested = [[DRGMoney alloc] initWithAmount:0 andCurrency:currency];
    for (DRGMoney *each in self.moneys) {
        if ([each.currency isEqualToString:currency]) {
            requested = [requested plus:each];
        }
    }
    
    return requested;
}

- (NSArray *)getMoneysWithCurrency:(NSString *)currency {
    
    NSMutableArray *extracted = [NSMutableArray array];
    for (DRGMoney *each in self.moneys) {
        if ([each.currency isEqualToString:currency]) {
            [extracted addObject:each];
        }
    }

    return [extracted copy];
}


#pragma mark - Operations

- (void)addMoney:(DRGMoney *)money {
    [self.moneys addObject:money];
}

- (void)substractMoney:(DRGMoney *)money withResult:(void(^)(BOOL success, NSError *error))resultBlock {
    
    DRGMoney *available = [self getTotalMoneyWithCurrency:money.currency];
    double pendingSubtrahend = [money.amount doubleValue];
    
    if ([self canSubstractMoney:money]) {
        while (pendingSubtrahend > 0 && available > 0 && [available.amount doubleValue] >= pendingSubtrahend) {
            for (int i=0; i<[self.moneys count]; i++) {
                if ([((DRGMoney *)self.moneys[i]).currency isEqualToString:money.currency]) {
                    double canSubstract = [((DRGMoney *)self.moneys[i]).amount doubleValue];
                    if (canSubstract > pendingSubtrahend) {
                        DRGMoney *substractedMoney = [[DRGMoney alloc] initWithAmount:pendingSubtrahend
                                                                          andCurrency:money.currency];
                        pendingSubtrahend -= pendingSubtrahend;
                        self.moneys[i] = [self.moneys[i] minus:substractedMoney];
                        
                    } else {
                        pendingSubtrahend -= [((DRGMoney *)self.moneys[i]).amount doubleValue];
                        [self.moneys removeObjectAtIndex:i];
                    }
                    
                    // update conditions
                    available = [self getTotalMoneyWithCurrency:money.currency];
                }
            }
        }
        
        if(resultBlock) resultBlock(YES,nil);
        
    } else {
        NSString *desc = @"Operation was unsuccessful.";
        NSString *reason = [NSString stringWithFormat:@"Your wallet only got %@%@", available.currency, available.amount];
        NSString *sugg = [NSString stringWithFormat:@"Try with an amount < %@", available.description];
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(desc, nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(sugg, nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"MYWALLET_SUBSTRACTION_ERROR"
                                             code:001
                                         userInfo:userInfo];
        if(resultBlock) resultBlock(NO,error);
    }
}

- (void)substractAllMoneysWithCurrency:(NSString *)currency {
    
    for (int i=0; i<[self.moneys count]; i++) {
        DRGMoney *each = self.moneys[i];
        if ([each.currency isEqualToString:currency]) {
            [self.moneys removeObjectAtIndex:i];
        }
    }
}

- (void)emptyWallet {
    self.moneys = [NSMutableArray array];
}

- (BOOL)canSubstractMoney:(DRGMoney *)money {
    DRGMoney *available = [self getTotalMoneyWithCurrency:money.currency];
    double pendingSubtrahend = [money.amount doubleValue];
    
    if ([available.amount doubleValue] > pendingSubtrahend) {
        return YES;
    }
    
    return NO;
}

#pragma mark - DRGMoney Protocol

- (DRGMoney *)reduceToCurrency:(NSString *)currency withBroker:(DRGBroker *)broker {
    
    DRGMoney *result = [[DRGMoney alloc] initWithAmount:0 andCurrency:currency];
    
    for (DRGMoney *each in self.moneys) {
        result = [result plus:[each reduceToCurrency:currency withBroker:broker]];
    }
    
    return result;
}

@end
