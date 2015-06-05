//
//  DRGMoney.h
//  MyWallet
//
//  Created by David Regatos on 02/06/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRGMoney;
@class DRGBroker;

@protocol DRGMoney <NSObject>

- (DRGMoney *)reduceToCurrency:(NSString *)currency withBroker:(DRGBroker *)broker;

@end

@interface DRGMoney : NSObject <DRGMoney>

@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly) NSNumber *amount;

+ (instancetype)euroWithAmount:(double)amount;
+ (instancetype)dollarWithAmount:(double)amount;

- (instancetype)initWithAmount:(double)amount andCurrency:(NSString *)currency;
- (instancetype)times:(double)multiplier;
- (instancetype)plus:(DRGMoney *)other;

@end
